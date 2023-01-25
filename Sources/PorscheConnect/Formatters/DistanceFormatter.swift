import Foundation

/// A formatter that converts Status properties into their textual representations.
///
/// All properties will be formatted based on the provided locale.
public final class DistanceFormatter {

  public init() {
  }

  /// The locale to use for all textual representations.
  public var locale: Locale = .current

  /// The style used when creating a textual representation of distance (e.g. miles or kilometers).
  public var distanceUnitStyle: MeasurementFormatter.UnitStyle = .medium

  /// Returns a textual representation of the vehicle's mileage.
  public func string(from distance: Distance) -> String {
    let formatter = MeasurementFormatter()
    formatter.locale = locale
    formatter.unitStyle = distanceUnitStyle
    formatter.unitOptions = []
    formatter.locale = locale
    formatter.numberFormatter.maximumFractionDigits = 0
    let value = distance.value
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
