import Foundation

extension PorscheConnect {

  public func auth(application: OAuthApplication) async throws -> OAuthToken {
    let apiAuthCodeResult = try await getApiAuthCode(application: application)
    guard let codeVerifier = apiAuthCodeResult.codeVerifier,
      let code = apiAuthCodeResult.code
    else { throw PorscheConnectError.NoResult }

    let apiTokenResult = try await getApiToken(
      application: application, codeVerifier: codeVerifier, code: code)
    guard let porscheAuth = apiTokenResult.data,
      apiTokenResult.response != nil
    else { throw PorscheConnectError.NoResult }

    let token = OAuthToken(authResponse: porscheAuth)
    auths[application] = token
    return token
  }

  private func getApiAuthCode(application: OAuthApplication) async throws -> (
    code: String?, codeVerifier: String?, response: HTTPURLResponse?
  ) {
    let codeVerifier = codeChallenger.generateCodeVerifier()!  //TODO: handle null
    AuthLogger.debug("Code Verifier: \(codeVerifier)")

    let apiAuthParams = buildApiAuthParams(
      clientId: application.clientId, redirectURL: application.redirectURL,
      codeVerifier: codeVerifier)
    let result = try await networkClient.get(
      String.self, url: networkRoutes.apiAuthURL, params: apiAuthParams, parseResponseBody: false)
    if let url = result.response.value(forHTTPHeaderField: "cdn-original-uri"),
      let code = URLComponents(string: url)?.queryItems?.first(where: { $0.name == "code" })?.value
    {
      AuthLogger.info("Api Auth call for code successful")
      return (code, codeVerifier, result.response)
    } else {
      throw PorscheConnectError.AuthFailure
    }
  }

  private func getApiToken(application: OAuthApplication, codeVerifier: String, code: String)
    async throws -> (data: AuthResponse?, response: HTTPURLResponse?)
  {
    let apiTokenBody = buildApiTokenBody(
      clientId: application.clientId, redirectURL: application.redirectURL, code: code,
      codeVerifier: codeVerifier)
    let result = try await networkClient.post(
      AuthResponse.self, url: networkRoutes.apiTokenURL,
      body: buildPostFormBodyFrom(dictionary: apiTokenBody), contentType: .form)
    if let statusCode = HttpStatusCode(rawValue: result.response.statusCode),
      statusCode == .OK
    {
      AuthLogger.info("Api Auth call for token successful")
    }

    return result
  }

  private func buildLoginBody(username: String, password: String) -> [String: String] {
    return [
      "username": username,
      "password": password,
      "keeploggedin": "false",
      "sec": "",
      "resume": "",
      "thirdPartyId": "",
      "state": "",
    ]
  }

  private func buildApiAuthParams(clientId: String, redirectURL: URL, codeVerifier: String)
    -> [String: String]
  {
    let codeChallenge = codeChallenger.codeChallenge(for: codeVerifier)!  //TODO: Handle null
    AuthLogger.debug("Code Challenge: \(codeChallenge)")

    return [
      "client_id": clientId,
      "redirect_uri": redirectURL.absoluteString,
      "code_challenge": codeChallenge,
      "scope": "openid",
      "response_type": "code",
      "access_type": "offline",
      "prompt": "none",
      "code_challenge_method": "S256",
    ]
  }

  private func buildApiTokenBody(
    clientId: String, redirectURL: URL, code: String, codeVerifier: String
  ) -> [String: String] {
    return [
      "client_id": clientId,
      "redirect_uri": redirectURL.absoluteString,
      "code": code,
      "code_verifier": codeVerifier,
      "prompt": "none",
      "grant_type": "authorization_code",
    ]
  }
}
