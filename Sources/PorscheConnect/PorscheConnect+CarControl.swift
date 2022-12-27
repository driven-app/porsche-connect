import Foundation

public extension PorscheConnect {
  
  func summary(vehicle: Vehicle) async throws -> (summary: Summary?, response: HTTPURLResponse?) {
    let application: Application = .carControl
    
    _ = try await authIfRequired(application: application)
    
    guard let auth = auths[application], let apiKey = auth.apiKey else { throw PorscheConnectError.AuthFailure }
    let headers = buildHeaders(accessToken: auth.accessToken, apiKey: apiKey, countryCode: environment.countryCode, languageCode: environment.languageCode)
    
    let result = try await networkClient.get(Summary.self, url: networkRoutes.vehicleSummaryURL(vehicle: vehicle), headers: headers, jsonKeyDecodingStrategy: .useDefaultKeys)
    return (summary: result.data, response: result.response)
  }
  
  func position(vehicle: Vehicle) async throws -> (position: Position?, response: HTTPURLResponse?) {
    let application: Application = .carControl
    
    _ = try await authIfRequired(application: application)
    
    guard let auth = auths[application], let apiKey = auth.apiKey else { throw PorscheConnectError.AuthFailure }
    let headers = buildHeaders(accessToken: auth.accessToken, apiKey: apiKey, countryCode: environment.countryCode, languageCode: environment.languageCode)
    
    let result = try await networkClient.get(Position.self, url: networkRoutes.vehiclePositionURL(vehicle: vehicle), headers: headers, jsonKeyDecodingStrategy: .useDefaultKeys)
    return (position: result.data, response: result.response)
  }
  
  func capabilities(vehicle: Vehicle) async throws -> (capabilities: Capabilities?, response: HTTPURLResponse?) {
    let application: Application = .carControl
    
    _ = try await authIfRequired(application: application)

    guard let auth = auths[application], let apiKey = auth.apiKey else { throw PorscheConnectError.AuthFailure }
    let headers = buildHeaders(accessToken: auth.accessToken, apiKey: apiKey, countryCode: environment.countryCode, languageCode: environment.languageCode)
    
    let result = try await networkClient.get(Capabilities.self, url: networkRoutes.vehicleCapabilitiesURL(vehicle: vehicle), headers: headers, jsonKeyDecodingStrategy: .useDefaultKeys)
    return (capabilities: result.data, response: result.response)
  }
  
  func emobility(vehicle: Vehicle, capabilities: Capabilities) async throws -> (emobility: Emobility?, response: HTTPURLResponse?) {
    let application: Application = .carControl
    
    _ = try await authIfRequired(application: application)
    
    guard let auth = auths[application], let apiKey = auth.apiKey else { throw PorscheConnectError.AuthFailure }
    let headers = buildHeaders(accessToken: auth.accessToken, apiKey: apiKey, countryCode: environment.countryCode, languageCode: environment.languageCode)

    let result = try await networkClient.get(Emobility.self, url: networkRoutes.vehicleEmobilityURL(vehicle: vehicle, capabilities: capabilities), headers: headers, jsonKeyDecodingStrategy: .useDefaultKeys)
    return (emobility: result.data, response: result.response)
  }
  
  func flash(vehicle: Vehicle, andHonk honk: Bool = false) async throws -> (remoteCommandAccepted: RemoteCommandAccepted?, response: HTTPURLResponse?) {
    let application: Application = .carControl
    
    _ = try await authIfRequired(application: application)
    
    guard let auth = auths[application], let apiKey = auth.apiKey else { throw PorscheConnectError.AuthFailure }
    let headers = buildHeaders(accessToken: auth.accessToken, apiKey: apiKey, countryCode: environment.countryCode, languageCode: environment.languageCode)
    let url = honk ? networkRoutes.vehicleHonkAndFlashURL(vehicle: vehicle) : networkRoutes.vehicleFlashURL(vehicle: vehicle)
    
    var result = try await networkClient.post(RemoteCommandAccepted.self, url: url, body: kBlankString, headers: headers, jsonKeyDecodingStrategy: .useDefaultKeys)
    result.data?.remoteCommand = .honkAndFlash
    return (remoteCommandAccepted: result.data, response: result.response)
  }
}
