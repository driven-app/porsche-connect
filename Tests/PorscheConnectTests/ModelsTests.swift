import XCTest
@testable import PorscheConnect

final class ModelsTests: XCTestCase {
  let porscheAuth = PorscheAuth(accessToken: "zVb3smCN32iOslsoXa7XIYPrenGz",
                                idToken: "yJhbGciOiJSUzI1NiIsImtpZCI6IjE1bF9LeldTV08tQ1ZNdXdlTmQyMnMifQ.eyJzdWIiOiI4N3VnOGJobXZydnF5bTFrIiwiYXVkIjoiVFo0VmY1d25LZWlwSnh2YXRKNjBsUEhZRXpxWjRXTnAiLCJqdGkiOiI5NWhPT0ZlSDdzZW9yaVZ2bUNhTWdWIiwiaXNzIjoiaHR0cHM6XC9cL2xvZ2luLnBvcnNjaGUuY29tIiwiaWF0IjoxNjEyNzQwOTE2LCJleHAiOjE2MTI3NDEyMTYsInBpLnNyaSI6IkVYYjZSSlFpRWZLazNRZWk0Y1dyTWlwSmgxSSJ9.bVzapayesKjA85pRwVBZN_TfKzPNFTOb6nszPSWElMU2-MOzmJjy6dWHTjN3jCCx3Ui20XDwHkkDOdIUZqIQq6nve5ihbRlNi1ywrNiKKLOL7nmfzmM7yBPMZfwxtCP_-imypF_n19i1rZDkatIkW0Ejs7lcc0xRD9JewGMhfALqpFuOciIX3SIInHE56WSmTNyEB1LTNNLXiwaBWygPVbYDAYYc4u-w3V_GPZR3kTSTJjwnfXM9Qke6wBcoXDaON4_NfNcTQf0vXYwhC749dJd8Z2eDcRTl-Yl06BTHHTIL-yInfk8yjCO1iaCv01ROjK_nGAyPsOvUKtVgsaXxnw",
                                tokenType: "Bearer",
                                expiresIn: 7199)
  
  let vehicle = Vehicle(vin: "WP0ZZZY4MSA38703")
  
  func testPorscheAuthConstruction() {
    XCTAssertNotNil(porscheAuth)
    XCTAssertNotNil(porscheAuth.apiKey)
    XCTAssertEqual("TZ4Vf5wnKeipJxvatJ60lPHYEzqZ4WNp", porscheAuth.apiKey!)
    XCTAssertNotNil(porscheAuth.expiresAt)
    XCTAssertFalse(porscheAuth.expired)
  }
  
  func testDecodingJsonIntoModel() {
    let json =  "{\"access_token\":\"Kpjg2m1ZXd8GM0pvNIB3jogWd0o6\",\"id_token\":\"eyJhbGciOiJSUzI1NiIsImtpZCI6IjE1bF9LeldTV08tQ1ZNdXdlTmQyMnMifQ.eyJzdWIiOiI4N3VnOGJobXZydnF5bTFrIiwiYXVkIjoiVFo0VmY1d25LZWlwSnh2YXRKNjBsUEhZRXpxWjRXTnAiLCJqdGkiOiJmTldhWEE4RTBXUzNmVzVZU0VmNFRDIiwiaXNzIjoiaHR0cHM6XC9cL2xvZ2luLnBvcnNjaGUuY29tIiwiaWF0IjoxNjEyNzQxNDA4LCJleHAiOjE2MTI3NDE3MDgsInBpLnNyaSI6InNoeTN3aDN4RFVWSFlwd0pPYmpQdHJ5Y2FpOCJ9.EsgxbnDCdEC0O8b05B_VJoe09etxcQOqhj4bRkR-AOwZrFV0Ba5LGkUFD_8GxksWuCn9W_bG_vHNOxpcum-avI7r2qY3N2iMJHZaOc0Y-NqBPCu5kUN3F5oh8e7aDbBKQI_ZWTxRdMvcTC8zKJRZf0Ud2YFQSk6caGwmqJ5OE_OB38_ovbAiVRgV_beHePWpEkdADKKtlF5bmSViHOoUOs8x6j21mCXDiuMPf62oRxU4yPN-AS4wICtz22dabFgdjIwOAFm651098z2zwEUEAPAGkcRKuvSHlZ8OAvi4IXSFPXBdCfcfXRk5KdCXxP1xaZW0ItbrQZORdI12hVFoUQ\",\"token_type\":\"Bearer\",\"expires_in\":7199}\r\n".data(using: .utf8)!
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    let decodedPorscheAuth = try! decoder.decode(PorscheAuth.self, from: json)
    XCTAssertNotNil(decodedPorscheAuth)
    XCTAssertEqual("Kpjg2m1ZXd8GM0pvNIB3jogWd0o6", decodedPorscheAuth.accessToken)
    XCTAssertEqual("eyJhbGciOiJSUzI1NiIsImtpZCI6IjE1bF9LeldTV08tQ1ZNdXdlTmQyMnMifQ.eyJzdWIiOiI4N3VnOGJobXZydnF5bTFrIiwiYXVkIjoiVFo0VmY1d25LZWlwSnh2YXRKNjBsUEhZRXpxWjRXTnAiLCJqdGkiOiJmTldhWEE4RTBXUzNmVzVZU0VmNFRDIiwiaXNzIjoiaHR0cHM6XC9cL2xvZ2luLnBvcnNjaGUuY29tIiwiaWF0IjoxNjEyNzQxNDA4LCJleHAiOjE2MTI3NDE3MDgsInBpLnNyaSI6InNoeTN3aDN4RFVWSFlwd0pPYmpQdHJ5Y2FpOCJ9.EsgxbnDCdEC0O8b05B_VJoe09etxcQOqhj4bRkR-AOwZrFV0Ba5LGkUFD_8GxksWuCn9W_bG_vHNOxpcum-avI7r2qY3N2iMJHZaOc0Y-NqBPCu5kUN3F5oh8e7aDbBKQI_ZWTxRdMvcTC8zKJRZf0Ud2YFQSk6caGwmqJ5OE_OB38_ovbAiVRgV_beHePWpEkdADKKtlF5bmSViHOoUOs8x6j21mCXDiuMPf62oRxU4yPN-AS4wICtz22dabFgdjIwOAFm651098z2zwEUEAPAGkcRKuvSHlZ8OAvi4IXSFPXBdCfcfXRk5KdCXxP1xaZW0ItbrQZORdI12hVFoUQ", decodedPorscheAuth.idToken)
    XCTAssertEqual("Bearer", decodedPorscheAuth.tokenType)
    XCTAssertEqual(7199, decodedPorscheAuth.expiresIn)
    XCTAssertNotNil(decodedPorscheAuth.apiKey)
    XCTAssertEqual("TZ4Vf5wnKeipJxvatJ60lPHYEzqZ4WNp", porscheAuth.apiKey!)
    XCTAssertNotNil(porscheAuth.expiresAt)
    XCTAssertFalse(porscheAuth.expired)
  }
  
  func testDecodedJwtToken() {
    XCTAssertNotNil(porscheAuth)
    XCTAssertEqual("TZ4Vf5wnKeipJxvatJ60lPHYEzqZ4WNp", porscheAuth.apiKey)
  }
  
  func testVehicleConstruction() {
    XCTAssertNotNil(vehicle)
  }
  
}
