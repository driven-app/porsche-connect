# PorscheConnect 

This is an unofficial Porsche Connect API library written in Swift. The primary purpose for this library is to act as a base building block for both mobile, desktop and serverside applications built around the Porsche Connect service.

You will require a My Porsche account to be able to make use of this library.

# CI/CD Status

The library has a comprehensive suite of unit tests that run on GitHub Actions. Currently the test suite is run on a simulated **iPhone 12 Mini**. Further platforms (Mac, Linux) will be added in the future. 

You can see the current build status of the `main` branch here:

![PorscheConnect](https://github.com/driven-app/porsche-connect/workflows/PorscheConnect/badge.svg)

## Requirements

### Swift

Porsche Connect requires Swift 5.2 of higher.

## Usage

Create an instance of the library:

```Swift
 let porscheConnect = PorscheConnect(environment: .Ireland, username: "homer.simpson@icloud.example", password: "Duh!")
```

Currently the following environments are supported:

* Ireland
* Germany
* Test (used by the test suite against a mocked server)

A valid ![MyPorsche](https://connect-portal.porsche.com) username (email) and password is required to use this library.


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

