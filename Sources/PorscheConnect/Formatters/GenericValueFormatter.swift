import Foundation

/// A formatter that converts GenericValue instances into their textual representations.
///
/// All properties will be formatted based on the provided locale.
public final class GenericValueFormatter {
  
  public enum Unit: String {
    case percent = "PERCENT", days = "DAYS"
  }
  
  // MARK: - Lifecycle
  
  public init(date: Date = Date()) {
    self.date = date
  }

  // MARK: - Properties
  
  public let date: Date
  
  /// The locale to use for all textual representations.
  public var locale: Locale = .current

  /// The timezone to use for all textual representations.
  public var timeZone: TimeZone = .autoupdatingCurrent

  /// The date to use for relative dates.
  public var defaultDate: Date?
  
  // MARK: - Private properties
  
  private var dateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.locale = .current
      formatter.timeZone = .autoupdatingCurrent
      formatter.dateStyle = .medium
      formatter.timeStyle = .none
      formatter.formattingContext = .middleOfSentence
      return formatter
  }()

  // MARK: - Functions
  
  /// Returns a textual representation of the generic value.
  public func string(from genericValue: GenericValue, scalar: Double = 1) -> String {
    guard let unit = Unit(rawValue: genericValue.unit) else { return kBlankString }
    
    let value = Double(genericValue.value) * scalar
    switch unit {
    case .percent:
      return formatPercent(value: value)
    case .days:
      return formatDays(value: value)
    }
  }
  
  // MARK: - Private functions
  
  private func formatPercent(value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.locale = locale
    formatter.numberStyle = .percent
    formatter.maximumFractionDigits = 0
    
    return formatter.string(from: value as NSNumber) ?? kBlankString
   }
  
  private func formatDays(value: Double) -> String {
    let formatter = DateFormatter()
    formatter.locale = locale
    formatter.defaultDate = defaultDate
    formatter.timeZone = timeZone
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    formatter.formattingContext = .middleOfSentence
    let secondsPerDay: Double = 24 * 60 * 60
    
    return formatter.string(from: date + (value * secondsPerDay))
  }
}
