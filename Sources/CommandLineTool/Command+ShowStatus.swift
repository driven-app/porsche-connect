import ArgumentParser
import Foundation
import PorscheConnect

extension Porsche {

  struct ShowStatus: AsyncParsableCommand {
    // MARK: - Properties

    @OptionGroup()
    var options: Options

    @Argument(help: ArgumentHelp(NSLocalizedString("Your vehicle VIN.", comment: "")))
    var vin: String

    // MARK: - Lifecycle

    func run() async throws {
      let porscheConnect = PorscheConnect(
        username: options.username,
        password: options.password,
        environment: options.resolvedEnvironment
      )
      await callStatusService(porscheConnect: porscheConnect, vin: vin)
      dispatchMain()
    }

    // MARK: - Private functions

    private func callStatusService(porscheConnect: PorscheConnect, vin: String) async {

      do {
        let result = try await porscheConnect.status(vin: vin)
        if let status = result.status {
          printStatus(status)
        }
        Porsche.ShowStatus.exit()
      } catch {
        Porsche.ShowStatus.exit(withError: error)
      }
    }

    private func printStatus(_ status: Status) {
      print(
        NSLocalizedString(
          "Overall lock status: \(formatted(lockStatus: status.overallLockStatus))", comment: ""))
      print(
        NSLocalizedString(
          "Battery level: \(formatted(genericValue: status.batteryLevel)), Mileage: \(formatted(distance: status.mileage))",
          comment: ""))
      if let electricalRangeDistance = status.remainingRanges.electricalRange.distance {
        print(
          NSLocalizedString(
            "Remaining range is \(formatted(distance: electricalRangeDistance))", comment: ""))
      }
      print(
        NSLocalizedString(
          "Next inspection in \(formatted(distance: status.serviceIntervals.inspection.distance, scalar: -1)) or on \(formatted(genericValue: status.serviceIntervals.inspection.time, scalar: -1))",
          comment: ""))
    }

    private func formatted(genericValue: Status.GenericValue, scalar: Double = 1) -> String {
      let value = Double(genericValue.value) * scalar
      switch genericValue.unit {
      case "PERCENT":
        return "\(value)%"
      case "DAYS":
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.formattingContext = .middleOfSentence
        let secondsPerDay: Double = 24 * 60 * 60
        return formatter.string(from: Date(timeIntervalSinceNow: value * secondsPerDay))
      default:
        return "\(value) \(genericValue.unit)"
      }
    }

    private func formatted(distance: Status.Distance, scalar: Double = 1) -> String {
      let formatter = MeasurementFormatter()
      formatter.unitStyle = .long
      formatter.unitOptions = .providedUnit
      formatter.locale = Locale.current
      let value = distance.value * scalar
      let unit: UnitLength
      switch distance.unit {
      case "KILOMETERS":
        unit = .kilometers
      case "MILES":
        unit = .miles
      default:
        return "\(value)"
      }
      return formatter.string(from: Measurement(value: value, unit: unit))
    }

    private func formatted(lockStatus: String) -> String {
      switch lockStatus {
      case "CLOSED_LOCKED":
        return NSLocalizedString("Closed and locked", comment: "The vehicle is closed and locked")
      default:
        return lockStatus
      }
    }
  }
}
