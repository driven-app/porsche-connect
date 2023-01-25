import ArgumentParser
import Foundation
import PorscheConnect

extension Porsche {
    
  struct ShowMaintenance: AsyncParsableCommand {
    
    enum TripType: String, ExpressibleByArgument {
        case short, long
    }
    
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
      await callMaintenanceService(porscheConnect: porscheConnect, vin: vin)
      dispatchMain()
    }
    
    // MARK: - Private functions
    
    private func callMaintenanceService(porscheConnect: PorscheConnect, vin: String) async {
      
      do {
        let result = try await porscheConnect.maintenance(vin: vin)
        printMaintenance(result.maintenance)
        Porsche.ShowMaintenance.exit()
      } catch {
        Porsche.ShowMaintenance.exit(withError: error)
      }
    }
    
    private func printMaintenance(_ maintenance: Maintenance?) {
      guard let maintenance = maintenance else { return }
      
      maintenance.items.enumerated().forEach { (index, item) in
        printMaintenanceItem(item, at: index)
      }
    }
    
    private func printMaintenanceItem(_ item: Maintenance.MaintenanceItem, at index: Int) {
      let output = NSLocalizedString(
        "#\(index+1) => Maintenance ID: \(item.id); Short Description: \"\(item.description.shortName)\"; Long Description: \"\(item.description.longName ?? "")\"; Criticality: \"\(item.description.criticalityText)\"",
        comment: "")
      print(output)
    }
  }
}
