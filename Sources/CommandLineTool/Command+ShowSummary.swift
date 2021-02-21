import Foundation
import ArgumentParser
import PorscheConnect

extension Porsche {
  
  struct ShowSummary: ParsableCommand {
    // MARK: - Properties
    
    @OptionGroup() var options: Options
    
    @Argument(help: ArgumentHelp(NSLocalizedString("Your vehicle VIN.", comment: "")))
    var vin: String
    
    // MARK: - Lifecycle
    
    func run() throws {
      let porscheConnect = PorscheConnect(username: options.username, password: options.password)
      let vehicle = Vehicle(vin: vin)
      callSummaryService(porscheConnect: porscheConnect, vehicle: vehicle)
      dispatchMain()
    }
    
    // MARK: - Private functions
    
    private func callSummaryService(porscheConnect: PorscheConnect, vehicle: Vehicle) {
      porscheConnect.summary(vehicle: vehicle) { result in
        switch result {
        case .success(let (summary, _)):
          if let summary = summary {
            printSummary(summary)
          }
          Porsche.ShowSummary.exit()
        case .failure(let error):
          Porsche.ShowSummary.exit(withError: error)
        }
      }
    }
    
    private func printSummary(_ summary: Summary) {
      let output = NSLocalizedString("Model Description: \(summary.modelDescription); Nickname: \(summary.nickName ?? "None")", comment: "")
      print(output)
    }
  }
}
