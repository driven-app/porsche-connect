import Foundation
import SwiftUI

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

    // MARK: Properties

    public let name: String
    public let value: String
  }

  // MARK: -

  public struct VehiclePicture: Codable {

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
