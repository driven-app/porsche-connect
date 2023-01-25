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
      let genericValueFormatter = GenericValueFormatter()
      let distanceFormatter = DistanceFormatter()
      print(
        NSLocalizedString(
          "Overall lock status: \(formatted(lockStatus: status.overallLockStatus))", comment: ""))
      print(
        NSLocalizedString(
          "Battery level: \(genericValueFormatter.string(from: status.batteryLevel)), Mileage: \(distanceFormatter.string(from: status.mileage))",
          comment: ""))
      if let electricalRangeDistance = status.remainingRanges.electricalRange.distance {
        print(
          NSLocalizedString(
            "Remaining range is \(distanceFormatter.string(from: electricalRangeDistance))", comment: ""))
      }
      print(
        NSLocalizedString(
          "Next inspection in \(distanceFormatter.string(from: status.serviceIntervals.inspection.distance, scalar: -1)) or on \(genericValueFormatter.string(from: status.serviceIntervals.inspection.time, scalar: -1))",
          comment: ""))
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
