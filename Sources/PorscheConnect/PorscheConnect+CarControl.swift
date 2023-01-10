import Foundation

extension PorscheConnect {

  public func summary(vehicle: Vehicle) async throws -> (
    summary: Summary?, response: HTTPURLResponse
  ) {
    let headers = try await performAuthFor(application: .carControl)

    let result = try await networkClient.get(
      Summary.self, url: networkRoutes.vehicleSummaryURL(vehicle: vehicle), headers: headers,
      jsonKeyDecodingStrategy: .useDefaultKeys)
    return (summary: result.data, response: result.response)
  }

  public func position(vehicle: Vehicle) async throws -> (
    position: Position?, response: HTTPURLResponse
  ) {
    let headers = try await performAuthFor(application: .carControl)

    let result = try await networkClient.get(
      Position.self, url: networkRoutes.vehiclePositionURL(vehicle: vehicle), headers: headers,
      jsonKeyDecodingStrategy: .useDefaultKeys)
    return (position: result.data, response: result.response)
  }

  public func capabilities(vehicle: Vehicle) async throws -> (
    capabilities: Capabilities?, response: HTTPURLResponse
  ) {
    let headers = try await performAuthFor(application: .carControl)

    let result = try await networkClient.get(
      Capabilities.self, url: networkRoutes.vehicleCapabilitiesURL(vehicle: vehicle),
      headers: headers, jsonKeyDecodingStrategy: .useDefaultKeys)
    return (capabilities: result.data, response: result.response)
  }

  public func emobility(vehicle: Vehicle, capabilities: Capabilities) async throws -> (
    emobility: Emobility?, response: HTTPURLResponse
  ) {
    let headers = try await performAuthFor(application: .carControl)

    let result = try await networkClient.get(
      Emobility.self,
      url: networkRoutes.vehicleEmobilityURL(vehicle: vehicle, capabilities: capabilities),
      headers: headers, jsonKeyDecodingStrategy: .useDefaultKeys)
    return (emobility: result.data, response: result.response)
  }

  public func status(vehicle: Vehicle) async throws -> (
    status: Status?, response: HTTPURLResponse
  ) {
    let headers = try await performAuthFor(application: .api)

    let result = try await networkClient.get(
      Status.self, url: networkRoutes.vehicleStatusURL(vehicle: vehicle), headers: headers,
      jsonKeyDecodingStrategy: .useDefaultKeys)
    return (status: result.data, response: result.response)
  }

  public func flash(vehicle: Vehicle, andHonk honk: Bool = false) async throws -> (
    remoteCommandAccepted: RemoteCommandAccepted?, response: HTTPURLResponse
  ) {
    let headers = try await performAuthFor(application: .carControl)

    let url =
      honk
      ? networkRoutes.vehicleHonkAndFlashURL(vehicle: vehicle)
      : networkRoutes.vehicleFlashURL(vehicle: vehicle)

    var result = try await networkClient.post(
      RemoteCommandAccepted.self, url: url, body: kBlankString, headers: headers,
      jsonKeyDecodingStrategy: .useDefaultKeys)
    result.data?.remoteCommand = .honkAndFlash
    return (remoteCommandAccepted: result.data, response: result.response)
  }

  public func toggleDirectCharging(
    vehicle: Vehicle, capabilities: Capabilities, enable: Bool = true
  ) async throws -> (
    remoteCommandAccepted: RemoteCommandAccepted?, response: HTTPURLResponse
  ) {
    let headers = try await performAuthFor(application: .carControl)
    let url = networkRoutes.vehicleToggleDirectChargingURL(
      vehicle: vehicle, capabilities: capabilities, enable: enable)

    var result = try await networkClient.post(
      RemoteCommandAccepted.self, url: url, body: kBlankString, headers: headers,
      jsonKeyDecodingStrategy: .useDefaultKeys)
    result.data?.remoteCommand = .toggleDirectCharge
    return (remoteCommandAccepted: result.data, response: result.response)
  }
  
  public func toggleDirectClimatisation(
    vehicle: Vehicle, enable: Bool = true
  ) async throws -> (
    remoteCommandAccepted: RemoteCommandAccepted?, response: HTTPURLResponse
  ) {
    let headers = try await performAuthFor(application: .carControl)
    let url = networkRoutes.vehicleToggleDirectClimatisationURL(
      vehicle: vehicle, enable: enable)

    var result = try await networkClient.post(
      RemoteCommandAccepted.self, url: url, body: kBlankString, headers: headers,
      jsonKeyDecodingStrategy: .useDefaultKeys)
    result.data?.remoteCommand = .toggleDirectClimatisation
    return (remoteCommandAccepted: result.data, response: result.response)
  }

  public func lock(vehicle: Vehicle) async throws -> (
    remoteCommandAccepted: RemoteCommandAccepted?, response: HTTPURLResponse
  ) {
    let headers = try await performAuthFor(application: .carControl)
    let url = networkRoutes.vehicleLockUnlockURL(vehicle: vehicle, lock: true)

    var result = try await networkClient.post(
      RemoteCommandAccepted.self, url: url, body: kBlankString, headers: headers,
      jsonKeyDecodingStrategy: .useDefaultKeys)
    result.data?.remoteCommand = .lock
    return (remoteCommandAccepted: result.data, response: result.response)
  }

  public func unlock(vehicle: Vehicle, pin: String) async throws -> (
    remoteCommandAccepted: RemoteCommandAccepted?, response: HTTPURLResponse
  ) {
    let headers = try await performAuthFor(application: .carControl)
    let url = networkRoutes.vehicleLockUnlockURL(vehicle: vehicle, lock: false)

    let pinSecurity = try await networkClient.get(
      PinSecurity.self, url: url, headers: headers, jsonKeyDecodingStrategy: .useDefaultKeys
    ).data

    guard let pinSecurity = pinSecurity, let pinHash = pinSecurity.generateSecurityPinHash(pin: pin)
    else {
      throw PorscheConnectError.UnlockChallengeFailure
    }

    let unlockSecurity = UnlockSecurity(
      challenge: pinSecurity.challenge,
      securityPinHash: pinHash,
      securityToken: pinSecurity.securityToken)

    var result = try await networkClient.post(
      RemoteCommandAccepted.self, url: url, body: unlockSecurity, headers: headers,
      jsonKeyDecodingStrategy: .useDefaultKeys)

    switch result.data?.pcckErrorKey {
    case .lockedFor60Minutes:
      throw PorscheConnectError.lockedFor60Minutes
    case .incorrectPin:
      throw PorscheConnectError.IncorrectPin
    case .none:
      break
    }

    result.data?.remoteCommand = .unlock
    return (remoteCommandAccepted: result.data, response: result.response)
  }
}
