// swift-tools-version: 6.0
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

let package = Package(
    name: "clevertap-custom-templates-react-native",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "clevertap-custom-templates-react-native",
            targets: ["CTCustomTemplates"]
        ),
    ],
    targets: [
        .target(
            name: "CTCustomTemplates",
            path: "Sources/CTCustomTemplates",
            resources: [
                .process("Assets")
            ]
        )
    ]
)
