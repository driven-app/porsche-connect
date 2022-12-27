import ArgumentParser
import Foundation

extension Bool {
  var displayString: String {
    return self ? NSLocalizedString("yes", comment: "") : NSLocalizedString("no", comment: "")
  }
}
