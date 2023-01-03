import Foundation

// MARK: - Enums

public enum PorscheConnectError: Error {
  case AuthFailure
  case NoResult
  case UnlockChallengeFailure
  case lockedFor60Minutes
  case IncorrectPin
}

// MARK: - Porsche-specific OAuth applications

extension OAuthApplication {
  static let api = OAuthApplication(
    clientId: "4mPO3OE5Srjb1iaUGWsbqKBvvesya8oA",
    redirectURL: URL(string: "https://my.porsche.com/core/de/de_DE")!
  )
  static let carControl = OAuthApplication(
    clientId: "Ux8WmyzsOAGGmvmWnW7GLEjIILHEztAs",
    redirectURL: URL(string: "https://my.porsche.com/myservices/auth/auth.html")!
  )
}

// MARK: - Porsche Connect

public class PorscheConnect {

  let environment: Environment
  let username: String
  var auths: [OAuthApplication: OAuthToken] = Dictionary()

  let networkClient = NetworkClient()
  let networkRoutes: NetworkRoutes
  let password: String
  let codeChallenger = CodeChallenger()

  // MARK: - Init & configuration

  public init(username: String, password: String, environment: Environment = .germany) {
    self.username = username
    self.password = password
    self.environment = environment
    self.networkRoutes = NetworkRoutes(environment: environment)
  }

  // MARK: - Common functions

  func authorized(application: OAuthApplication) -> Bool {
    guard let auth = auths[application] else {
      return false
    }

    return !auth.expired
  }

// MARK: – Internal functions

  internal func performAuthFor(application: OAuthApplication) async throws -> [String: String] {
    _ = try await authIfRequired(application: application)

    guard let auth = auths[application], let apiKey = auth.apiKey else {
      throw PorscheConnectError.AuthFailure
    }

    return [
      "Authorization": "Bearer \(auth.accessToken)",
      "apikey": apiKey,
      "x-vrs-url-country": environment.countryCode,
      "x-vrs-url-language": "\(environment.languageCode)_\(environment.countryCode.uppercased())",
    ]
  }

  // MARK: - Private functions

  private func authIfRequired(application: OAuthApplication) async throws {
    if !authorized(application: application) {
      do {
        _ = try await auth(application: application)
      } catch {
        throw PorscheConnectError.AuthFailure
      }
    }
  }
}
