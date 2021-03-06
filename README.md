# PorscheConnect 

This is an unofficial Porsche Connect API library written in Swift. The primary purpose for this library is to act as a building block for both mobile, desktop and serverside applications built around the Porsche Connect service.

You will require a My Porsche account to be able to make use of this library.

## Is the API official?

Absolutely not. These endpoints are a result of reverse engineering Porsche's web and mobile applications.


## CI/CD Status

The library has a comprehensive suite of unit tests that run on GitHub Actions. Currently the test suite is run on a simulated **iPhone 12 Mini**. Further platforms (macOS) will be added in the future. 

You can see the current build status of the `main` branch here:

![PorscheConnect](https://github.com/driven-app/porsche-connect/workflows/PorscheConnect/badge.svg)


## Requirements

### Swift

Porsche Connect requires Swift 5.2 or higher.

### Supported Platforms

Currently the library supports the following platforms:

* **macOS** (Version 11.0+)
* **iOS** (Version 14+)
* **tvOS** (Version 14+)
* **watchOS** (Version 6+)


# Usage

### Getting Started

Create an instance of the library:

```swift
 let porscheConnect = PorscheConnect(username: "homer.simpson@icloud.example", 
                                     password: "Duh!")
```

Currently the following environments are supported:

* **Germany** (default)
* **Test** (used by the test suite against a mocked server)

A valid [MyPorsche](https://connect-portal.porsche.com) username (email) and password is required to use this library.


### List Vehicles

To get a list of vehicles associated with your My Porsche account . This call will return an array of `Vehicle` structs, with nested `VehicleAttribute`'s and `VehiclePicture`'s as appropriate for the vehicles configuration.

```swift
porscheConnect.vehicles { result in
  switch result {
  case .success(let (vehicles, response)):
    break // Do something with vehicles or raw response
  case .failure(let error):
    break // Handle the error
  }
}
```

For example, to get the external [Color](https://developer.apple.com/documentation/swiftui/color) (a SwiftUI struct) for the first car in your account:

```swift
porscheConnect.vehicles { result in
  switch result {
  case .success(let (vehicles, _)):
    let firstVehicle = vehicles!.first!
    let color: Color = firstVehicle.externalColor
  case .failure(let error):
    break // Handle the error
  }
}
```

### Summary of a vehicle

To get a summary for a vehicle. This call will return a `Summary` struct.

```swift
let vehicle = vehicles.first!
porscheConnect.summary(vehicle: vehicle) { result in
  switch result {
  case .success(let (summary, response)):
    break // Do something with the summary or raw response
  case .failure(let error):
    break // Handle the error
  }
}
```

### Position of a vehicle

To get last reported position for a vehicle. This call will return a `Position` struct. 

```swift
let vehicle = vehicles.first!
porscheConnect.position(vehicle: vehicle) { result in
  switch result {
  case .success(let (position, response)):
    break // Do something with the position or raw response
  case .failure(let error):
    break // Handle the error
  }
}
```

### Capabilities of a vehicle

To get capabilities for a vehicle. This call will return a `Capabilities` struct. This struct has nested `OnlineRemoteUpdateStatus` and `HeatingCapabilities` structs as appropriate for the vehicle.

```swift
let vehicle = vehicles.first!
porscheConnect.capabilities(vehicle: vehicle) { result in
  switch result {
  case .success(let (capabilities, response)):
    break // Do something with the capabilities or raw response
  case .failure(let error):
    break // Handle the error
  }
}
```

### Emobility of a vehicle

If the vehicle is a plug-in hybrid (PHEV) or a battery electric vehicle (BEV) this will return the status and configuration of the e-mobility aspects of the vehicle. This call requires both a vehicle and its matching capabilities. This call will return a `Emobility` struct.

```swift
porscheConnect.emobility(vehicle: vehicle, capabilities: capabilities) { result in
  switch result {
  case .success(let (emobility, response)):
    break // Do something with the emobility or raw response
  case .failure(let error):
    break // Handle the error
  }
}
```

# Tests

To run the test suite:

```bash
xcodebuild test -destination "platform=iOS Simulator,name=iPhone 12 mini" -scheme "PorscheConnect"
```

This is similar to the commands that are run in CI to test the library on each git commit. You can change the destinations to any of the libraries supported platforms.


# Command Line Tool

The library is packaged with a command line utility to give a simple terminal access to the set of Porsche Connect services wrapped by this library. 

### Compiling

From within the project directory, run:

```bash
swift build -c release
```

This will place the excutable in `<project-dir>/.build/apple/Products/Release` folder, where it will be named `porsche`. If you want to make it available more generally when using a terminal, copy it to `/usr/local/bin` from the project dir:

```bash
cp -f .build/apple/Products/Release/porsche /usr/local/bin
```

### Universal binary

If you would like to build a universal binary for both Intel (x86) and Apple (M1) Mac's then run the compiler with:

```bash
swift build -c release --arch arm64 --arch x86_64
```

### Using

To get help on the various commands available, call with `--help` on either the overall command or any of the sub-commands:

```bash
$ porsche --help

OVERVIEW: A command-line tool to call and interact with Porsche Connect services

USAGE: porsche <subcommand>

OPTIONS:
  --version               Show the version.
  -h, --help              Show help information.

SUBCOMMANDS:
  list-vehicles
  show-summary
  show-position
  show-capabilities
  show-emobility
  
  See 'porsche help <subcommand>' for detailed help.
```

To get a list of all the vehicles associated with your My Porsche account:

```bash
$ porsche list-vehicles <username> <password>

#1 => Model: Taycan 4S; Year: 2021; Type: Y1ADB1; VIN: WP0ZZZXXXXXXXXXXX
```

To show the summary for a specific vehicle – the nickname is usually set to be the licenseplate of the car, but can be any value set by the owner:

```bash
$ porsche show-summary <username> <password> <vin>

Model Description: Taycan 4S; Nickname: 211-D-12345
```

To show the current position of a vehicle:

```bash
$ porsche show-position <username> <password> <vin>

Latitude: 53.395367; Longitude: -6.389296; Heading: 68
```

To show the capabilties of a vehicle:

```bash
$ porsche show-capabilities <username> <password> <vin>

Display parking brake: yes; Needs SPIN: yes; Has RDK: yes; Engine Type: BEV; Car Model: J1; Front Seat Heating: yes; Rear Seat Heating: no; Steering Wheel Position: RIGHT; Honk & Flash: yes
```

To show the emobility of a vehicle:

*(Note: this only displays a small subset of the information that the emobility service returns)*

```bash
$ porsche show-emobility <username> <password> <vin>

Battery Level: 53%; Remaining Range: 180 KM; Charging Status: NOT_CHARGING; Plug Status: DISCONNECTED
```
# Install

### Package Manager

To do this, add the repo to `Package.swift`, like this:

```swift
import PackageDescription

let package = Package(
  name: "PorscheConnect",
  dependencies: [
    .package(url: "git@github.com:driven-app/porsche-connect.git", 
             from: "0.1"),
  ]
)
```
