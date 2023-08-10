#!/bin/bash

# Run the Ruby script to update Pods in Podfile
ruby update_pods.rb

# Run pod install with --repo-update flag
cd ../../../../
pod install --repo-update
