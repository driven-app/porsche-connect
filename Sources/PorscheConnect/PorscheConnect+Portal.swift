import Foundation

extension PorscheConnect {

  public func vehicles() async throws -> (vehicles: [Vehicle]?, response: HTTPURLResponse?) {
    let application: Application = .api

    _ = try await authIfRequired(application: application)

    guard let auth = auths[application], let apiKey = auth.apiKey else {
      throw PorscheConnectError.AuthFailure
    }
    let headers = buildHeaders(
      accessToken: auth.accessToken, apiKey: apiKey, countryCode: environment.countryCode,
      languageCode: environment.languageCode)

    let result = try await networkClient.get(
      [Vehicle].self, url: networkRoutes.vehiclesURL, headers: headers,
      jsonKeyDecodingStrategy: .useDefaultKeys)
    return (vehicles: result.data, response: result.response)
  }
}
