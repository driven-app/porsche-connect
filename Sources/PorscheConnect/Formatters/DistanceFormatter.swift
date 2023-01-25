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
  public func string(from distance: Distance, scalar: Double = 1) -> String {
    let formatter = MeasurementFormatter()
    formatter.locale = locale
    formatter.unitStyle = distanceUnitStyle
    formatter.unitOptions = []
    formatter.numberFormatter.maximumFractionDigits = 0
    return formatter.string(from: Measurement(
      value: distance.value * scalar,
      unit: distance.unit.asUnitLength
    ))
  }
}

extension Distance.Unit {
  fileprivate var asUnitLength: UnitLength {
    switch self {
    case .kilometers:
      return .kilometers
    case .miles:
      return .miles
    }
  }
}
