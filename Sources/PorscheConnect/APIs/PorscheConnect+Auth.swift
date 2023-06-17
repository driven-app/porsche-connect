import Foundation
import SwiftSoup

extension PorscheConnect {
  
  public func auth(application: OAuthApplication) async throws -> OAuthToken {
    let initialStateResponse = try await getInitialStateFromAuthService()
    let sendAuthenticationDetailsResponse = try await sendAuthenticationDetails(state: initialStateResponse.state)
    let _ = try await followCallback(formNameValuePairs: sendAuthenticationDetailsResponse.formNameValuePairs)
    let resumeAuthResponse = try await resumeAuth()
    let accessTokenResponse = try await getAccessToken(code: resumeAuthResponse.code)
  
    let token =  OAuthToken(authResponse: accessTokenResponse.authResponse)
    try await authStorage.storeAuthentication(token: token, for: application.clientId)

    return token
  }
  
  // MARK: - Private functions
  
  private func getInitialStateFromAuthService() async throws -> (state: String, response: HTTPURLResponse?) {
    let result = try await networkClient.get(String.self, url: networkRoutes.loginAuth0URL, parseResponseBody: false, followRedirects: false)
    
    if let statusCode = HttpStatusCode(rawValue: result.response.statusCode), statusCode == .Found {
      AuthLogger.info("Initial state from auth service successful.")
    }
    
    guard let headerValue = result.response.value(forHTTPHeaderField: "Location"),
          let urlComponents = URLComponents(string: headerValue),
          let state = urlComponents.queryItems?.first(where: { $0.name == "state"})?.value
    else {
      AuthLogger.error("Could not find or process Location header from auth response.")
      throw PorscheConnectError.AuthFailure
    }
    
    return (state, result.response)
  }
  
  private func sendAuthenticationDetails(state: String) async throws -> (formNameValuePairs: [String : String], response: HTTPURLResponse?) {
    let loginBody = buildLoginBody(username: username, password: password, state: state)
    let result = try await networkClient.post(String.self, url: networkRoutes.usernamePasswordLoginAuth0URL, body: buildPostFormBodyFrom(dictionary: loginBody), contentType: .form)
    
    if let statusCode = HttpStatusCode(rawValue: result.response.statusCode), statusCode == .OK {
      AuthLogger.info("Authentication details sent successfully.")
    }
    
    guard let html = result.data else {
      AuthLogger.error("No HTML form data returned.")
      throw PorscheConnectError.AuthFailure
    }
    
    var hiddenFormNameValuePairs = [String:String]()
    
    let document = try SwiftSoup.parseBodyFragment(html)
    let elements: Elements = try document.select("input[type='hidden']")
    for element in elements {
      hiddenFormNameValuePairs[try element.attr("name")] = try element.attr("value")
    }
    
    return (hiddenFormNameValuePairs, result.response)
  }
  
  private func followCallback(formNameValuePairs: [String:String]) async throws -> HTTPURLResponse? {
    let result = try await networkClient.post(String.self, url: networkRoutes.callbackAuth0URL, body: buildPostFormBodyFrom(dictionary: formNameValuePairs), contentType: .form, parseResponseBody: false, followRedirects: false)
    
    if let statusCode = HttpStatusCode(rawValue: result.response.statusCode), statusCode == .Found {
      AuthLogger.info("Authentication details sent successfully.")
    }
    
    if !environment.testEnvironment {
      AuthLogger.info("About to sleep for \(kSleepDurationInSecs) seconds to give Porsche Auth0 service chance to process previous request.")
      try await Task.sleep(nanoseconds: UInt64(kSleepDurationInSecs * Double(NSEC_PER_SEC)))
      AuthLogger.info("Finished sleeping.")
    }
    
    return result.response
  }
  
  private func resumeAuth() async throws -> (code: String, response: HTTPURLResponse?) {
    let url = environment.testEnvironment ? networkRoutes.resumeAuth0URL : networkRoutes.loginAuth0URL
     let result = try await networkClient.get(String.self, url: url, parseResponseBody: false, followRedirects: false)
    
    if let statusCode = HttpStatusCode(rawValue: result.response.statusCode), statusCode == .Found {
      AuthLogger.info("Resume auth service successful.")
    }
    
    guard let headerValue = result.response.value(forHTTPHeaderField: "Location"),
          let urlComponents = URLComponents(string: headerValue),
          let code = urlComponents.queryItems?.first(where: { $0.name == "code"})?.value
    else {
      AuthLogger.error("Could not find or process Location header from auth response.")
      throw PorscheConnectError.AuthFailure
    }
    
    return (code, result.response)
  }
  
  private func getAccessToken(code: String) async throws -> (authResponse: AuthResponse, response:  HTTPURLResponse?) {
    let result = try await networkClient.post(AuthResponse.self, url: networkRoutes.accessTokenAuth0URL, body: buildPostFormBodyFrom(dictionary: buildAccessTokenBody(code: code)), contentType: .form)
    
    if let statusCode = HttpStatusCode(rawValue: result.response.statusCode), statusCode == .Found {
      AuthLogger.info("Retrieving access token successful.")
    }
    
    guard let authResponse = result.data else {
      AuthLogger.error("Could not map response to AuthResponse.")
      throw PorscheConnectError.AuthFailure
    }
    
    return (authResponse, result.response)
  }
  
