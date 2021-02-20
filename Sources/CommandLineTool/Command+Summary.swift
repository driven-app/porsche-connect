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
        case .failure(let error):
          print(NSLocalizedString("Error \(error).", comment: ""))
        }
        
        Porsche.ShowSummary.exit()
      }
      
      dispatchMain()
    }
    
    private func printSummary(_ summary: Summary) {
      print(NSLocalizedString("Model Description: \(summary.modelDescription); Nickname: \(summary.nickName ?? "None")", comment: ""))
    }
  }
}
