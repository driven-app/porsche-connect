import Foundation

public extension PorscheConnect {
  
  func auth(application: Application, completion: @escaping (Result<PorscheAuth, Error>) -> Void) {
    loginToRetrieveCookies { result in
      guard let result = try? result.get(), result.1 != nil else { completion(.failure(PorscheConnectError.NoResult)); return }
      
      self.getApiAuthCode(application: application) { result in
        guard let result = try? result.get(),
              let codeVerifier = result.codeVerifier,
              let code = result.code,
              result.1 != nil else { completion(.failure(PorscheConnectError.NoResult)); return }
        
        self.getApiToken(application: application, codeVerifier: codeVerifier, code: code) { result in
          guard let result = try? result.get(),
                let porscheAuth = result.0,
                result.1 != nil else { completion(.failure(PorscheConnectError.NoResult)); return }
          
          self.auths[application] = porscheAuth
          completion(.success(porscheAuth))
        }
      }
    }
  }
  
  private func loginToRetrieveCookies(completion: @escaping (Result<(String?, HTTPURLResponse?), Error>) -> Void) {
    let loginBody = buildLoginBody(username: username, password: password)
    networkClient.post(String.self, url: networkRoutes.loginAuthURL, body: buildPostFormBodyFrom(dictionary: loginBody), contentType: .form, parseResponseBody: false) { result in
      
      if let result = try? result.get() {
        if result.1 == nil { AuthLogger.info("Login to retrieve cookies successful") }
      }
      
      completion(result)
    }
  }
  
  private func getApiAuthCode(application: Application, completion: @escaping (Result<(code: String?, codeVerifier: String?, response: HTTPURLResponse?), PorscheConnectError>) -> Void) {
    let codeVerifier = codeChallenger.generateCodeVerifier()! //TODO: handle null
    AuthLogger.debug("Code Verifier: \(codeVerifier)")
    
    let apiAuthParams = buildApiAuthParams(clientId: application.clientId, redirectURL: application.redirectURL, codeVerifier: codeVerifier)
    networkClient.get(String.self, url: networkRoutes.apiAuthURL, params: apiAuthParams, parseResponseBody: false) { result in
      
      if let result = try? result.get(), let response = result.1,
         let url = response.value(forHTTPHeaderField: "cdn-original-uri"),
         let code = URLComponents(string: url)?.queryItems?.first(where: {$0.name == "code"})?.value {
        
        AuthLogger.info("Api Auth call for code successful")
        completion(.success((code, codeVerifier, response)))
      } else {
        completion(.failure(PorscheConnectError.AuthFailure))
      }
    }
  }
  
  private func getApiToken(application: Application, codeVerifier: String, code: String, completion: @escaping (Result<(PorscheAuth?, HTTPURLResponse?), Error>) -> Void) {
    let apiTokenBody = buildApiTokenBody(clientId: application.clientId, redirectURL: application.redirectURL, code: code, codeVerifier: codeVerifier)
    networkClient.post(PorscheAuth.self, url: networkRoutes.apiTokenURL, body: buildPostFormBodyFrom(dictionary: apiTokenBody), contentType: .form) { result in
      
      if let result = try? result.get() {
        if result.1 == nil { AuthLogger.info("Api Auth call for token successful") }
      }
      
      completion(result)
    }
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
