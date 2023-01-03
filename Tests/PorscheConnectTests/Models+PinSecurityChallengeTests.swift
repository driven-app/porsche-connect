import XCTest

@testable import PorscheConnect

final class ModelsPinSecurityChallengeTests: XCTestCase {

  // MARK: – Pin Security Challenge

  func testPinSecurity() {
    let pinSecurity = buildPinSecurity()

    XCTAssertEqual("62xuTQXWgJgnCNsqPoWv8emAeFKCMhPWH6mVwp0OaKqT61uuGxptmNVaq4evL", pinSecurity.securityToken)
    XCTAssertEqual("D951A4D79D90EFE70C9F75A100632D756625A326110E921566B3336C32DFAE32", pinSecurity.challenge)
    XCTAssertEqual("582A80BCF3C08E930ED9B950A3230E44BAA101521F97A8060CD88B4810057612A4D015FF6329573BBB7F98A31DEE31A7A387F647F0C18F2F0FC1D50328264945", pinSecurity.generateSecurityPinHash(pin: "1234"))
  }

  func testUnlockSecurity() {
    let pinSecurity = buildPinSecurity()
    let unlockSecurity = UnlockSecurity(challenge: pinSecurity.challenge,
                                        securityPinHash: pinSecurity.generateSecurityPinHash(pin: "1726")!,
                                        securityToken: pinSecurity.securityToken)

    XCTAssertEqual("62xuTQXWgJgnCNsqPoWv8emAeFKCMhPWH6mVwp0OaKqT61uuGxptmNVaq4evL", unlockSecurity.securityToken)
    XCTAssertEqual("D951A4D79D90EFE70C9F75A100632D756625A326110E921566B3336C32DFAE32", unlockSecurity.challenge)
    XCTAssertEqual("B8793A884E6BCDB8ACDE8073C4CC9718CAA747A098FE1CF94CED1FF365D5236420E08B7023B04F668BE8EC977977061B042B5D392DDCB0C65A4512BB740124CF", unlockSecurity.securityPinHash)
  }

  // MARK: - Private functions

  private func buildPinSecurity() -> PinSecurity {
    let json = "{\"securityToken\" : \"62xuTQXWgJgnCNsqPoWv8emAeFKCMhPWH6mVwp0OaKqT61uuGxptmNVaq4evL\", \"challenge\" : \"D951A4D79D90EFE70C9F75A100632D756625A326110E921566B3336C32DFAE32\"}".data(using: .utf8)!

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .useDefaultKeys

    return try! decoder.decode(PinSecurity.self, from: json)
  }
}
