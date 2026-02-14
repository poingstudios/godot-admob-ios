// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "PoingGodotAdMobDeps",
    platforms: [.iOS(.v13)],
    dependencies: [
        // Google Mobile Ads SDK
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", exact: "12.14.0"),
        
        // Meta Audience Network Adapter
        .package(url: "https://github.com/googleads/googleads-mobile-ios-mediation-meta.git", exact: "6.20.100"),
        
        // Vungle (Liftoff Monetize) Adapter
        .package(url: "https://github.com/googleads/googleads-mobile-ios-mediation-liftoffmonetize.git", exact: "7.5.300"),
    ],
    targets: [
        .target(
            name: "PoingGodotAdMobDeps",
            dependencies: [
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads"),
                .product(name: "GoogleMobileAdsFacebookAdapter", package: "googleads-mobile-ios-mediation-meta"),
                .product(name: "GoogleMobileAdsLiftoffMonetizeAdapter", package: "googleads-mobile-ios-mediation-liftoffmonetize"),
            ],
            path: "PoingGodotAdMobDeps"
        )
    ]
)
