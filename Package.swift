// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MVVMKit",
	platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "MVVMKitBond",
            targets: ["MVVMKit_Bond"]
		),
		.library(
			name: "MVVMKitRx",
			targets: ["MVVMKit_Rx"]
		)
    ],
    dependencies: [
		.package(name: "SnapKit", url: "https://github.com/SnapKit/SnapKit", from: "5.0.1"),
		.package(name: "Bond", url: "https://github.com/DeclarativeHub/Bond", from: "7.8.0"),
		.package(name: "RxSwift", url: "https://github.com/ReactiveX/RxSwift", from: "6.2.0"),
		.package(name: "RxDataSources", url: "https://github.com/RxSwiftCommunity/RxDataSources", from: "5.0.0"),
        .package(name: "Differ", url: "https://github.com/tonyarnold/Differ", from: "1.4.6")
	],
    targets: [
        .target(
            name: "MVVMKit_Base",
            dependencies: [
				.product(name: "SnapKit", package: "SnapKit")
			],
			path: "MVVMKit/Base"
		),
		.target(
			name: "MVVMKit_Bond",
			dependencies: [
				"MVVMKit_Base",
				.product(name: "Bond", package: "Bond")
			],
			path: "MVVMKit/Bond"
		),
		.target(
			name: "MVVMKit_Rx",
			dependencies: [
				"MVVMKit_Base",
				.product(name: "RxSwift", package: "RxSwift"),
				.product(name: "RxDataSources", package: "RxDataSources"),
                .product(name: "Differ", package: "Differ")
			],
			path: "MVVMKit/Rx"
		)
    ]
)
