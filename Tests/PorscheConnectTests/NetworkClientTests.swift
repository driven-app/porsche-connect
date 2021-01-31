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
    XCTAssertEqual("/endpoint", url.path)
  }
  
  func testUrlExtensionAddSingleParam() {
    let url = URL(string: "https://api.porsche.example")!.addParams(params: ["param_key": "param_value"])
    XCTAssert(url.query!.contains("param_key=param_value"))
  }
  
  func testUrlExtensionAddMultipleParams() {
    let url = URL(string: "https://api.porsche.example")!.addParams(params: ["param_key_1": "param_value_1", "param_key_2": "param_value_2"])
    XCTAssert(url.query!.contains("param_key_1=param_value_1"))
    XCTAssert(url.query!.contains("param_key_2=param_value_2"))
  }
  
  func testUrlExtensionAddMultipleParamsToUrlWithExistingParam() {
    let url = URL(string: "https://api.porsche.example?param_key_1=param_value_1")!.addParams(params: ["param_key_2": "param_value_2"])
    XCTAssert(url.query!.contains("param_key_1=param_value_1"))
    XCTAssert(url.query!.contains("param_key_2=param_value_2"))
  }
  
  func testUrlExtensionAddEndpointAndMultipleParams() {
    let url = URL(string: "https://api.porsche.example")!.addEndpoint(endpoint: "endpoint").addParams(params: ["param_key_1": "param_value_1", "param_key_2": "param_value_2"])
    //XCTAssertEqual(URL(string: "https://api.porsche.example/endpoint?param_key_1=param_value_1&param_key_2=param_value_2"), url)
    XCTAssertEqual("/endpoint", url.path)
    XCTAssert(url.query!.contains("param_key_1=param_value_1"))
    XCTAssert(url.query!.contains("param_key_2=param_value_2"))
  }
}
