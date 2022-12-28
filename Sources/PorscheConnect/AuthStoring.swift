import Foundation

/// A type that is able to handle storage and retrieval of OAuth authentication tokens.
public protocol AuthStoring {
  /// Asks the receiver to store the given OAuthToken with the given key.
  func storeAuthentication(token: OAuthToken?, for key: String)

  /// Asks the receiver to return an OAuthToken, if one exists, for the given key.
  func authentication(for key: String) -> OAuthToken?
}
