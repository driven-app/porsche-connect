import XCTest
@testable import PorscheConnect

final class CodeChallengerTests: XCTestCase {

  func testGenerateCodeVerifier() {
    let codeChallenger = CodeChallenger(length: 64)
    XCTAssertNotNil(codeChallenger)

    let codeVerifier = codeChallenger.generateCodeVerifier()!
    XCTAssertNotNil(codeVerifier)
  }

  func testCodeChallengeFromGeneratedCodeVerifier() {
    let codeChallenger = CodeChallenger(length: 64)
    XCTAssertNotNil(codeChallenger)

    let codeVerifier = codeChallenger.generateCodeVerifier()!
    XCTAssertNotNil(codeVerifier)

    let codeChallenge = codeChallenger.codeChallenge(for: codeVerifier)!
    XCTAssertNotNil(codeChallenge)
  }

  func testCodeChallenge() {
    let codeChallenger = CodeChallenger(length: 64)
    XCTAssertNotNil(codeChallenger)

    XCTAssertEqual("dADBvw4mcionJ5slawFhCxPFdHKdZ5naQri71Dq8OxA", codeChallenger.codeChallenge(for: "R9TKdFZFg6vSg1fBA1sckttPmbVEiPLoNjDZIGFozC8FETVzayig")!)
    XCTAssertEqual("Tsnu08fmm7D9XIx_XZnfub_QX0qDoQno4q7eRj7dHgw", codeChallenger.codeChallenge(for: "QtT30VN5sy2HjI8nooey8qLPuuRuOg32KJEg2bRpSVe6DFEPe6lDw")!)
  }

  func testCodeChallengeTwice() {
    let codeChallenger = CodeChallenger(length: 64)
    XCTAssertNotNil(codeChallenger)

    XCTAssertEqual("dADBvw4mcionJ5slawFhCxPFdHKdZ5naQri71Dq8OxA", codeChallenger.codeChallenge(for: "R9TKdFZFg6vSg1fBA1sckttPmbVEiPLoNjDZIGFozC8FETVzayig")!)
    XCTAssertEqual("dADBvw4mcionJ5slawFhCxPFdHKdZ5naQri71Dq8OxA", codeChallenger.codeChallenge(for: "R9TKdFZFg6vSg1fBA1sckttPmbVEiPLoNjDZIGFozC8FETVzayig")!)
  }
}
