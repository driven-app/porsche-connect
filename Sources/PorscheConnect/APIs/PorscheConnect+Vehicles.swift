import Foundation
import SwiftUI

extension PorscheConnect {

  public func vehicles() async throws -> (vehicles: [Vehicle]?, response: HTTPURLResponse) {
    let headers = try await performAuthFor(application: .api)

    let result = try await networkClient.get(
      [Vehicle].self, url: networkRoutes.vehiclesURL, headers: headers,
      jsonKeyDecodingStrategy: .useDefaultKeys)
    return (vehicles: result.data, response: result.response)
  }
}

// MARK: - Response types

public struct Vehicle: Codable {

  // MARK: Properties

  public let vin: String
  public let modelDescription: String
  public let modelType: String
  public let modelYear: String
  public let exteriorColor: String?
  public let exteriorColorHex: String?
  public let attributes: [VehicleAttribute]?
  public let pictures: [VehiclePicture]?

  // MARK: Computed Properties

  public var color: Color? {
    if let hex = exteriorColorHex {
      return Color(hex: hex)
    }
    return nil
  }

  // MARK: -

  public struct VehicleAttribute: Codable {
    public init(name: String, value: String) {
      self.name = name
      self.value = value
    }

    // MARK: Properties

    public let name: String
    public let value: String
  }

  // MARK: -

  public struct VehiclePicture: Codable {
    public init(
      url: URL,
      view: String,
      size: Int,
      width: Int,
      height: Int,
      transparent: Bool,
      placeholder: String? = nil
    ) {
      self.url = url
      self.view = view
      self.size = size
      self.width = width
      self.height = height
      self.transparent = transparent
      self.placeholder = placeholder
    }

    // MARK: Properties

    public let url: URL
    public let view: String
    public let size: Int
    public let width: Int
    public let height: Int
    public let transparent: Bool
    public let placeholder: String?
  }

  // MARK: - Public

  public init(
    vin: String, modelDescription: String, modelType: String, modelYear: String,
    exteriorColor: String?, exteriorColorHex: String?, attributes: [VehicleAttribute]?,
    pictures: [VehiclePicture]?
  ) {
    self.vin = vin
    self.modelDescription = modelDescription
    self.modelType = modelType
    self.modelYear = modelYear
    self.exteriorColor = exteriorColor
    self.exteriorColorHex = exteriorColorHex
    self.attributes = attributes
    self.pictures = pictures
  }

  public init(vin: String, modelDescription: String, modelType: String, modelYear: String) {
    self.vin = vin
    self.modelDescription = modelDescription
    self.modelType = modelType
    self.modelYear = modelYear
    self.exteriorColor = nil
    self.exteriorColorHex = nil
    self.attributes = nil
    self.pictures = nil
  }

  public init(vin: String) {
    self.vin = vin
    self.modelDescription = kBlankString
    self.modelType = kBlankString
    self.modelYear = kBlankString
    self.exteriorColor = nil
    self.exteriorColorHex = nil
    self.attributes = nil
    self.pictures = nil
  }
}
