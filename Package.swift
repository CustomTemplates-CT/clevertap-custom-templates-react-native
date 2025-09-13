// // swift-tools-version: 6.0
// import PackageDescription

// let package = Package(
//     name: "CTCustomTemplates",
//     platforms: [.iOS(.v13)], // Ensure iOS support is specified
//     products: [
//         .library(
//             name: "CTCustomTemplates",
//             targets: ["CTCustomTemplates"]
//         ),
//     ],
//     targets: [
//         .target(
//             name: "CTCustomTemplates",
//             path: "Sources/CTCustomTemplates",
//             resources: [
//                 .process("Assets")
//             ]
//         )
//     ]
// )

// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

// swift-tools-version: 5.7
// swift-tools-version:5.7
// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "CTCustomTemplates",
    platforms: [.iOS(.v13)], // Ensure iOS support is specified
    products: [
        .library(
            name: "CTCustomTemplates",
            targets: ["CTCustomTemplates"]
        ),
    ],
    targets: [
        .target(
            name: "CTCustomTemplates",
            dependencies: [],
            path: "CTCustomTemplates/Sources/CTCustomTemplates",
            swiftSettings: [.define("SWIFT_PACKAGE")], // Helps avoid import issues
            linkerSettings: [
                .linkedFramework("UIKit") // ✅ Ensure UIKit is linked
            ]
        )
    ]
)
