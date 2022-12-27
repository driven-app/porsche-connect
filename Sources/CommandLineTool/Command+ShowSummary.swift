import ArgumentParser
import Foundation
import PorscheConnect

extension Porsche {

  struct ShowSummary: AsyncParsableCommand {
    // MARK: - Properties

    @OptionGroup() var options: Options

    @Argument(help: ArgumentHelp(NSLocalizedString("Your vehicle VIN.", comment: "")))
    var vin: String

    // MARK: - Lifecycle

    func run() async throws {
      let porscheConnect = PorscheConnect(username: options.username, password: options.password)
      let vehicle = Vehicle(vin: vin)
      await callSummaryService(porscheConnect: porscheConnect, vehicle: vehicle)
      dispatchMain()
    }

    // MARK: - Private functions

    private func callSummaryService(porscheConnect: PorscheConnect, vehicle: Vehicle) async {

      do {
        let result = try await porscheConnect.summary(vehicle: vehicle)
        if let summary = result.summary {
          printSummary(summary)
        }
        Porsche.ShowSummary.exit()
      } catch {
        Porsche.ShowSummary.exit(withError: error)
      }
    }

    private func printSummary(_ summary: Summary) {
      let output = NSLocalizedString(
        "Model Description: \(summary.modelDescription); Nickname: \(summary.nickName ?? "None")",
        comment: "")
      print(output)
    }
  }
}
