import Foundation

public struct RemainingRanges: Codable {
  public struct Range: Codable {
    public let distance: Distance?

    /// Can be any of:
    /// - `ELECTRIC`
    /// - `UNSUPPORTED`
    public let engineType: String

    public let isPrimary: Bool?
  }
  public let conventionalRange: Range
  public let electricalRange: Range
}
