import Foundation

/// A formatter that converts GenericValue instances into their textual representations.
///
/// All properties will be formatted based on the provided locale.
public final class GenericValueFormatter {

  public init() {
  }

  /// The locale to use for all textual representations.
  public var locale: Locale = .current

  /// The timezone to use for all textual representations.
  public var timeZone: TimeZone = .autoupdatingCurrent

  /// The date to use for relative dates.
  public var defaultDate: Date?

  /// Returns a textual representation of the generic value.
  public func string(from genericValue: GenericValue, scalar: Double = 1) -> String {
    let value = Double(genericValue.value) * scalar
    switch genericValue.unit {
    case "PERCENT":
      let formatter = NumberFormatter()
      formatter.locale = locale
      formatter.numberStyle = .percent
      formatter.maximumFractionDigits = 0
      return formatter.string(from: value as NSNumber)!
    case "DAYS":
      let formatter = DateFormatter()
      formatter.locale = locale
      formatter.defaultDate = defaultDate
      formatter.timeZone = timeZone
      formatter.dateStyle = .medium
      formatter.timeStyle = .none
      formatter.formattingContext = .middleOfSentence
      let secondsPerDay: Double = 24 * 60 * 60
      return formatter.string(from: Date(timeIntervalSinceNow: value * secondsPerDay))
    default:
      return "\(value) \(genericValue.unit)"
    }
  }
}
