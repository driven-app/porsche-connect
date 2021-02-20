import Foundation

// MARK: - Enums

public enum Environment: String {
  case Ireland, Germany, Test
  
  public var countryCode: String {
    switch self {
    case .Ireland:
      return "ie"
    case .Germany:
      return "de"
    case .Test:
      return "ie"
    }
  }
  
  public var languageCode: String {
    switch self {
    case .Ireland:
      return "en"
    case .Germany:
      return "de"
    case .Test:
      return "en"
    }
  }
  
  public var regionCode: String {
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
  case Portal, CarControl
  
  public var clientId: String {
    switch self {
    case .Portal:
      return "TZ4Vf5wnKeipJxvatJ60lPHYEzqZ4WNp"
    case .CarControl:
      return "gZLSI7ThXFB4d2ld9t8Cx2DBRvGr1zN2"
    }
  }
  
  public var redirectURL: URL {
    switch self {
    case .Portal:
      return URL(string: "https://my-static02.porsche.com/static/cms/auth.html")!
    case .CarControl:
      return URL(string: "https://connect-portal.porsche.com/myservices/auth/auth.htm")!
    }
  }
}

public enum PorscheConnectError: Error {
  case AuthFailure
  case NoResult
}

// MARK: - Structs

struct NetworkRoutes {
  let environment: Environment
  
  // MARK: - Calculated properties
  
  var loginAuthURL: URL {
    switch environment {
    case .Ireland, .Germany:
      return URL(string: "https://login.porsche.com/auth/api/v1/\(environment.regionCode)/public/login")!
    case .Test:
      return URL(string: "http://localhost:\(kTestServerPort)/auth/api/v1/\(environment.regionCode)/public/login")!
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
  
  var vehiclesURL: URL {
    switch environment {
    case .Ireland, .Germany:
      return URL(string: "https://connect-portal.porsche.com/core/api/v3/\(environment.regionCode)/vehicles")!
    case .Test:
      return URL(string: "http://localhost:\(kTestServerPort)/core/api/v3/\(environment.regionCode)/vehicles")!
    }
  }
  
  // MARK: - Functions
  
  func vehicleSummaryURL(vehicle: Vehicle) -> URL {
    switch environment {
    case .Ireland, .Germany:
      return URL(string: "https://api.porsche.com/service-vehicle/vehicle-summary/\(vehicle.vin)")!
    case .Test:
      return URL(string: "http://localhost:\(kTestServerPort)/service-vehicle/vehicle-summary/\(vehicle.vin)")!
    }
  }
}

// MARK: - Porsche Connect

public class PorscheConnect {
  
  let environment: Environment
  let username: String
  var auths: Dictionary<Application, PorscheAuth> = Dictionary()
  
  let networkClient = NetworkClient()
  let networkRoutes: NetworkRoutes
  let password: String
  let codeChallenger = CodeChallenger(length: 40)
  
  // MARK: - Init & configuration
  
  public init(username: String, password: String, environment: Environment = .Germany) {
    self.username = username
    self.password = password
    self.environment = environment
    self.networkRoutes = NetworkRoutes(environment: environment)
  }
  
  // MARK: - Common functions
  
  func authorized(application: Application) -> Bool {
    guard let auth = auths[application] else {
      return false
    }

    return !auth.expired
  }
  
  func buildHeaders(accessToken: String, apiKey: String, countryCode: String, languageCode: String) -> Dictionary<String, String> {
    return ["Authorization": "Bearer \(accessToken)",
            "apikey": apiKey,
            "x-vrs-url-country": countryCode,
            "x-vrs-url-language": "\(languageCode)_\(countryCode.uppercased())"]
  }
  
  func executeWithAuth(application: Application, closure: @escaping () -> Void) {
    if !authorized(application: application) {
      auth(application: application) { _ in
        closure()
      }
    } else {
      closure()
    }
  }
}
