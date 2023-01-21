import Foundation

extension PorscheConnect {
  public func flash(vin: String, andHonk honk: Bool = false) async throws -> (
    remoteCommandAccepted: RemoteCommandAccepted?, response: HTTPURLResponse
  ) {
    let headers = try await performAuthFor(application: .carControl)

    let url =
    honk
    ? networkRoutes.vehicleHonkAndFlashURL(vin: vin)
    : networkRoutes.vehicleFlashURL(vin: vin)

    var result = try await networkClient.post(
      RemoteCommandAccepted.self, url: url, body: kBlankString, headers: headers,
      jsonKeyDecodingStrategy: .useDefaultKeys)
    result.data?.remoteCommand = .honkAndFlash
    return (remoteCommandAccepted: result.data, response: result.response)
  }
}
