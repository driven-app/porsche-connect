import Foundation

public extension PorscheConnect {

  // NOTE: subject to change when we handle our second remote command and determine a pattern
  func checkStatus(vehicle: Vehicle, remoteCommand: RemoteCommandAccepted) async throws -> (status: RemoteCommandStatus?, response: HTTPURLResponse?) {
    let application: Application = .carControl

    _ = try await authIfRequired(application: application)

    guard let auth = auths[application], let apiKey = auth.apiKey else { throw PorscheConnectError.AuthFailure }
    let headers = buildHeaders(accessToken: auth.accessToken, apiKey: apiKey, countryCode: environment.countryCode, languageCode: environment.languageCode)

    let result = try await networkClient.get(RemoteCommandStatus.self, url: networkRoutes.vehicleHonkAndFlashRemoteCommandStatusURL(vehicle: vehicle, remoteCommand: remoteCommand), headers: headers, jsonKeyDecodingStrategy: .useDefaultKeys)
    return (status: result.data, response: result.response)
  }
}
