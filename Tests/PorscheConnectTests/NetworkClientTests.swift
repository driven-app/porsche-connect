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
  
  func testGet() {
    
  }
}
