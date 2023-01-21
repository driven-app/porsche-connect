import ArgumentParser
import Foundation
import PorscheConnect

extension Porsche {

  struct Lock: AsyncParsableCommand {

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
      await callLock(porscheConnect: porscheConnect, vin: vin)
      dispatchMain()
    }

    // MARK: - Private functions

    private func callLock(porscheConnect: PorscheConnect, vin: String) async {

      do {
        let result = try await porscheConnect.lock(vin: vin)
        if let remoteCommand = result.remoteCommandAccepted {
          printRemoteCommandAccepted(remoteCommand)

          var lastStatus = try await porscheConnect.checkStatus(vin: vin, remoteCommand: remoteCommand).status?.status
          while lastStatus == "IN_PROGRESS" {
            // Avoid excessive API calls.
            try await Task.sleep(nanoseconds: UInt64(0.5 * Double(NSEC_PER_SEC)))

            print("Waiting for completion of command...")
            lastStatus = try await porscheConnect.checkStatus(vin: vin, remoteCommand: remoteCommand).status?.status
          }

          if lastStatus == "SUCCESS" {
            print("Command succeeded")
          } else if let lastStatus {
            print("Command failed with status: \(lastStatus)")
          }

          if let lastActions = try await porscheConnect.lockUnlockLastActions(vin: vin).lastActions {
            printLastActions(lastActions)
          }
        }
        Porsche.Lock.exit()
      } catch {
        Porsche.Lock.exit(withError: error)
      }
    }

    private func printRemoteCommandAccepted(_ remoteCommandAccepted: RemoteCommandAccepted) {
      print(
        NSLocalizedString(
          "Remote command \"Lock\" accepted by Porsche API with ID \(remoteCommandAccepted.identifier!)",
          comment: ""))
    }

    private func printLastActions(_ lastActions: LockUnlockLastActions) {
      print("""
Final status:
- frontLeft: \(lastActions.doors.frontLeft)
- frontRight: \(lastActions.doors.frontRight)
- backLeft: \(lastActions.doors.backLeft)
- backRight: \(lastActions.doors.backRight)
- frontTrunk: \(lastActions.doors.frontTrunk)
- backTrunk: \(lastActions.doors.backTrunk)
- overallLockStatus: \(lastActions.doors.overallLockStatus)
""")
    }
  }
}
