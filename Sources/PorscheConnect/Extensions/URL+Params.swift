import Foundation

extension URL {
  func addParams(params: [String: String]?) -> URL {
    guard let params = params else {
      return self
    }

    var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
    var queryItems = [URLQueryItem]()

    let existingQueryItems = query?.components(separatedBy: "&").map({
      $0.components(separatedBy: "=")
    }).reduce(
      into: [URLQueryItem](),
      { queryItems, pair in
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
