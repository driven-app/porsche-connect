import Foundation
import ArgumentParser

extension Bool {
  var displayString: String {
    return self ? NSLocalizedString("yes", comment: "") : NSLocalizedString("no", comment: "")
  }
}
