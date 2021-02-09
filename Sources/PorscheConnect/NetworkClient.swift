import Foundation

// MARK: - Typealias

public typealias ResponseJson = Data

// MARK: - Structs

struct NetworkClient {
  private let session: URLSession
  
  init(timeoutIntervalForRequest:TimeInterval = 30) {
    let configuration = URLSessionConfiguration.default
    configuration.httpCookieAcceptPolicy = .always
    configuration.httpCookieStorage = .shared
    configuration.timeoutIntervalForRequest = timeoutIntervalForRequest
    self.session = URLSession(configuration: configuration)
  }
  
  // MARK: - Public
  
  func get<D: Decodable>(_ responseType: D.Type, url: URL, params: Dictionary<String, String>? = nil, headers: Dictionary<String, String>? = nil, parseResponseBody: Bool = true, jsonKeyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase, completion: @escaping (Result<(D?, HTTPURLResponse?), Error>) -> Void) {
    let request = self.createRequest(url: url.addParams(params: params), method: HttpMethod.get.rawValue, headers: headers, contentType: .json, bodyData: nil)
    self.performRequest(responseType, request: request, parseResponseBody: parseResponseBody, jsonKeyDecodingStrategy: jsonKeyDecodingStrategy, completion: completion)
  }
  
  func post<E: Encodable, D: Decodable>(_ responseType: D.Type, url: URL, params: Dictionary<String, String>? = nil, body: E?, headers: Dictionary<String, String>? = nil, contentType: HttpRequestContentType = .json, parseResponseBody: Bool = true, jsonKeyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase, completion: @escaping (Result<(D?, HTTPURLResponse?), Error>) -> Void) {
    let request = self.buildModifyingRequest(url: url.addParams(params: params), method: HttpMethod.post.rawValue, headers: headers, contentType: contentType, body: body)
    self.performRequest(responseType, request: request, contentType: contentType, parseResponseBody: parseResponseBody, jsonKeyDecodingStrategy: jsonKeyDecodingStrategy, completion: completion)
  }
  
  // MARK: - Private
  
  private func createRequest(url: URL, method: String, headers: Dictionary<String, String>?, contentType: HttpRequestContentType, bodyData: Data?) -> URLRequest {
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
  
  private func performRequest<D: Decodable>(_ responseType: D.Type, request: URLRequest, contentType: HttpRequestContentType = .json, parseResponseBody: Bool = true, jsonKeyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase, completion: @escaping (Result<(D?, HTTPURLResponse?), Error>) -> Void) {
    let task = self.session.dataTask(with: request) { (data, urlResponse, error) in
      DispatchQueue.main.async {
        let response = urlResponse as? HTTPURLResponse
        
        if let response = response {
          if self.isErrorStatusCode(response) {
            completion(.failure(HttpStatusCode(rawValue: response.statusCode) as! Error))
            return
          }
        }
        
        guard let data = data, error == nil, !data.isEmpty else {
          completion(.success((nil, response)))
          return
        }
        
        if !parseResponseBody {
          completion(.success((nil, response)))
          return
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = jsonKeyDecodingStrategy
        
        do {
          let result = try decoder.decode(D.self, from: data)
          completion(.success((result, response)))
        } catch {
          completion(.failure(error))
        }
      }
    }
    
    task.resume()
  }
  
  private func buildModifyingRequest<E: Encodable>(url: URL, method: String, headers: Dictionary<String, String>?, contentType: HttpRequestContentType = .json ,body: E?) -> URLRequest {
    let bodyData: Data? = contentType == .json ? buildJsonBody(body: body) : body as? Data
    return createRequest(url: url, method: method, headers: headers, contentType: contentType, bodyData: bodyData)
  }
  
  private func buildJsonBody<E: Encodable>(body: E?) -> Data? {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .useDefaultKeys
    encoder.outputFormatting = .sortedKeys
    
    return try? encoder.encode(body)
  }
  
  private func isErrorStatusCode(_ response: HTTPURLResponse) -> Bool {
    return response.statusCode >= 400
  }
}

public func buildPostFormBodyFrom(dictionary: Dictionary<String, String>) -> Data {
  var urlComponents = URLComponents()
  urlComponents.queryItems = dictionary.map {
    URLQueryItem(name: $0.key, value: $0.value)
  }
  
  return urlComponents.query?.data(using: .utf8) ?? kBlankData
}
// MARK: - Enums

fileprivate enum HttpMethod: String {
  case get = "GET"
  case post = "POST"
}

enum HttpRequestContentType: String {
  case json, form
  
  var mimeDescription: String {
    switch self {
    case .json:
      return "application/json"
    case .form:
      return "application/x-www-form-urlencoded"
    }
  }
}
