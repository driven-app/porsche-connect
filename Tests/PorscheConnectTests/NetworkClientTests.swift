import XCTest
@testable import PorscheConnect

fileprivate struct HelloWorld: Codable {
  let message: String
}

final class NetworkClientTests: BaseMockNetworkTestCase {

  // MARK: - Properties
  
  var client: NetworkClient!
  
  // MARK: - Lifecycle
  
  override func setUp() {
    super.setUp()
    self.client = NetworkClient()
  }
  
  // MARK: - Tests
  
  func testGetHelloWorldSuccessful() {
    let url = URL(string: "http://localhost:\(randomMockServerPortForProcess())/hello_world.json")!
    MockNetworkRoutes().mockGetHelloWorldSuccessful(router: router)
    let expectation = self.expectation(description: "Network Expectation")

    client.get(HelloWorld.self, url: url) { (helloWorld, response, error, responseJson) in
      expectation.fulfill()
      XCTAssertNil(error)
      XCTAssertNotNil(responseJson)
      XCTAssertNotNil(response)
      XCTAssertNotNil(helloWorld)
      XCTAssertEqual("Hello World!", helloWorld!.message)
      XCTAssertEqual(200, response!.statusCode)
    }
    
    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testGetHelloWorldFailure() {
    let url = URL(string: "http://localhost:\(randomMockServerPortForProcess())/hello_world.json")!
    MockNetworkRoutes().mockGetHelloWorldFailure(router: router)
    let expectation = self.expectation(description: "Network Expectation")

    client.get(HelloWorld.self, url: url) { (helloWorld, response, error, responseJson) in
      expectation.fulfill()
      XCTAssertNotNil(error)
      XCTAssertNil(responseJson)
      XCTAssertNil(helloWorld)
      XCTAssertNotNil(response)
      XCTAssertEqual(401, response!.statusCode)
    }
    
    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
    
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
  
  func testBuildPostFormBodySingleKey() {
    let data = buildPostFormBodyFrom(dictionary: ["param_key": "param_value"])
    XCTAssertEqual("param_key=param_value", String(data: data, encoding: .utf8))
  }
  
  func testBuildPostFormBodyMultipleKeys() {
    let data = buildPostFormBodyFrom(dictionary: ["param_key_1": "param_value_1", "param_key_2": "param_value_2"])
    let query = String(data: data, encoding: .utf8)!
    XCTAssert(query.contains("param_key_1=param_value_1"))
    XCTAssert(query.contains("param_key_2=param_value_2"))
  }
}
