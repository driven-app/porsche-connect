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
  public static let api = OAuthApplication(
    clientId: "4mPO3OE5Srjb1iaUGWsbqKBvvesya8oA",
    redirectURL: URL(string: "https://my.porsche.com/core/de/de_DE")!
  )
  public static let carControl = OAuthApplication(
    clientId: "Ux8WmyzsOAGGmvmWnW7GLEjIILHEztAs",
    redirectURL: URL(string: "https://my.porsche.com/myservices/auth/auth.html")!
  )
}

final class SimpleAuthStorage: AuthStoring {
  public var auths: [String: OAuthToken] = [:]

  func storeAuthentication(token: OAuthToken?, for key: String) {
    auths[key] = token
  }

  func authentication(for key: String) -> OAuthToken? {
    return auths[key]
  }
}

// MARK: - Porsche Connect

public class PorscheConnect {

  let environment: Environment
  let username: String
  var authStorage: AuthStoring

  let networkClient = NetworkClient()
  let networkRoutes: NetworkRoutes
  let password: String
  let codeChallenger = CodeChallenger()

  // MARK: - Init & configuration

  public init(
    username: String,
    password: String,
    environment: Environment = .germany,
    authStorage: AuthStoring
  ) {
    self.username = username
    self.password = password
    self.environment = environment
    self.networkRoutes = NetworkRoutes(environment: environment)
    self.authStorage = authStorage
  }

  convenience public init(
    username: String,
    password: String,
    environment: Environment = .germany
  ) {
    self.init(
      username: username,
      password: password,
      environment: environment,
      authStorage: SimpleAuthStorage()
    )
  }

  // MARK: - Common functions

  func authorized(application: OAuthApplication) -> Bool {
    guard let auth = authStorage.authentication(for: application.clientId) else {
      return false
    }

    return !auth.expired
  }

// MARK: – Internal functions

  internal func performAuthFor(application: OAuthApplication) async throws -> [String: String] {
    _ = try await authIfRequired(application: application)

    guard let auth = authStorage.authentication(for: application.clientId), let apiKey = auth.apiKey else {
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
