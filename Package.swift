// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "PorscheConnect",
  platforms: [
    .macOS(.v11),
    .iOS(.v14),
    .tvOS(.v14),
    .watchOS(.v6)
  ],
  products: [
    .executable(
      name: "porsche",
      targets: ["CommandLineTool"]),
    .library(
      name: "PorscheConnect",
      targets: ["PorscheConnect"]),
  ],
  dependencies: [
    .package(url: "https://github.com/envoy/Embassy.git", from: "4.1.2"),
    .package(url: "https://github.com/envoy/Ambassador.git", from: "4.0.5"),
    .package(url: "https://github.com/apple/swift-argument-parser", from: "0.5.0")
  ],
  targets: [
    .executableTarget(
      name: "CommandLineTool",
      dependencies: ["PorscheConnect",
                     .product(name: "ArgumentParser", package: "swift-argument-parser")]),
    .target(
      name: "PorscheConnect",
      dependencies: []),
    .testTarget(
      name: "PorscheConnectTests",
      dependencies: ["PorscheConnect", "Embassy", "Ambassador"]),
  ]
)
