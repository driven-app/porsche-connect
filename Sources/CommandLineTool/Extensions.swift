import ArgumentParser
import Foundation

extension Bool {
  var displayString: String {
    return self ? NSLocalizedString("yes", comment: kBlankString) : NSLocalizedString("no", comment: kBlankString)
  }
}
