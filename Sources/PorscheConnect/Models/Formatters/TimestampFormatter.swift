import Foundation

public final class TimestampFormatter {
  
  // MARK: - Properties
  
  public let timestamp: Date
  
  private let formatter = DateFormatter()
  
  // MARK: - Lifecycle
  
  public init(timestamp: Date, locale: Locale = .current) {
    self.timestamp = timestamp
    self.formatter.dateStyle = .medium
    self.formatter.timeStyle = .medium
    self.formatter.locale = locale
  }
  
  // MARK: - Public functions
  
  public func formatted() -> String {
    return formatter.string(for: timestamp) ?? kBlankString
  }
}
