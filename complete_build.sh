#!/bin/bash

echo "Setting up Xcode developer directory..."
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer

echo "Accepting Xcode license..."
sudo xcodebuild -license accept

echo "Building whisper.cpp XCFramework..."
cd ../whisper.cpp
./build-xcframework.sh

echo "Returning to VoiceInk directory..."
cd ../VoiceInk

echo "Building VoiceInk project..."
xcodebuild -project VoiceInk.xcodeproj -scheme VoiceInk -configuration Debug build

echo "Build complete!"