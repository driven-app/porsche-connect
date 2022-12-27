import Foundation

public extension PorscheConnect {

  func auth(application: Application) async throws -> PorscheAuth {
    let loginToRetrieveCookiesResponse = try await loginToRetrieveCookies()
    guard loginToRetrieveCookiesResponse != nil else { throw PorscheConnectError.NoResult }

    let apiAuthCodeResult = try await getApiAuthCode(application: application)
    guard let codeVerifier = apiAuthCodeResult.codeVerifier,
          let code = apiAuthCodeResult.code else { throw PorscheConnectError.NoResult }

    let apiTokenResult = try await getApiToken(application: application, codeVerifier: codeVerifier, code: code)
    guard let porscheAuth = apiTokenResult.data,
          apiTokenResult.response != nil else { throw PorscheConnectError.NoResult }

    auths[application] = porscheAuth
    return porscheAuth
  }

  private func loginToRetrieveCookies() async throws -> HTTPURLResponse? {
    let loginBody = buildLoginBody(username: username, password: password)
    let result = try await networkClient.post(String.self, url: networkRoutes.loginAuthURL, body: buildPostFormBodyFrom(dictionary: loginBody), contentType: .form, parseResponseBody: false)
    if let response = result.response,
       let statusCode = HttpStatusCode(rawValue: response.statusCode),
       statusCode == .OK { AuthLogger.info("Login to retrieve cookies successful") }

    return result.response
  }

  private func getApiAuthCode(application: Application) async throws -> (code: String?, codeVerifier: String?, response: HTTPURLResponse?) {
    let codeVerifier = codeChallenger.generateCodeVerifier()! //TODO: handle null
    AuthLogger.debug("Code Verifier: \(codeVerifier)")

    let apiAuthParams = buildApiAuthParams(clientId: application.clientId, redirectURL: application.redirectURL, codeVerifier: codeVerifier)
    let result = try await networkClient.get(String.self, url: networkRoutes.apiAuthURL, params: apiAuthParams, parseResponseBody: false)
    if let response = result.response, let url = response.value(forHTTPHeaderField: "cdn-original-uri"),
       let code = URLComponents(string: url)?.queryItems?.first(where: {$0.name == "code"})?.value {
      AuthLogger.info("Api Auth call for code successful")
      return (code, codeVerifier, response)
    } else {
      throw PorscheConnectError.AuthFailure
    }
  }

  private func getApiToken(application: Application, codeVerifier: String, code: String) async throws -> (data: PorscheAuth?, response: HTTPURLResponse?) {
    let apiTokenBody = buildApiTokenBody(clientId: application.clientId, redirectURL: application.redirectURL, code: code, codeVerifier: codeVerifier)
    let result = try await networkClient.post(PorscheAuth.self, url: networkRoutes.apiTokenURL, body: buildPostFormBodyFrom(dictionary: apiTokenBody), contentType: .form)
    if let response = result.response,
       let statusCode = HttpStatusCode(rawValue: response.statusCode),
       statusCode == .OK { AuthLogger.info("Api Auth call for token successful") }

    return result
  }

  private func buildLoginBody(username: String, password: String) -> Dictionary<String, String> {
    return ["username": username,
            "password": password,
            "keeploggedin": "false",
            "sec": "",
            "resume": "",
            "thirdPartyId": "",
            "state": ""]
  }

  private func buildApiAuthParams(clientId: String, redirectURL: URL, codeVerifier: String) -> Dictionary<String, String> {
    let codeChallenge = codeChallenger.codeChallenge(for: codeVerifier)! //TODO: Handle null
    AuthLogger.debug("Code Challenge: \(codeChallenge)")

    return ["client_id": clientId,
            "redirect_uri": redirectURL.absoluteString,
            "code_challenge": codeChallenge,
            "scope": "openid",
            "response_type": "code",
            "access_type": "offline",
            "prompt": "none",
            "code_challenge_method": "S256"]
  }

  private func buildApiTokenBody(clientId: String, redirectURL: URL, code: String, codeVerifier: String) -> Dictionary<String, String> {
    return ["client_id": clientId,
            "redirect_uri": redirectURL.absoluteString,
            "code": code,
            "code_verifier": codeVerifier,
            "prompt": "none",
            "grant_type": "authorization_code"]
  }
}
