import XCTest
@testable import PorscheConnect

final class NetworkClientTests: XCTestCase {

  // MARK: - Properties
  
  var client: NetworkClient!
  
  // MARK: - Lifecycle
  
  override func setUp() {
    super.setUp()
    self.client = NetworkClient(baseURL: Environment.Ireland.baseURL())
  }
  
  // MARK: - Tests
  
  func testUrlExtensionAddEndpoint() {
    let url = URL(string: "https://api.porsche.example")!.addEndpoint(endpoint: "endpoint")
    XCTAssertEqual(URL(string: "https://api.porsche.example/endpoint"), url)
  }
  
  func testUrlExtensionAddSingleParam() {
    let url = URL(string: "https://api.porsche.example")!.addParams(params: ["param_key": "param_value"])
    XCTAssertEqual(URL(string: "https://api.porsche.example?param_key=param_value"), url)
  }
  
  func testUrlExtensionAddMultipleParams() {
    let url = URL(string: "https://api.porsche.example")!.addParams(params: ["param_key_1": "param_value_1", "param_key_2": "param_value_2"])
    XCTAssertEqual(URL(string: "https://api.porsche.example?param_key_1=param_value_1&param_key_2=param_value_2"), url)
  }
  
  func testUrlExtensionAddMultipleParamsToUrlWithExistingParam() {
    let url = URL(string: "https://api.porsche.example?param_key_1=param_value_1")!.addParams(params: ["param_key_2": "param_value_2"])
    XCTAssertEqual(URL(string: "https://api.porsche.example?param_key_1=param_value_1&param_key_2=param_value_2"), url)
  }
  
  func testUrlExtensionAddEndpointAndMultipleParams() {
    let url = URL(string: "https://api.porsche.example")!.addEndpoint(endpoint: "endpoint").addParams(params: ["param_key_1": "param_value_1", "param_key_2": "param_value_2"])
    XCTAssertEqual(URL(string: "https://api.porsche.example/endpoint?param_key_1=param_value_1&param_key_2=param_value_2"), url)
  }
}
