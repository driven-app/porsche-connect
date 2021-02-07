import XCTest
@testable import PorscheConnect

final class CodeChallengerTests: XCTestCase {
  
  func testGenerateCodeChallengeLength32() {
    let codeChallenge = CodeChallenger(length: 32).generateCodeChallenge()
    XCTAssertNotNil(codeChallenge)
    XCTAssertEqual(43, codeChallenge!.count)
  }
  
  func testGenerateCodeChallengeLength40() {
    let codeChallenge = CodeChallenger(length: 40).generateCodeChallenge()
    XCTAssertNotNil(codeChallenge)
    XCTAssertEqual(43, codeChallenge!.count)
  }
  
  func testGeneratesUniqueChallenges() {
    let codeChallenger = CodeChallenger(length: 32)
    let codeChallenge1 = codeChallenger.generateCodeChallenge()
    let codeChallenge2 = codeChallenger.generateCodeChallenge()

    XCTAssertNotNil(codeChallenge1)
    XCTAssertNotNil(codeChallenge2)
    XCTAssertNotEqual(codeChallenge1, codeChallenge2)
  }
}
