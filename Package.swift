// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "CCKit",
    platforms: [
        .iOS(.v12),
    ],
    products: [
        .library(name: "CCKit", targets: ["CCKit"]),
    ],
    targets: [
        .target(
            name: "CCKit",
            path: ".",
            // Same source selection as CCKit.podspec.
            exclude: [
                "CCKit/CCTwitterLoginManager.h",
                "CCKit/CCTwitterLoginManager.m",
                "CCKit/OAuthCore",
                "CCKit/TWiOSReverseAuth",
                // Not part of the library; keeps SwiftPM from treating
                // their files as package resources.
                "CCKitDemo",
                "CCKit.xcodeproj",
            ],
            sources: ["CCKit"],
            // Symlinks to the public headers, laid out as <CCKit/Header.h>.
            // Kept outside CCKit/ so the podspec's source glob is unaffected.
            publicHeadersPath: "SwiftPM/include",
            cSettings: [
                // Keeps CCLog/CCDebug compiled out of CCKit's own sources,
                // as under CocoaPods. Not applied to consumers.
                .define("CCKIT_DISABLE_INTERNAL_LOGGING"),
            ],
            linkerSettings: [
                .linkedLibrary("z"),
                .linkedFramework("UIKit"),
                .linkedFramework("QuartzCore"),
            ]
        ),
    ]
)
