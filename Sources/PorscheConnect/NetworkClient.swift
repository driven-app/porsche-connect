import Foundation

// MARK: - Typealias

public typealias ResponseJson = Data

// MARK: - Structs

struct NetworkClient {
  let session: URLSession
  
  init(timeoutIntervalForRequest:TimeInterval = 30) {
    let configuration = URLSessionConfiguration.default
    configuration.httpCookieAcceptPolicy = .always
    configuration.httpCookieStorage = .shared
    configuration.timeoutIntervalForRequest = timeoutIntervalForRequest
    self.session = URLSession(configuration: configuration)
  }
  
  // MARK: - Public
  
  func get<D: Decodable>(_ responseType: D.Type, url: URL, params: [String : String]? = nil, headers: [String : String]? = nil, completion: @escaping (D?, HTTPURLResponse?, Error?, ResponseJson?) -> Void) {
    let request = self.createCommonRequest(url: url.addParams(params: params), method: HttpMethod.get.rawValue, headers: headers, contentType: .json, bodyData: nil)
    self.performRequest(responseType, request: request, completion: completion)
  }
  
  func post<E: Encodable, D: Decodable>(_ responseType: D.Type, url: URL, params: [String : String]? = nil, body: E?, headers: [String : String]? = nil, contentType: HttpRequestContentType = .json, completion: @escaping (D?, HTTPURLResponse?, Error?, ResponseJson?) -> Void) {
    let request = self.buildModifyingRequest(url: url.addParams(params: params), method: HttpMethod.post.rawValue, headers: headers, contentType: contentType, body: body)
    self.performRequest(responseType, request: request, contentType: contentType, completion: completion)
  }
 
  
  // MARK: - Private
  
  private func createCommonRequest(url: URL, method: String, headers: [String : String]?, contentType: HttpRequestContentType, bodyData: Data?) -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = method
    if let headers = headers {
      for (key, value) in headers {
        request.addValue(value, forHTTPHeaderField: key)
      }
    }
  
    request.addValue(contentType.mimeDescription, forHTTPHeaderField: "Content-Type")
    request.httpBody = bodyData
    return request
  }
  
  private func performRequest<D: Decodable>(_ responseType: D.Type, request: URLRequest, contentType: HttpRequestContentType = .json, completion: @escaping (D?, HTTPURLResponse?, Error?, ResponseJson?) -> Void) {
    let task = self.session.dataTask(with: request) { (data, urlResponse, error) in
      let response = urlResponse as? HTTPURLResponse
      
      if let response = response {
        if self.isErrorStatusCode(response) {
          completion(nil, response, HttpStatusCode(rawValue: response.statusCode), nil)
          return
        }
      }
      
      guard let data = data, error == nil, !data.isEmpty else {
        completion(nil, response, error, nil)
        return
      }
      
      if contentType == .form {
        completion(nil, response, error, nil)
        return
      }
      
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .useDefaultKeys
      
      do {
        let result = try decoder.decode(D.self, from: data)
        completion(result, response, nil, data)
      } catch {
        completion(nil, response, error, nil)
      }
    }
    
    task.resume()
  }
  
  private func buildModifyingRequest<E: Encodable>(url: URL, method: String, headers: [String: String]?, contentType: HttpRequestContentType = .json ,body: E?) -> URLRequest {
    let bodyData: Data? = contentType == .json ? buildJsonBody(body: body) : body as? Data
    return createCommonRequest(url: url, method: method, headers: headers, contentType: contentType, bodyData: bodyData)
  }
  
  private func buildJsonBody<E: Encodable>(body: E?) -> Data? {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .useDefaultKeys
    return try? encoder.encode(body)
  }
  
  private func isErrorStatusCode(_ response: HTTPURLResponse) -> Bool {
    return response.statusCode >= 400
  }
}

// MARK: - Extensions & Utilities

public extension URL {  
  func addParams(params: [String: String]?) -> URL {
    guard let params = params else {
      return self
    }
    
    var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
    var queryItems = [URLQueryItem]()
    
    let existingQueryItems = query?.components(separatedBy: "&").map({
      $0.components(separatedBy: "=")
    }).reduce(into: [URLQueryItem](), { queryItems, pair in
      if pair.count == 2 {
        queryItems.append(URLQueryItem(name: pair[0], value: pair[1]))
      }
    })
    
    if let existingQueryItems = existingQueryItems {
      queryItems.append(contentsOf: existingQueryItems)
    }
    
    for (key, value) in params {
      queryItems.append(URLQueryItem(name: key, value: value))
    }
    
    urlComponents.queryItems = queryItems
    
    return urlComponents.url!
  }
}

public func buildPostFormBodyFrom(dictionary: [String: String]) -> Data {
  var urlComponents = URLComponents()
  urlComponents.queryItems = dictionary.map {
    URLQueryItem(name: $0.key, value: $0.value)
  }

  return urlComponents.query?.data(using: .utf8) ?? kBlankData
}
// MARK: - Enums

enum HttpMethod: String {
  case get = "GET"
  case post = "POST"
}

enum HttpRequestContentType: String {
  case json, form
    
  var mimeDescription: String {
    switch self {
    case .json:
      return "pplication/json"
    case .form:
    return "application/x-www-form-urlencoded"
    }
  }
}

enum HttpStatusCode: Int, Error {
  // 100 Informational
  case Continue = 100
  case SwitchingProtocols
  case Processing
  
  // 200 Success
  case OK = 200
  case Created
  case Accepted
  case NonAuthoritativeInformation
  case NoContent
  case ResetContent
  case PartialContent
  case MultiStatus
  case AlreadyReported
  case IMUsed = 226
  
  // 300 Redirection
  case MultipleChoices = 300
  case MovedPermanently
  case Found
  case SeeOther
  case NotModified
  case UseProxy
  case SwitchProxy
  case TemporaryRedirect
  case PermanentRedirect
  
  // 400 Client Error
  case BadRequest = 400
  case Unauthorized
  case PaymentRequired
  case Forbidden
  case NotFound
  case MethodNotAllowed
  case NotAcceptable
  case ProxyAuthenticationRequired
  case RequestTimeout
  case Conflict
  case Gone
  case LengthRequired
  case PreconditionFailed
  case PayloadTooLarge
  case URITooLong
  case UnsupportedMediaType
  case RangeNotSatisfiable
  case ExpectationFailed
  case ImATeapot
  case MisdirectedRequest = 421
  case UnprocessableEntity
  case Locked
  case FailedDependency
  case UpgradeRequired = 426
  case PreconditionRequired = 428
  case TooManyRequests
  case RequestHeaderFieldsTooLarge = 431
  case UnavailableForLegalReasons = 451
  
  // 500 Server Error
  case InternalServerError = 500
  case NotImplemented
  case BadGateway
  case ServiceUnavailable
  case GatewayTimeout
  case HTTPVersionNotSupported
  case VariantAlsoNegotiates
  case InsufficientStorage
  case LoopDetected
  case NotExtended = 510
  case NetworkAuthenticationRequired
  
  var localizedDescription: String {
    return String(rawValue)
  }
}
