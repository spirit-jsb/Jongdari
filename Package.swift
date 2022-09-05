// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "Jongdari",
  platforms: [
    .iOS(.v10)
  ],
  products: [
    .library(name: "Jongdari", targets: ["Jongdari"]),
  ],
  targets: [
    .target(name: "Jongdari", path: "Sources"),
  ],
  swiftLanguageVersions: [
    .v5
  ]
)

