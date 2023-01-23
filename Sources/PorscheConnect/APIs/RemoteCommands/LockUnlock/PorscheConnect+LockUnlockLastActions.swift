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

/// Status of all doors on the car. Meant to be called after initiating a lock/unlock command.
public struct LockUnlockLastActions: Codable {
  public let vin: String
  public let doors: Doors
  public let rluResult: Int
  public let bsError: Int
}
