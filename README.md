# PorscheConnect 

**NOTE: This is a work-in-progress and not yet ready for use - wait until v1.0.0 is released**

This is an unofficial Porsche Connect API library written in Swift. The primary purpose for this library is to act as a building block for both mobile, desktop and serverside applications built around the Porsche Connect service.

You will require a My Porsche account to be able to make use of this library.

## Is the API official?

Absolutely not. These endpoints are a result of reverse engineering Porsche's web and mobile applications.


# CI/CD Status

The library has a comprehensive suite of unit tests that run on GitHub Actions. Currently the test suite is run on a simulated **iPhone 12 Mini**. Further platforms (macOS) will be added in the future. 

You can see the current build status of the `main` branch here:

![PorscheConnect](https://github.com/driven-app/porsche-connect/workflows/PorscheConnect/badge.svg)


## Requirements

### Swift

Porsche Connect requires Swift 5.2 of higher.

### Supported Platforms

Currently the library supports the following platforms:

* **macOS** (Version 11.0+)
* **iOS** (Version 14+)
* **tvOS** (Version 14+)
* **watchOS** (Version 6+)


## Usage

Create an instance of the library:

```Swift
 let porscheConnect = PorscheConnect(username: "homer.simpson@icloud.example", 
                                     password: "Duh!")
```

Currently the following environments are supported:

* **Germany** (default)
* **Test** (used by the test suite against a mocked server)

A valid [MyPorsche](https://connect-portal.porsche.com) username (email) and password is required to use this library.


## Tests

To run the test suite:

```bash
xcodebuild test -destination "platform=iOS Simulator,name=iPhone 12 mini" -scheme "PorscheConnect"
```

This is similar to the commands that are run in CI to test the library on each git commit. You can change the destinations to any of the libraries supported platforms.


## Command Line Tool

The library is packaged with a command line utility to give a simple terminal access to the set of Porsche Connect services wrapped by this library. 

### Compiling

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

```bash
porsche 
```

## Install

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
