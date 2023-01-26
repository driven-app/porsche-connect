// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "PorscheConnect",
  platforms: [.macOS(.v12), .iOS(.v15), .tvOS(.v15), .watchOS(.v8)],
  products: [
    .executable(
      name: "porsche",
      targets: ["CommandLineTool"]),
    .library(
      name: "PorscheConnect",
      targets: ["PorscheConnect"]),
  ],
  dependencies: [
    .package(url: "https://github.com/envoy/Embassy.git", from: "4.1.4"),
    .package(url: "https://github.com/envoy/Ambassador.git", from: "4.0.5"),
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
    .package(url: "https://github.com/mochidev/XCTAsync.git", .upToNextMajor(from: "1.0.0")),
  ],
  targets: [
    .executableTarget(
      name: "CommandLineTool",
      dependencies: [
        .target(name: "PorscheConnect", condition: .when(platforms: [.macOS])),
        .product(
          name: "ArgumentParser",
          package: "swift-argument-parser",
          condition: .when(platforms: [.macOS])),
      ]),
    .target(
      name: "PorscheConnect",
      dependencies: []),
    .testTarget(
      name: "PorscheConnectTests",
      dependencies: [
        "PorscheConnect",
        "Embassy",
        "Ambassador",
        "XCTAsync"
      ]),
  ]
)
