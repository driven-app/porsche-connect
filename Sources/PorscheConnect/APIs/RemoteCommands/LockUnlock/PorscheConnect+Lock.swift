import Foundation

extension PorscheConnect {
  public func lock(vin: String) async throws -> (
    remoteCommandAccepted: RemoteCommandAccepted?, response: HTTPURLResponse
  ) {
    let headers = try await performAuthFor(application: .carControl)
    let url = networkRoutes.vehicleLockUnlockURL(vin: vin, lock: true)

    var result = try await networkClient.post(
      RemoteCommandAccepted.self, url: url, body: kBlankString, headers: headers,
      jsonKeyDecodingStrategy: .useDefaultKeys)
    result.data?.remoteCommand = .lock
    return (remoteCommandAccepted: result.data, response: result.response)
  }
}
