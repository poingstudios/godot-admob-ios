#!/bin/bash
set -euo pipefail

PLUGIN="$1"
DEST_PATH="$2"
# Use absolute path if possible or relative from where script is run. 
# We assume this script runs from project root or handles paths correctly.
SPM_ARTIFACTS=".build/artifacts"

mkdir -p "$DEST_PATH/frameworks/"

echo "Copying SDK frameworks for plugin: $PLUGIN to $DEST_PATH/frameworks/"

case "$PLUGIN" in
    ads)
        # Google Mobile Ads SDK
        cp -R "$SPM_ARTIFACTS"/swift-package-manager-google-mobile-ads/GoogleMobileAds/GoogleMobileAds.xcframework "$DEST_PATH/frameworks/"
        cp -R "$SPM_ARTIFACTS"/swift-package-manager-google-user-messaging-platform/UserMessagingPlatform/UserMessagingPlatform.xcframework "$DEST_PATH/frameworks/"
        ;;
    meta)
        # Meta Audience Network Adapter
        # Note: Using Static FBAudienceNetwork to avoid embedding dynamic frameworks if possible, 
        # but check if Godot supports embedding static frameworks correctly. 
        # Actually .xcframework handles static/dynamic inside. The "Static" folder implies static library.
        # If we use Dynamic, we must sign it. Static is usually safer for plugins unless resources are needed.
        # Let's try Static first as it's less hassle for users to sign.
        cp -R "$SPM_ARTIFACTS"/googleads-mobile-ios-mediation-meta/MetaAdapter/MetaAdapter.xcframework "$DEST_PATH/frameworks/"
        if [ -d "$SPM_ARTIFACTS/googleads-mobile-ios-mediation-meta/FBAudienceNetwork/Static/FBAudienceNetwork.xcframework" ]; then
             cp -R "$SPM_ARTIFACTS"/googleads-mobile-ios-mediation-meta/FBAudienceNetwork/Static/FBAudienceNetwork.xcframework "$DEST_PATH/frameworks/"
        else
             # Fallback to whatever is available if Static structure changes
             cp -R "$SPM_ARTIFACTS"/googleads-mobile-ios-mediation-meta/FBAudienceNetwork/FBAudienceNetwork.xcframework "$DEST_PATH/frameworks/"
        fi
        ;;
    vungle)
        # Vungle (Liftoff) Adapter
        cp -R "$SPM_ARTIFACTS"/googleads-mobile-ios-mediation-liftoffmonetize/LiftoffMonetizeAdapter/LiftoffMonetizeAdapter.xcframework "$DEST_PATH/frameworks/"
        cp -R "$SPM_ARTIFACTS"/vungleadssdk-swiftpackagemanager/VungleAdsSDK/VungleAdsSDK.xcframework "$DEST_PATH/frameworks/"
        ;;
esac
