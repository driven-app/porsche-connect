import CoreLocation
import Foundation

public struct Position: Codable {

  // MARK: Properties

  public let carCoordinate: CarCoordinate
  public let heading: CLLocationDirection

  // MARK: -

  public struct CarCoordinate: Codable {

    // MARK: Properties

    public let geoCoordinateSystem: String
    public let latitude: CLLocationDegrees
    public let longitude: CLLocationDegrees
  }
}
