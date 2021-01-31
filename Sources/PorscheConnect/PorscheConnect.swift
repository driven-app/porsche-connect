import Foundation

struct PorscheConnect {
  var text = "Hello, World!"
}

public enum Environment: String, CaseIterable {
  case  Ireland
  
  public func baseURL() -> URL {
    switch self {
    case .Ireland:
      return URL(string: "https://api.porsche.com")!
    }
  }
}
