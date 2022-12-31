import Foundation

extension PorscheConnect {

  public func checkStatus(vehicle: Vehicle, capabilities: Capabilities? = nil,
                          remoteCommand: RemoteCommandAccepted) async throws -> (
    status: RemoteCommandStatus?, response: HTTPURLResponse?
  ) {
    let application: OAuthApplication = .carControl

    _ = try await authIfRequired(application: application)

    guard let auth = auths[application], let apiKey = auth.apiKey else {
      throw PorscheConnectError.AuthFailure
    }
    let headers = buildHeaders(
      accessToken: auth.accessToken, apiKey: apiKey, countryCode: environment.countryCode,
      languageCode: environment.languageCode)

    let result = try await networkClient.get(
      RemoteCommandStatus.self, url: urlForCommand(vehicle: vehicle, capabilities: capabilities, remoteCommand: remoteCommand),
      headers: headers, jsonKeyDecodingStrategy: .useDefaultKeys)
    return (status: result.data, response: result.response)
  }

  // MARK: - Private

  private func urlForCommand(vehicle: Vehicle, capabilities: Capabilities?, remoteCommand: RemoteCommandAccepted) -> URL {
    switch remoteCommand.remoteCommand {
    case .honkAndFlash:
      return networkRoutes.vehicleHonkAndFlashRemoteCommandStatusURL(
        vehicle: vehicle, remoteCommand: remoteCommand)
    case .toggleDirectCharge:
      return networkRoutes.vehicleToggleDirectChargingRemoteCommandStatusURL(
        vehicle: vehicle, capabilities: capabilities, remoteCommand: remoteCommand)
    case .none:
      return URL(string: kBlankString)!
    }
  }
}
