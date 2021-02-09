import SwiftUI

// MARK: - Color Extensions

extension Color {
  init(hex: String) {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&int)
    let a, r, g, b: UInt64
    switch hex.count {
    case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (1, 1, 1, 0)
    }
    
    self.init(
      .sRGB,
      red: Double(r) / 255,
      green: Double(g) / 255,
      blue:  Double(b) / 255,
      opacity: Double(a) / 255
    )
  }
}

// MARK: - URL Extensions

extension URL {
  func addParams(params: Dictionary<String, String>?) -> URL {
    guard let params = params else {
      return self
    }
    
    var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
    var queryItems = [URLQueryItem]()
    
    let existingQueryItems = query?.components(separatedBy: "&").map({
      $0.components(separatedBy: "=")
    }).reduce(into: [URLQueryItem](), { queryItems, pair in
      if pair.count == 2 {
        queryItems.append(URLQueryItem(name: pair[0], value: pair[1]))
      }
    })
    
    if let existingQueryItems = existingQueryItems {
      queryItems.append(contentsOf: existingQueryItems)
    }
    
    for (key, value) in params {
      queryItems.append(URLQueryItem(name: key, value: value))
    }
    
    urlComponents.queryItems = queryItems
    
    return urlComponents.url!
  }
}