  private func buildLoginBody(username: String, password: String, state: String) -> [String : String] {
    return [
      "sec": "high",
      "username": username,
      "password": password,
      "code_challenge_method": "S256",
      "redirect_uri": "https://my.porsche.com/",
      "ui_locales": "de-DE",
      "audience": "https://api.porsche.com",
      "client_id": "UYsK00My6bCqJdbQhTQ0PbWmcSdIAMig",
      "connection": "Username-Password-Authentication",
      "state": state,
      "tenant": "porsche-production",
      "response_type": "code"
    ]
  }
  
  private func buildAccessTokenBody(code: String) -> [String : String] {
    return [
      "client_id": OAuthApplication.api.clientId,
      "grant_type": "authorization_code",
      "code": code,
      "redirect_uri": OAuthApplication.api.redirectURL.description
    ]
  }
  
  public func auth0Raw() async throws {
    let loginUrl = URL(string: "https://identity.porsche.com/authorize?response_type=code&client_id=UYsK00My6bCqJdbQhTQ0PbWmcSdIAMig&code_challenge_method=S256&redirect_uri=https://my.porsche.com&uri_locales=de-DE&audience=https://api.porsche.com&scope=openid")!
    
    let result = try await networkClient.get(String.self, url: loginUrl, parseResponseBody: false, followRedirects: false)
    
    print()
    
    guard let headerValue = result.response.value(forHTTPHeaderField: "Location"), let locationUrlComponents = URLComponents(string: headerValue) else {
      throw PorscheConnectError.AuthFailure
    }
    
    guard let state = locationUrlComponents.queryItems?.first(where: { $0.name == "state"})?.value else {
      throw PorscheConnectError.AuthFailure
    }
    
    print("State: \(state)")
    
    // Post auth data
    
    let authBody = [
      "sec": "high",
      "username": username,
      "password": password,
      "code_challenge_method": "S256",
      "redirect_uri": OAuthApplication.api.redirectURL.description,
      "ui_locales": "de-DE",
      "audience": "https://api.porsche.com",
      "client_id": OAuthApplication.api.clientId,
      "connection": "Username-Password-Authentication",
      "state": state,
      "tenant": "porsche-production",
      "response_type": "code"
    ]
    
    let result2 = try await networkClient.post(String.self, url: URL(string: "https://identity.porsche.com/usernamepassword/login")!, body: buildPostFormBodyFrom(dictionary: authBody), contentType: .form)
    
    let body = result2.data!
    
    var verifyBody = [String:String]()
    
    let document = try SwiftSoup.parseBodyFragment(body)
    let elements: Elements = try document.select("input[type='hidden']")
    for element in elements {
      verifyBody[try element.attr("name")] = try element.attr("value")
    }
    
    print()
    
    // Follow callback
    
    let _ = try await networkClient.post(String.self, url: URL(string: "https://identity.porsche.com/login/callback")!, body: buildPostFormBodyFrom(dictionary: verifyBody), contentType: .form, parseResponseBody: false, followRedirects: false)
    
    print()
    
    //    guard let headerValue2 = result3.response.value(forHTTPHeaderField: "Location") else {
    //      throw PorscheConnectError.AuthFailure
    //    }
    
    try await Task.sleep(nanoseconds: UInt64(2.5 * Double(NSEC_PER_SEC)))
    
    // resume auth
    //    let result4 = try await networkClient.get(String.self, url: URL(string: "https://identify.porsche.com\(headerValue2)")!, parseResponseBody: false, followRedirects: false)
    let result4 = try await networkClient.get(String.self, url: loginUrl, parseResponseBody: false, followRedirects: false)
    
    guard let headerValue3 = result4.response.value(forHTTPHeaderField: "Location"), let locationUrlComponents2 = URLComponents(string: headerValue3) else {
      throw PorscheConnectError.AuthFailure
    }
    
    guard let code = locationUrlComponents2.queryItems?.first(where: { $0.name == "code"})?.value else {
      throw PorscheConnectError.AuthFailure
    }
    
    print("Code: \(code)")
    print()
    
    //    token endpoint
    let authBody2 = [
      "client_id": "UYsK00My6bCqJdbQhTQ0PbWmcSdIAMig",
      "grant_type": "authorization_code",
      "code": code,
      "redirect_uri": "https://my.porsche.com/"
    ]
    
    let result5 = try await networkClient.post(AuthResponse.self, url: URL(string: "https://identity.porsche.com/oauth/token")!, body: buildPostFormBodyFrom(dictionary: authBody2), contentType: .form)
    
    //    let authResponse = result5.data!
    //
    //    let jwt = try decode(jwt: authResponse.accessToken)
    //
    
    print(result5)
    
  }
}

// MARK: - Response types

/// A response from one of the Porsche Connect authorization endpoints.
///
/// This type is not meant to be stored to disk as it includes a relative time value that is only meaningful when
/// first decoded from the server. If you need to store an AuthResponse longer-term, use OAuthToken instead.
struct AuthResponse: Decodable {
  let accessToken: String
  let idToken: String
  let tokenType: String
  let scope: String
  let expiresIn: Double
}
