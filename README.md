<div align=center>

# PorscheConnect 

![PorscheConnect](https://github.com/driven-app/porsche-connect/workflows/PorscheConnect/badge.svg)
[![License](https://img.shields.io/github/license/driven-app/porsche-connect)](https://github.com/driven-app/porsche-connect/blob/main/LICENSE)
[![Reviewed by Hound](https://img.shields.io/badge/Reviewed_by-Hound-8E64B0.svg)](https://houndci.com)

</div>

This is an unofficial Porsche Connect API library written in Swift. The primary purpose for this library is to act as a building block for both mobile, desktop and serverside applications built around the Porsche Connect service.

You will require a My Porsche account to be able to make use of this library.

## Is the API official?

Absolutely not. These endpoints are a result of reverse engineering Porsche's web and mobile applications.


## CI/CD Status

The library has a comprehensive suite of unit tests that run on GitHub Actions. Currently the test suite is run on a Intel based macOS v12.4.x running XCode 14.2.

You can see the current build status of the `main` branch here:

![PorscheConnect](https://github.com/driven-app/porsche-connect/workflows/PorscheConnect/badge.svg)


## Requirements

### Swift

Porsche Connect requires Swift 5.5 or higher. It uses the new async/await concurrency language features introduced in Swift 5.5.

### Supported Platforms

Currently the library supports the following platforms:

* **macOS** (Version 11.0+)
* **iOS** (Version 14+)
* **tvOS** (Version 14+)
* **watchOS** (Version 6+)

### Swift Package Index

This library is availble on the Swift Package Index at [https://swiftpackageindex.com/driven-app/porsche-connect](https://swiftpackageindex.com/driven-app/porsche-connect).


# Usage

### Getting Started

Create an instance of the library:

```swift
 let porscheConnect = PorscheConnect(username: "homer.simpson@icloud.example", 
                                     password: "Duh!")
```

The following environments are supported:

* **Germany** (default)
* **Test** (used by the test suite against a mocked server)

A valid [MyPorsche](https://my.porsche.com) username (email) and password is required to use this library.


### List Vehicles

To get a list of vehicles associated with your My Porsche account . This call will return an array of `Vehicle` structs, with nested `VehicleAttribute`'s and `VehiclePicture`'s as appropriate for the vehicles configuration.

```swift
try {
  let result = porscheConnect.vehicles()
  if let vehicles = result.vehicles {
    // Do something with vehicles
  }
} catch {
  // Handle the error
}
```

For example, to get the external [Color](https://developer.apple.com/documentation/swiftui/color) (a SwiftUI struct) for the first car in your account:

```swift
try {
  let result = porscheConnect.vehicles()
  if let vehicles = result.vehicles {
    let firstVehicle = vehicles.first!
    let color: Color = firstVehicle.color
  }
} catch {
  // Handle the error
}
```

### Summary of a vehicle

To get a summary for a vehicle. This call will return a `Summary` struct.

```swift
try {
  let result = porscheConnect.summary(vehicle: vehicle)
  if let summary = result.summary {
    // Do something with the summary
  }
} catch {
  // Handle the error
}
```

### Position of a vehicle

To get last reported position for a vehicle. This call will return a `Position` struct. 

```swift
try {
  let result = porscheConnect.position(vehicle: vehicle)
  if let position = result.position {
    // Do something with the position
  }
} catch {
  // Handle the error
}
```

### Capabilities of a vehicle

To get capabilities for a vehicle. This call will return a `Capabilities` struct. This struct has nested `OnlineRemoteUpdateStatus` and `HeatingCapabilities` structs as appropriate for the vehicle.

```swift
try {
  let result = porscheConnect.capabilities(vehicle: vehicle)
  if let capabilities = result.capabilities {
    // Do something with the capabilities
  }
} catch {
  // Handle the error
}
```

### Emobility of a vehicle

If the vehicle is a plug-in hybrid (PHEV) or a battery electric vehicle (BEV) this will return the status and configuration of the e-mobility aspects of the vehicle. This call requires both a vehicle and its matching capabilities. This call will return a `Emobility` struct. Passing in a vehicles `Capabilites` is optional – if none is passed in, the library will assume the vehicle is based on the `J1` (Taycan) platform.

```swift
try {
  let result = porscheConnect.emobility(vehicle: vehicle, capabilities: capabilities)
  if let emobility = result.emobility {
    // Do something with the emobility
  }
} catch {
  // Handle the error
}
```

### Status of a vehicle

To get the status for a vehicle. This call will return a `Status` struct. This struct has nested `ServiceIntervals`, and `RemainingRanges` structs as appropriate for the vehicle.

```swift
try {
  let result = porscheConnect.status(vehicle: vehicle)
  if let status = result.status {
    // Do something with the status
  }
} catch {
  // Handle the error
}
```

### Honk and Flash

To ask the vehicle to flash its indicators and optionally honk the horn. This call will return a `RemoteCommandAccepted` struct when the request has been accepted. The `andHorn` paramater is optional and defaults to false.

```swift
try {
  let result = porscheConnect.flash(vehicle: vehicle, andHorn: true)
  if let remoteCommandAccepted = result.remoteCommandAccepted {
    // Do something with the remote command
  }
} catch {
  // Handle the error
}
```

As Honk and Flash is a remote command that can take time to reach and be executed by the car, you can check the status of the command. You pass in both the vehicle and the response from the `flash()` call above. 

The `status` is mapped to a strongly typed enum that can be retrieved by accessing the `remoteStatus` calculated property. 

Passing in a capabilites paramater is not required to determine the status of a Honk and Flash command.

```swift
try {
  let result = porscheConnect.checkStatus(vehicle: vehicle, remoteCommand: remoteCommandAccepted)
  if let remoteCommandStatus = result.remoteCommand {
    // Do something with the remote command status
  }
} catch {
  // Handle the error
}
```

### Toggle Direct Charging

To toggle a battery electric vehicle (BEV) direct charging mode to on or off. This call will return a `RemoteCommandAccepted` struct when the request has been accepted. 

The `enable` paramater is optional and defaults to true. 

Passing in a vehicles `Capabilites` is optional – if none is passed in, the library will assume the vehicle is based on the `J1` (Taycan) platform.

```swift
try {
  let result = porscheConnect.toggleDirectCharging(vehicle: vehicle, capabilities: capabilities, enable: false)
  if let remoteCommandAccepted = result.remoteCommandAccepted {
    // Do something with the remote command
  }
} catch {
  // Handle the error
}
```

As Toggle Direct Charging is a remote command that can take time to reach and be executed by the car, you can check the status of the command. You pass in both the vehicle and the response from the `toggleDirectCharging()` call above. 

The `status` is mapped to a strongly typed enum that can be retrieved by accessing the `remoteStatus` calculated property. 

Passing in a vehicles `Capabilites` is optional – if none is passed in, the library will assume the vehicle is based on the `J1` (Taycan) platform.

```swift
try {
  let result = porscheConnect.checkStatus(vehicle: vehicle, capabilities: capabilities, remoteCommand: remoteCommandAccepted)
  if let remoteCommandStatus = result.remoteCommand {
    // Do something with the remote command status
  }
} catch {
  // Handle the error
}
```

### Lock Vehicle

To ask the vehicle to remote lock. This call will return a `RemoteCommandAccepted` struct when the request has been accepted. 

Make sure that there are no vehicle keys, persons or animals in the vehicle.

```swift
try {
  let result = porscheConnect.lock(vehicle: vehicle)
  if let remoteCommandAccepted = result.remoteCommandAccepted {
    // Do something with the remote command
  }
} catch {
  // Handle the error
}
```

As Lock Vehicle is a remote command that can take time to reach and be executed by the car, you can check the status of the command. You pass in the vehicle, optionally the vehicles capabilities and the response from the `lock()` call above. 

The `status` is mapped to a strongly typed enum that can be retrieved by accessing the `remoteStatus` calculated property. 

Passing in a capabilites paramater is not required to determine the status of a Lock command.

```swift
try {
  let result = porscheConnect.checkStatus(vehicle: vehicle, remoteCommand: remoteCommandAccepted)
  if let remoteCommandStatus = result.remoteCommand {
    // Do something with the remote command status
  }
} catch {
  // Handle the error
}
```

### Unlock Vehicle

To ask the vehicle to remote unlock. As this action impacts the security of the vehicle (by unlocking it), it also requires the users four digit security (PIN) code. This call will return a `RemoteCommandAccepted` struct when the request has been accepted. 

```swift
try {
  let result = porscheConnect.unlock(vehicle: vehicle, pin: "1234")
  if let remoteCommandAccepted = result.remoteCommandAccepted {
    // Do something with the remote command
  }
} catch {
  // Handle the error
}
```

As Unlock Vehicle is a remote command that can take time to reach and be executed by the car, you can check the status of the command. You pass in the vehicle, optionally the vehicles capabilities and the response from the `unlock()` call above. 

The `status` is mapped to a strongly typed enum that can be retrieved by accessing the `remoteStatus` calculated property. 

Passing in a capabilites paramater is not required to determine the status of a Unlock command.

```swift
try {
  let result = porscheConnect.checkStatus(vehicle: vehicle, remoteCommand: remoteCommandAccepted)
  if let remoteCommandStatus = result.remoteCommand {
    // Do something with the remote command status
  }
} catch {
  // Handle the error
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

If you would like to build a universal binary for both Intel (x86) and Apple (ARC) processors (M-series Mac's, iPhones, iPads, Watches) then run the compiler with:

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
  flash
  honk-and-flash
  toggle-direct-charging
  lock
  unlock
  
  See 'porsche help <subcommand>' for detailed help.
```

By default, the CLI tool will attempt to use your system locale for all API requests. This will
affect the localization of the API responses. If your system locale is not supported, Germany will
be used instead. You can choose one of the supported locales using the `--locale` flag and passing
one of the supported locales, such as `de_DE` or `en_US`.

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

To show the current status of a vehicle:

```bash
$ porsche show-status <username> <password> <vin>

Overall lock status: Closed and locked
Battery level: 73.0%, Mileage: 2,206 kilometers
Remaining range is 292 kilometers
Next inspection in 27,842 kilometers or on Dec 10, 2024
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

To flash the indicators of a vehicle:

```bash
$ porsche flash <username> <password> <vin>

Remote command \"Flash\" accepted by Porsche API with ID 123456
```

To flash and honk the indicators of a vehicle:

```bash
$ porsche honk-and-flash <username> <password> <vin>

Remote command \"Honk and Flash\" accepted by Porsche API with ID 123456
```

To toggle the direct charging mode of a vehicle:

```bash
$ porsche toggle-direct-charging <username> <password> <vin> <toggle-direct-charging-on>

Remote command \"Toggle Direct Charging\" accepted by Porsche API with ID 123456
```

To lock a vehicle:

```bash
$ porsche lock <username> <password> <vin>

Remote command \"Lock\" accepted by Porsche API with ID 123456
```

To unlock a vehicle:

```bash
$ porsche unlock <username> <password> <vin> <pin>

Remote command \"Unlock\" accepted by Porsche API with ID 123456
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
