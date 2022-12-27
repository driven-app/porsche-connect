import Foundation
import os.log

// MARK: - Static Constants

let kLibraryName = "PorscheConnect"
let kDefaultTestTimeout: TimeInterval = 10
let kBlankString = ""
let kBlankData: Data = "".data(using: .utf8)!
let kTestServerPort = 8080

// MARK: - Logging

let AuthLogger = Logger(subsystem: kLibraryName, category: "Auth")
