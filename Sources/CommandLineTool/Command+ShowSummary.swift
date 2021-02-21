import Foundation
import ArgumentParser
import PorscheConnect

extension Porsche {
  
  struct ShowSummary: ParsableCommand {
    @OptionGroup() var options: Options
    
    @Argument(help: ArgumentHelp(NSLocalizedString("Your vehicle VIN.", comment: "")))
    var vin: String
    
    func run() throws {
      let porscheConnect = PorscheConnect(username: options.username, password: options.password)
      let vehicle = Vehicle(vin: vin)
      
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
      
      dispatchMain()
    }
    
    private func printSummary(_ summary: Summary) {
      let output = NSLocalizedString("Model Description: \(summary.modelDescription); Nickname: \(summary.nickName ?? "None")", comment: "")
      print(output)
    }
  }
}
