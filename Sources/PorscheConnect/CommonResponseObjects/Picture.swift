import Foundation

public struct Picture: Codable {
  public init(
    url: URL,
    view: CameraView,
    size: Int,
    width: Int,
    height: Int,
    transparent: Bool,
    placeholder: String? = nil,
    environment: String? = nil
  ) {
    self.url = url
    self.view = view
    self.size = size
    self.width = width
    self.height = height
    self.transparent = transparent
    self.placeholder = placeholder
    self.environment = environment
  }

  // MARK: Properties

  public let url: URL
  public enum CameraView: String, Codable {
    case front = "extcam01"
    case side = "extcam02"
    case rear = "extcam03"
    case topAngled = "extcam04"
    case overhead = "extcam05"
    case dashboard = "intcam01"
    case cabin = "intcam02"
    case personalized
    case unknown

    public init(from decoder: Decoder) throws {
      self = try CameraView(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
  }
  public let view: CameraView
  public let size: Int
  public let width: Int
  public let height: Int
  public let transparent: Bool
  public let placeholder: String?

  /// Known values include:
  /// - studio
  public let environment: String?
}
