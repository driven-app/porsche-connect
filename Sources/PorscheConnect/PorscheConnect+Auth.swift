import Foundation

public extension PorscheConnect {
  
  //  func auth(success: Success? = nil, failure: Failure? = nil) {
  
  func auth(completion: @escaping (Result<PorscheAuth, Error>) -> Void) {
    let apiAuthTokenCompletion = { (porscheAuth: PorscheAuth?, error: PorscheConnectError?, response: HTTPURLResponse?) -> Void in
      DispatchQueue.main.async {
        if let porscheAuth = porscheAuth {
          self.auth = porscheAuth
          completion(.success(porscheAuth))
        } else if let error = error {
          completion(.failure(error))
        }
      }
    }
    
    let apiAuthCompletion = { (code: String?, codeVerifier: String?, error: PorscheConnectError?, response: HTTPURLResponse?) -> Void in
      if let codeVerifier = codeVerifier, let code = code {
        AuthLogger.debug("Auth: Code received: \(code)")
        self.getApiToken(codeVerifier: codeVerifier, code: code, completion: apiAuthTokenCompletion)
      } else if let error = error {
        DispatchQueue.main.async {
          completion(.failure(error))
        }
      }
    }
    
    let loginToRetrieveCookiesCompletion = { (error: PorscheConnectError?, response: HTTPURLResponse?) -> Void in
      if let error = error {
        DispatchQueue.main.async {
          completion(.failure(error))
        }
      } else {
        self.getApiAuthCode(completion: apiAuthCompletion)
      }
    }
    
    loginToRetrieveCookies(completion: loginToRetrieveCookiesCompletion)
  }
  
  private func loginToRetrieveCookies(completion: @escaping ((PorscheConnectError?, HTTPURLResponse?) -> Void)) {
    let loginBody = buildLoginBody(username: username, password: password)
    networkClient.post(String.self, url: networkRoutes.loginAuthURL, body: buildPostFormBodyFrom(dictionary: loginBody), contentType: .form, parseResponseBody: false) { (_, response, error, _) in
      
      DispatchQueue.main.async {
        if error != nil {
          completion(PorscheConnectError.AuthFailure, response)
        } else {
          AuthLogger.info("Auth: Login to retrieve cookies successful")
          completion(nil, nil)
        }
      }
    }
  }
  
  private func getApiAuthCode(completion: @escaping (_ code: String?, _ codeVerifier: String?, _ error: PorscheConnectError?, _ response: HTTPURLResponse?) -> Void) {
    let codeVerifier = codeChallenger.generateCodeVerifier()! //TODO: handle null
    AuthLogger.debug("Auth: Code Verifier: \(codeVerifier)")
    
    let apiAuthParams = buildApiAuthParams(clientId: Application.Portal.clientId, redirectURL: Application.Portal.redirectURL, codeVerifier: codeVerifier)
    networkClient.get(String.self, url: networkRoutes.apiAuthURL, params: apiAuthParams, parseResponseBody: false) { (_, response, error, _) in
      
      if let response = response,
         let url = response.value(forHTTPHeaderField: "cdn-original-uri"),
         let code = URLComponents(string: url)?.queryItems?.first(where: {$0.name == "code"})?.value {
        
        AuthLogger.info("Auth: Api Auth call for code successful")
        completion(code, codeVerifier, nil, response)
      } else {
        completion(nil, nil, PorscheConnectError.AuthFailure, response)
      }
    }
  }
  
  private func getApiToken(codeVerifier: String, code: String, completion: @escaping (_ poscheAuth: PorscheAuth?, _ error: PorscheConnectError?, _ response: HTTPURLResponse?) -> Void) {
    let apiTokenBody = buildApiTokenBody(clientId: Application.Portal.clientId, redirectURL: Application.Portal.redirectURL, code: code, codeVerifier: codeVerifier)
    networkClient.post(PorscheAuth.self, url: networkRoutes.apiTokenURL, body: buildPostFormBodyFrom(dictionary: apiTokenBody), contentType: .form) { (porscheAuth, response, error, responseJson) in
      
      if error != nil {
        completion(nil, PorscheConnectError.AuthFailure, response)
      } else {
        AuthLogger.info("Auth: Api Auth call for token successful")
        completion(porscheAuth, nil, response)
      }
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
    AuthLogger.debug("Auth: Code Challenge: \(codeChallenge)")
    
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
