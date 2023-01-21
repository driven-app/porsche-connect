import Foundation

extension PorscheConnect {
  public func toggleDirectCharging(
    vin: String, capabilities: Capabilities, enable: Bool = true
  ) async throws -> (
    remoteCommandAccepted: RemoteCommandAccepted?, response: HTTPURLResponse
  ) {
    let headers = try await performAuthFor(application: .carControl)
    let url = networkRoutes.vehicleToggleDirectChargingURL(
      vin: vin, capabilities: capabilities, enable: enable)

    var result = try await networkClient.post(
      RemoteCommandAccepted.self, url: url, body: kBlankString, headers: headers,
      jsonKeyDecodingStrategy: .useDefaultKeys)
    result.data?.remoteCommand = .toggleDirectCharge
    return (remoteCommandAccepted: result.data, response: result.response)
  }
}
