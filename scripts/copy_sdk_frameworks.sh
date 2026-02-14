#!/bin/bash
set -euo pipefail

PLUGIN="$1"
DEST_PATH="$2"
SPM_ARTIFACTS=".build/artifacts"

mkdir -p "$DEST_PATH/frameworks/"

echo "Copying and optimizing SDK frameworks for plugin: $PLUGIN"

# Helper function to thin an xcframework
optimize_framework() {
    local framework_path="$1"
    echo "  Optimizing: $(basename "$framework_path")"
    
    # 1. Remove Headers and Modules (not needed for user project linking)
    # This significantly reduces file count and some size.
    find "$framework_path" -name "Headers" -type d -exec rm -rf {} +
    find "$framework_path" -name "Modules" -type d -exec rm -rf {} +
    find "$framework_path" -name "_CodeSignature" -type d -exec rm -rf {} +
}

case "$PLUGIN" in
    ads)
        cp -R "$SPM_ARTIFACTS"/swift-package-manager-google-mobile-ads/GoogleMobileAds/GoogleMobileAds.xcframework "$DEST_PATH/frameworks/"
        cp -R "$SPM_ARTIFACTS"/swift-package-manager-google-user-messaging-platform/UserMessagingPlatform/UserMessagingPlatform.xcframework "$DEST_PATH/frameworks/"
        optimize_framework "$DEST_PATH/frameworks/GoogleMobileAds.xcframework"
        optimize_framework "$DEST_PATH/frameworks/UserMessagingPlatform.xcframework"
        ;;
    meta)
        cp -R "$SPM_ARTIFACTS"/googleads-mobile-ios-mediation-meta/MetaAdapter/MetaAdapter.xcframework "$DEST_PATH/frameworks/"
        if [ -d "$SPM_ARTIFACTS/googleads-mobile-ios-mediation-meta/FBAudienceNetwork/Static/FBAudienceNetwork.xcframework" ]; then
             cp -R "$SPM_ARTIFACTS"/googleads-mobile-ios-mediation-meta/FBAudienceNetwork/Static/FBAudienceNetwork.xcframework "$DEST_PATH/frameworks/"
        else
             cp -R "$SPM_ARTIFACTS"/googleads-mobile-ios-mediation-meta/FBAudienceNetwork/FBAudienceNetwork.xcframework "$DEST_PATH/frameworks/"
        fi
        optimize_framework "$DEST_PATH/frameworks/MetaAdapter.xcframework"
        optimize_framework "$DEST_PATH/frameworks/FBAudienceNetwork.xcframework"
        ;;
    vungle)
        cp -R "$SPM_ARTIFACTS"/googleads-mobile-ios-mediation-liftoffmonetize/LiftoffMonetizeAdapter/LiftoffMonetizeAdapter.xcframework "$DEST_PATH/frameworks/"
        cp -R "$SPM_ARTIFACTS"/vungleadssdk-swiftpackagemanager/VungleAdsSDK/VungleAdsSDK.xcframework "$DEST_PATH/frameworks/"
        optimize_framework "$DEST_PATH/frameworks/LiftoffMonetizeAdapter.xcframework"
        optimize_framework "$DEST_PATH/frameworks/VungleAdsSDK.xcframework"
        ;;
esac
