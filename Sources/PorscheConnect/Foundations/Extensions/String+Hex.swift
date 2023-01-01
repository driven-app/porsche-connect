import Foundation

extension StringProtocol {
  var hex: [UInt8] {
    var startIndex = self.startIndex
    return (0..<count/2).compactMap { _ in
      let endIndex = index(after: startIndex)
      defer { startIndex = index(after: endIndex) }
      return UInt8(self[startIndex...endIndex], radix: 16)
    }
  }
}
