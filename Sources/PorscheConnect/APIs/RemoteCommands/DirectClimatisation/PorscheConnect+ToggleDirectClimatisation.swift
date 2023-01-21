import Foundation

extension PorscheConnect {
  public func toggleDirectClimatisation(
    vin: String, enable: Bool = true
  ) async throws -> (
    remoteCommandAccepted: RemoteCommandAccepted?, response: HTTPURLResponse
  ) {
    let headers = try await performAuthFor(application: .carControl)
    let url = networkRoutes.vehicleToggleDirectClimatisationURL(
      vin: vin, enable: enable)

    var result = try await networkClient.post(
      RemoteCommandAccepted.self, url: url, body: kBlankString, headers: headers,
      jsonKeyDecodingStrategy: .useDefaultKeys)
    result.data?.remoteCommand = .toggleDirectClimatisation
    return (remoteCommandAccepted: result.data, response: result.response)
  }
}
