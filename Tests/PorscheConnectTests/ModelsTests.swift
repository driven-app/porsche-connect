import XCTest
@testable import PorscheConnect

final class ModelsTests: XCTestCase {
  
  func testPorscheAuthConstruction() {
    let porscheAuth = PorscheAuth(accessToken: "a_test_access_token", idToken: "a_test_id_token", tokenType: "Bearer", expiresIn: 7199)
    XCTAssertNotNil(porscheAuth)
  }
  
  func testDecodingJsonIntoModel() {
    let json =  "{\"access_token\":\"jycHMMWhUjsEVNUxzLgM92XGIN17\",\"id_token\":\"eyJhbGciOiJSUzI1NiIsImtpZCI6IjE1bF9LeldTV08tQ1ZNdXdlTmQyMnMifQ\",\"token_type\":\"Bearer\",\"expires_in\":7199}\r\n".data(using: .utf8)!
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    let porscheAuth = try! decoder.decode(PorscheAuth.self, from: json)
    XCTAssertNotNil(porscheAuth)
    XCTAssertEqual("jycHMMWhUjsEVNUxzLgM92XGIN17", porscheAuth.accessToken)
    XCTAssertEqual("eyJhbGciOiJSUzI1NiIsImtpZCI6IjE1bF9LeldTV08tQ1ZNdXdlTmQyMnMifQ", porscheAuth.idToken)
    XCTAssertEqual("Bearer", porscheAuth.tokenType)
    XCTAssertEqual(7199, porscheAuth.expiresIn)
  }  
}
