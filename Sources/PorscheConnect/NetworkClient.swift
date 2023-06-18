import Foundation

// MARK: - Structs

struct NetworkClient {
  private let session: URLSession
  private let delegate: PorscheConnectURLSessionDataDelegate
  
  init(timeoutIntervalForRequest: TimeInterval = 30) {
    delegate = PorscheConnectURLSessionDataDelegate()
    let configuration = URLSessionConfiguration.ephemeral
    configuration.timeoutIntervalForRequest = timeoutIntervalForRequest
    session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
  }
  
  // MARK: - Public
  
  func get<D: Decodable>(
    _ responseType: D.Type,
    url: URL,
    params: [String: String]? = nil,
    headers: [String: String]? = nil,
    parseResponseBody: Bool = true,
    jsonKeyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase,
    shouldFollowRedirects followRedirects: Bool = true
  ) async throws -> (data: D?, response: HTTPURLResponse) {
    let request = createRequest(
      url: url.addParams(params: params),
      method: HttpMethod.get.rawValue,
      headers: headers,
      contentType: .json,
      bodyData: nil,
      shouldFollowRedirects: followRedirects
    )
    return try await performRequest(
      responseType, request: request, parseResponseBody: parseResponseBody,
      jsonKeyDecodingStrategy: jsonKeyDecodingStrategy)
  }
  
  func post<E: Encodable, D: Decodable>(
    _ responseType: D.Type,
    url: URL,
    params: [String: String]? = nil,
    body: E?,
    headers: [String: String]? = nil,
    contentType: HttpRequestContentType = .json,
    parseResponseBody: Bool = true,
    jsonKeyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase,
    shouldFollowRedirects followRedirects: Bool = true
  ) async throws -> (data: D?, response: HTTPURLResponse) {
    let request = buildModifyingRequest(
      url: url.addParams(params: params),
      method: HttpMethod.post.rawValue,
      headers: headers,
      contentType: contentType,
      body: body,
      shouldFollowRedirects: followRedirects
    )
    return try await performRequest(
      responseType, request: request, contentType: contentType,
      parseResponseBody: parseResponseBody, jsonKeyDecodingStrategy: jsonKeyDecodingStrategy)
  }
  
  // MARK: - Private
  
  private func createRequest(
    url: URL,
    method: String,
    headers: [String: String]?,
    contentType: HttpRequestContentType,
    bodyData: Data?,
    shouldFollowRedirects followRedirects: Bool? = nil
  ) -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = method
    request.allHTTPHeaderFields = headers
    request.addValue(contentType.mimeDescription, forHTTPHeaderField: "Content-Type")
    request.httpBody = bodyData
    
    if let followRedirects = followRedirects {
      request.setValue(followRedirects.description, forHTTPHeaderField: kRedirectHeader)
    }
    return request
  }
  
  private func performRequest<D: Decodable>(
    _ responseType: D.Type,
    request: URLRequest,
    contentType: HttpRequestContentType = .json,
    parseResponseBody: Bool = true,
    jsonKeyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase
  ) async throws -> (D?, HTTPURLResponse) {
    return try await withCheckedThrowingContinuation { continuation in
      let task = session.dataTask(with: request) { (data, response, error) in
        if let error = error {
          continuation.resume(with: .failure(error))
          return
        }
        guard let response = response as? HTTPURLResponse else {
          continuation.resume(with: .failure(PorscheConnectError.NoResult))
          return
        }
        
        if isErrorStatusCode(response) {
          continuation.resume(with: .failure(HttpStatusCode(rawValue: response.statusCode)!))
          return
        }
        
        guard let unwrappedData = data, error == nil, !unwrappedData.isEmpty, parseResponseBody else {
          continuation.resume(with: .success((nil, response)))
          return
        }
        
        switch responseType {
        case is String.Type:
          let result = String(data: unwrappedData, encoding: .utf8)! as! D
          continuation.resume(with: .success((result, response)))
        default:
          let decoder = JSONDecoder()
          decoder.keyDecodingStrategy = jsonKeyDecodingStrategy
          decoder.dateDecodingStrategy = .iso8601
          
          do {
            let result = try decoder.decode(D.self, from: unwrappedData)
            continuation.resume(with: .success((result, response)))
          } catch {
            continuation.resume(with: .failure(error))
          }
        }
      }
      
      task.resume()
    }
  }
  
  private func buildModifyingRequest<E: Encodable>(
    url: URL, method: String, headers: [String: String]?,
    contentType: HttpRequestContentType = .json, body: E?, shouldFollowRedirects followRedirects: Bool) -> URLRequest {
    let bodyData: Data? = contentType == .json ? buildJsonBody(body: body) : body as? Data
    return createRequest(
      url: url, method: method, headers: headers, contentType: contentType, bodyData: bodyData, shouldFollowRedirects: followRedirects)
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

// MARK: - Delegates

final class PorscheConnectURLSessionDataDelegate: NSObject, URLSessionDataDelegate {
  func urlSession(_ session: URLSession,
                  task: URLSessionTask,
                  willPerformHTTPRedirection response: HTTPURLResponse,
                  newRequest request: URLRequest,
                  completionHandler: @escaping (URLRequest?) -> Swift.Void) {
    
    guard let headerValue = task.currentRequest?.value(forHTTPHeaderField: kRedirectHeader) else {
      completionHandler(request)
      return
    }
    
    let shoudFollowRedirects = NSString(string: headerValue).boolValue
    let completionHandlerRequest = shoudFollowRedirects ? request : nil
    completionHandler(completionHandlerRequest)
  }
}

// MARK: – Public utility functions

public func buildPostFormBodyFrom(dictionary: [String: String]) -> Data {
  var urlComponents = URLComponents()
  urlComponents.queryItems = dictionary.map {
    URLQueryItem(name: $0.key, value: $0.value)
  }
  
  return urlComponents.query?.data(using: .utf8) ?? kBlankData
}

// MARK: - Enums

private enum HttpMethod: String {
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
