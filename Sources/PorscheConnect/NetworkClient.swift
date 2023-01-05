import Foundation

// MARK: - Structs

struct NetworkClient {
  private let session: URLSession
  private let delegate: FixWatchOSCookiesURLSessionDataDelegate

  init(timeoutIntervalForRequest: TimeInterval = 30) {
    delegate = FixWatchOSCookiesURLSessionDataDelegate()
    let configuration = URLSessionConfiguration.default
    configuration.httpCookieAcceptPolicy = .always
    configuration.httpCookieStorage = .shared
    configuration.timeoutIntervalForRequest = timeoutIntervalForRequest
    session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
  }

  /// On watchOS, any network invocations made within `block` will have cookies injected across all HTTP redirects.
  /// Cookies are only injected for the lifetime of the block. Upon completion of the block all cookies will be released.
  func interceptCookiesOnWatchOS<T>(_ block: () async throws -> T) async throws -> T {
#if os(watchOS)
    delegate.interceptCookies = true
    let result = try await block()
    delegate.interceptCookies = false
    return result
#else
    return try await block()
#endif
  }

  // MARK: - Public

  func get<D: Decodable>(
    _ responseType: D.Type,
    url: URL,
    params: [String: String]? = nil,
    headers: [String: String]? = nil,
    parseResponseBody: Bool = true,
    jsonKeyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase
  ) async throws -> (data: D?, response: HTTPURLResponse) {
    let request = createRequest(
      url: url.addParams(params: params),
      method: HttpMethod.get.rawValue,
      headers: headers,
      contentType: .json,
      bodyData: nil
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
    jsonKeyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase
  ) async throws -> (data: D?, response: HTTPURLResponse) {
    let request = buildModifyingRequest(
      url: url.addParams(params: params),
      method: HttpMethod.post.rawValue,
      headers: headers,
      contentType: contentType,
      body: body
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
    bodyData: Data?
  ) -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = method
    request.allHTTPHeaderFields = headers
    request.addValue(contentType.mimeDescription, forHTTPHeaderField: "Content-Type")
    request.httpBody = bodyData
    return request
  }

  private func performRequest<D: Decodable>(
    _ responseType: D.Type,
    request: URLRequest,
    contentType: HttpRequestContentType = .json,
    parseResponseBody: Bool = true,
    jsonKeyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase
  ) async throws -> (D?, HTTPURLResponse) {
    let modifiedRequest = delegate.injectCookies(into: request)
    return try await withCheckedThrowingContinuation { continuation in
      let task = session.dataTask(with: modifiedRequest) { (data, response, error) in
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

        guard let data1 = data, error == nil, !data1.isEmpty, parseResponseBody else {
          continuation.resume(with: .success((nil, response)))
          return
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = jsonKeyDecodingStrategy
        decoder.dateDecodingStrategy = .iso8601

        do {
          let result = try decoder.decode(D.self, from: data1)
          continuation.resume(with: .success((result, response)))
        } catch {
          continuation.resume(with: .failure(error))
        }
      }

      task.resume()
    }
  }

  private func buildModifyingRequest<E: Encodable>(
    url: URL, method: String, headers: [String: String]?,
    contentType: HttpRequestContentType = .json, body: E?
  ) -> URLRequest {
    let bodyData: Data? = contentType == .json ? buildJsonBody(body: body) : body as? Data
    return createRequest(
      url: url, method: method, headers: headers, contentType: contentType, bodyData: bodyData)
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
