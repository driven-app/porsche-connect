import Foundation

// MARK: - Enums

public enum Environment: String {
  case Ireland, Germany, Test
  
  public var countryCode: String {
    switch self {
    case .Ireland:
      return "ie/en_GB"
    case .Germany:
      return "de/de_DE"
    case .Test:
      return "ie/en_IE"
    }
  }
}

public enum Application {
  case Portal
  
  public var clientId: String {
    switch self {
    case .Portal:
      return "TZ4Vf5wnKeipJxvatJ60lPHYEzqZ4WNp"
    }
  }
  
  public var redirectURL: URL {
    switch self {
    case .Portal:
      return URL(string: "https://my-static02.porsche.com/static/cms/auth.html")!
    }
  }
}

public enum PorscheConnectError: Error {
  case AuthFailure
}

// MARK: - Structs

public struct NetworkRoutes {
  let environment: Environment
  
  var loginAuthURL: URL {
    switch environment {
    case .Ireland, .Germany:
      return URL(string: "https://login.porsche.com/auth/api/v1/\(environment.countryCode)/public/login")!
    case .Test:
      return URL(string: "http://localhost:\(kTestServerPort)/auth/api/v1/\(environment.countryCode)/public/login")!
    }
  }
  
  var apiAuthURL: URL {
    switch environment {
    case .Ireland, .Germany:
      return URL(string: "https://login.porsche.com/as/authorization.oauth2")!
    case .Test:
      return URL(string: "http://localhost:\(kTestServerPort)/as/authorization.oauth2")!
    }
  }
  
  var apiTokenURL: URL {
    switch environment {
    case .Ireland, .Germany:
      return URL(string: "https://login.porsche.com/as/token.oauth2")!
    case .Test:
      return URL(string: "http://localhost:\(kTestServerPort)/as/token.oauth2")!
    }
  }
}

struct PorscheConnect {
  typealias Success = ((Any?, HTTPURLResponse?, ResponseJson?) -> Void)
  typealias Failure = ((Error, HTTPURLResponse?) -> Void)
  
  let environment: Environment
  let username: String
  private(set) var authorized: Bool
  
  private let networkClient = NetworkClient()
  private let networkRoutes: NetworkRoutes
  private let password: String
  private let codeChallenger = CodeChallenger(length: 40)
  
  // MARK: - Init & Configuration
  
  public init(environment: Environment, username: String, password: String) {
    self.environment = environment
    self.networkRoutes = NetworkRoutes(environment: environment)
    self.username = username
    self.password = password
    self.authorized = false
  }
  
  // MARK: - Request Token (Auth)
  
  public func requestToken(success: Success? = nil, failure: Failure? = nil) {
    let apiAuthTokenCompletion = { (porscheAuth: PorscheAuth?, error: PorscheConnectError?, response: HTTPURLResponse?) -> Void in
      
      if let porscheAuth = porscheAuth, let success = success {
        DispatchQueue.main.async {
          success(porscheAuth, response, nil)
        }
      }
    }
    
    let apiAuthCompletion = { (code: String?, codeVerifier: String?, error: PorscheConnectError?, response: HTTPURLResponse?) -> Void in
      if let codeVerifier = codeVerifier, let code = code {
        AuthLogger.debug("Auth: Code received: \(code)")
        getApiToken(codeVerifier: codeVerifier, code: code, completion: apiAuthTokenCompletion)
      }
    }
    
    let loginToRetrieveCookiesCompletion = { (error: PorscheConnectError?, response: HTTPURLResponse?) -> Void in
      getApiAuthCode(completion: apiAuthCompletion)
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
