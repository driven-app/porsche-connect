import XCTest
@testable import PorscheConnect

fileprivate struct HelloWorld: Codable {
  let message: String
}

final class NetworkClientTests: BaseMockNetworkTestCase {

  // MARK: - Properties
  
  var client: NetworkClient!
  let mockNetworkRoutes = MockNetworkRoutes()
  
  // MARK: - Lifecycle
  
  override func setUp() {
    super.setUp()
    self.client = NetworkClient()
  }
  
  // MARK: - Tests
  
  func testGetSuccessful() {
    let url = URL(string: "http://localhost:\(kTestServerPort)/hello_world.json")!
    mockNetworkRoutes.mockGetHelloWorldSuccessful(router: MockServer.shared.router)
    let expectation = self.expectation(description: "Network Expectation")

    client.get(HelloWorld.self, url: url) { result in
      expectation.fulfill()

      switch result {
      case .success(let (helloWorld, response)):
        XCTAssertEqual("Hello World!", helloWorld!.message)
        XCTAssertEqual(200, response!.statusCode)
      case .failure:
        XCTFail("Should not have reached here")
      }
    }
    
    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testGetFailure() {
    let url = URL(string: "http://localhost:\(kTestServerPort)/hello_world.json")!
    mockNetworkRoutes.mockGetHelloWorldFailure(router: MockServer.shared.router)
    let expectation = self.expectation(description: "Network Expectation")

    client.get(HelloWorld.self, url: url) { result in
      expectation.fulfill()
      
      switch result {
      case .success:
        XCTFail("Should not have reached here")
      case .failure(let error):
        print()
        XCTAssertEqual(HttpStatusCode.Unauthorized, error as! HttpStatusCode)
      }
    }
    
    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testPostSuccess() {
    let url = URL(string: "http://localhost:\(kTestServerPort)/hello_world.json")!
    mockNetworkRoutes.mockGetHelloWorldSuccessful(router: MockServer.shared.router)
    let expectation = self.expectation(description: "Network Expectation")
    let body = ["param_key": "param_value"]
    
    client.post(HelloWorld.self, url: url, body: buildPostFormBodyFrom(dictionary: body)) { result in
      expectation.fulfill()
      switch result {
      case .success(let (helloWorld, response)):
        XCTAssertEqual("Hello World!", helloWorld!.message)
        XCTAssertEqual(200, response!.statusCode)
      case .failure:
        XCTFail("Should not have reached here")
      }
    }
    
    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
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
