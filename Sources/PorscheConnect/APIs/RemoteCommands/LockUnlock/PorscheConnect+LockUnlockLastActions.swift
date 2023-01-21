import Foundation

extension PorscheConnect {
  public func lockUnlockLastActions(vin: String) async throws -> (
    lastActions: LockUnlockLastActions?, response: HTTPURLResponse
  ) {
    let headers = try await performAuthFor(application: .carControl)
    let url = networkRoutes.vehicleLockUnlockLastActionsURL(vin: vin)

    let result = try await networkClient.get(
      LockUnlockLastActions.self, url: url, headers: headers,
      jsonKeyDecodingStrategy: .useDefaultKeys)
    return (lastActions: result.data, response: result.response)
  }
}
