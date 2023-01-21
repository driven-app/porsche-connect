import Foundation

extension PorscheConnect {

  public func checkStatus(
    vin: String,
    capabilities: Capabilities? = nil,
    remoteCommand: RemoteCommandAccepted
  ) async throws -> (
    status: RemoteCommandStatus?, response: HTTPURLResponse?
  ) {
    let headers = try await performAuthFor(application: .carControl)

    let result = try await networkClient.get(
      RemoteCommandStatus.self,
      url: urlForCommand(vin: vin, capabilities: capabilities, remoteCommand: remoteCommand),
      headers: headers, jsonKeyDecodingStrategy: .useDefaultKeys)
    return (status: result.data, response: result.response)
  }

  // MARK: - Private

  private func urlForCommand(
    vin: String, capabilities: Capabilities?, remoteCommand: RemoteCommandAccepted
  ) -> URL {
    switch remoteCommand.remoteCommand {
    case .honkAndFlash:
      return networkRoutes.vehicleHonkAndFlashRemoteCommandStatusURL(
        vin: vin, remoteCommand: remoteCommand)
    case .toggleDirectCharge:
      return networkRoutes.vehicleToggleDirectChargingRemoteCommandStatusURL(
        vin: vin, capabilities: capabilities, remoteCommand: remoteCommand)
    case .toggleDirectClimatisation:
      return networkRoutes.vehicleToggleDirectClimatisationRemoteCommandStatusURL(
        vin: vin, remoteCommand: remoteCommand)
    case .lock, .unlock:
      return networkRoutes.vehicleLockUnlockRemoteCommandStatusURL(
        vin: vin, remoteCommand: remoteCommand)
    case .none:
      return URL(string: kBlankString)!
    }
  }
}
