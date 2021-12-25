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
    client = NetworkClient()
  }
  
  // MARK: - Tests
  
  func testGetSuccessful() async {
    let url = URL(string: "http://localhost:\(kTestServerPort)/hello_world.json")!
    mockNetworkRoutes.mockGetHelloWorldSuccessful(router: MockServer.shared.router)
    let expectation = expectation(description: "Network Expectation")

    let result = try! await client.get(HelloWorld.self, url: url)
    expectation.fulfill()
    
    XCTAssertEqual("Hello World!", result.data!.message)
    XCTAssertEqual(200, result.response!.statusCode)
    
    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testGetFailure() async {
    let url = URL(string: "http://localhost:\(kTestServerPort)/hello_world.json")!
    mockNetworkRoutes.mockGetHelloWorldFailure(router: MockServer.shared.router)
    let expectation = expectation(description: "Network Expectation")

    do {
      _ = try await client.get(HelloWorld.self, url: url)
    } catch {
      expectation.fulfill()
      XCTAssertEqual(HttpStatusCode.Unauthorized, error as! HttpStatusCode)
    }

   await  waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testPostSuccess() async {
    let url = URL(string: "http://localhost:\(kTestServerPort)/hello_world.json")!
    mockNetworkRoutes.mockGetHelloWorldSuccessful(router: MockServer.shared.router)
    let expectation = expectation(description: "Network Expectation")
    let body = ["param_key": "param_value"]
    
    let result = try! await client.post(HelloWorld.self, url: url, body: buildPostFormBodyFrom(dictionary: body))
    expectation.fulfill()
    
    XCTAssertEqual("Hello World!", result.data!.message)
    XCTAssertEqual(200, result.response!.statusCode)
    
    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
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
