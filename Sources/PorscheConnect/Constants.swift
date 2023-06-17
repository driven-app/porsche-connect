import Foundation
import os.log

// MARK: - Static Constants

let kLibraryName = "PorscheConnect"
let kDefaultTestTimeout: TimeInterval = 10
let kBlankString = ""
let kBlankData: Data = kBlankString.data(using: .utf8)!
let kTestServerPort = 8080
let kDefaultCarModel = "J1"
let kRedirectHeader = "X-APP-FOLLOW-REDIRECTS"
let kSleepDurationInSecs = 2.5

// MARK: - Logging

let AuthLogger = Logger(subsystem: kLibraryName, category: "Auth")
