// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HTTPStubber",
    products: [
        .library(name: "HTTPStubber", targets: ["HTTPStubber"])
    ],
    targets: [
        .target(name: "HTTPStubber", dependencies: []),
        .testTarget(name: "HTTPStubberTests", dependencies: ["HTTPStubber"], resources: [
            .copy("Resources/Body.json"),
            .copy("Resources/Request"),
            .copy("Resources/Response")
        ])
    ]
)
