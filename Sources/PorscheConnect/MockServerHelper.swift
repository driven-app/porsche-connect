import Foundation

#if !os(macOS)
import UIKit
#endif

// MARK: - Helper functions


public func randomMockServerPortForProcess() -> Int {
  let fileUrl = NSURL.fileURL(withPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent("\(deviceName())-port.txt")
  
  if !FileManager.default.fileExists(atPath: fileUrl.path) {
    let port = String(Int.random(in: 3000 ... 9999))
    try! port.write(to: fileUrl, atomically: true, encoding: String.Encoding.utf8)
  }
  
  let port = try! String(contentsOf: fileUrl, encoding: .utf8)
  
  return Int(port)!
}

private func deviceName() -> String {
  #if os(iOS) || os(watchOS) || os(tvOS)
  return UIDevice.current.name
  #elseif os(macOS)
  return Host.current().name ?? "device"
  #endif
}
