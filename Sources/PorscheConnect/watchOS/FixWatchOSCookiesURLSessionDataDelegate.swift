import Foundation

/// On watchOS, cookies are not saved and sent during HTTP redirect chains. This causes the authentication flow
/// to fail due to a lack of necessary cookies when attempting to fetch the API token.
/// To work around this, this delegate handles all redirects and manually tracks set cookies and injects those cookies
/// into subsequent requests.
/// See https://developer.apple.com/forums/thread/43818 for related bugs.
///
/// Note that this delegate is only required during the auth flow.
final class FixWatchOSCookiesURLSessionDataDelegate: NSObject, URLSessionDataDelegate {
  /// When enabled, cookies will be stored and injected into redirect requests.
  /// Changing this value will reset the cookie storage.
  var interceptCookies = false {
    didSet {
      cookieStorage.removeAll()
    }
  }

  private var cookieStorage: [String: HTTPCookie] = [:]

  // MARK: - URLSessionDataDelegate

  func urlSession(_ session: URLSession,
                  task: URLSessionTask,
                  willPerformHTTPRedirection response: HTTPURLResponse,
                  newRequest request: URLRequest) async -> URLRequest? {
    if !interceptCookies {
      return request
    }
    guard let responseUrl = response.url else {
      // Nothing for us to do here. Pass-through.
      return request
    }
    let cookies = HTTPCookie.cookies(
      withResponseHeaderFields: response.allHeaderFields as! [String: String],
      for: responseUrl
    )
    for cookie in cookies {
      let key = cookie.domain + cookie.path + cookie.name
      // It's important that we expire cookies as part of the auth flow. In some cases, redirects
      // will explicitly kill a cookie (e.g. CIAM.m) by setting the expiration date to the epoch.
      if let expiresDate = cookie.expiresDate, expiresDate < Date() {
        cookieStorage[key] = nil
        continue
      }
      cookieStorage[key] = cookie
    }

    return injectCookies(into: request)
  }

  func injectCookies(into request: URLRequest) -> URLRequest {
    if !interceptCookies {
      return request
    }
    var mutableRequest = request
    // Note that `addValue` can *not* be used here for an array of cookies because it creates a
    // malformed cookie string using `,` delimiters instead of required `; ` delimiters. We build
    // the cookie parameter by hand here to avoid that issue.
    mutableRequest.setValue(
      cookieStorage.values
        .map { "\($0.name)=\($0.value)" }
        .joined(separator: "; "),
      forHTTPHeaderField: "Cookie")
    return mutableRequest
  }
}
