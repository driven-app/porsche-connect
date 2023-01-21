import Foundation

public final class TimestampFormatter {

  // MARK: - Properties

  public var timeZone: TimeZone {
    get { formatter.timeZone }
    set { formatter.timeZone = newValue }
  }
  public var locale: Locale {
    get { formatter.locale }
    set { formatter.locale = newValue }
  }

  private let formatter = DateFormatter()

  // MARK: - Lifecycle

  public init() {
    self.formatter.dateStyle = .medium
    self.formatter.timeStyle = .medium
    self.formatter.timeZone = .autoupdatingCurrent
    self.formatter.locale = .current
  }

  // MARK: - Public functions

  public func formatted(from date: Date) -> String? {
    return formatter.string(for: date)
  }
}

