import Foundation

/// A formatter that converts Status properties into their textual representations.
///
/// All properties will be formatted based on the provided locale.
public final class StatusFormatter {

  /// The locale to use for all textual representations.
  public var locale: Locale = .current

  /// The style used when creating a textual representation of distance (e.g. miles or kilometers).
  public var distanceUnitStyle: MeasurementFormatter.UnitStyle = .medium

  /// Returns a textual representation of the vehicle's battery charge.
  public func batteryLevel(from status: Status) -> String {
    return formatted(genericValue: status.batteryLevel, scalar: 0.01)
  }

  /// Returns a textual representation of the vehicle's mileage.
  public func mileage(from status: Status) -> String {
    return formatted(distance: status.mileage)
  }

  /// Returns a textual representation of the vehicle's mileage.
  public func lockedStatus(from status: Status) -> String {
    return formatted(distance: status.mileage)
  }

  /// Returns a textual representation of the vehicle's remaining range.
  public func electricalRange(from status: Status) -> String? {
    if let electricalRangeDistance = status.remainingRanges.electricalRange.distance {
      return formatted(distance: electricalRangeDistance)
    }
    return nil
  }
}

// MARK: - Private helper methods

extension StatusFormatter {
  /// Returns a numerical value formatted using the value's unit and the formatter's locale.
  private func formatted(genericValue: Status.GenericValue, scalar: Double = 1) -> String {
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
      formatter.dateStyle = .medium
      formatter.timeStyle = .none
      formatter.formattingContext = .middleOfSentence
      let secondsPerDay: Double = 24 * 60 * 60
      return formatter.string(from: Date(timeIntervalSinceNow: value * secondsPerDay))
    default:
      return "\(value) \(genericValue.unit)"
    }
  }

  private func formatted(distance: Distance, scalar: Double = 1) -> String {
    let formatter = MeasurementFormatter()
    formatter.locale = locale
    formatter.unitStyle = distanceUnitStyle
    formatter.unitOptions = []
    formatter.locale = locale
    formatter.numberFormatter.maximumFractionDigits = 0
    let value = distance.value * scalar
    let unit: UnitLength
    switch distance.unit {
    case .kilometers:
      unit = .kilometers
    case .miles:
      unit = .miles
    }
    return formatter.string(from: Measurement(value: value, unit: unit))
  }
}
