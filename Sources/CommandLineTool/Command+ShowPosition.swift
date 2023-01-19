import ArgumentParser
import Foundation
import PorscheConnect

extension Porsche {

  struct ShowPosition: AsyncParsableCommand {

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
      await callPositionService(porscheConnect: porscheConnect, vin: vin)
      dispatchMain()
    }

    // MARK: - Private functions

    private func callPositionService(porscheConnect: PorscheConnect, vin: String) async {
      do {
        let result = try await porscheConnect.position(vin: vin)
        if let position = result.position {
          printPosition(position)
        }
        Porsche.ShowPosition.exit()
      } catch {
        Porsche.ShowPosition.exit(withError: error)
      }
    }

    private func printPosition(_ position: Position) {
      let output = NSLocalizedString(
        "Latitude: \(position.carCoordinate.latitude); Longitude: \(position.carCoordinate.longitude); Heading: \(String(format: "%.0f" ,position.heading))",
        comment: "")
      print(output)
    }
  }
}
