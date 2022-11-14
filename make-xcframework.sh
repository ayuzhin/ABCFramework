#!/bin/sh

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
cd $BASE_DIR

BUILD_DIR=${BASE_DIR}/build
FRAMEWORK_NAME=ABCFramework
PROJECT_FILE=${BASE_DIR}/${FRAMEWORK_NAME}/${FRAMEWORK_NAME}.xcodeproj

rm -rf ${BUILD_DIR}

# iOS devices
xcodebuild archive \
    -project "${PROJECT_FILE}" \
    -scheme $FRAMEWORK_NAME \
    -archivePath "${BUILD_DIR}/$FRAMEWORK_NAME-devices.xcarchive" \
    -sdk iphoneos \
    ENABLE_BITCODE=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    SKIP_INSTALL=NO \
    | xcpretty

# iOS simulator
xcodebuild archive \
    -project "${PROJECT_FILE}" \
    -scheme $FRAMEWORK_NAME \
    -archivePath "${BUILD_DIR}/$FRAMEWORK_NAME-simulators.xcarchive" \
    -sdk iphonesimulator \
    ENABLE_BITCODE=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    SKIP_INSTALL=NO \
    | xcpretty

# -------------------
# PACKAGE XCFRAMEWORK
# -------------------

xcodebuild -create-xcframework \
    -framework "${BUILD_DIR}/$FRAMEWORK_NAME-devices.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME.framework" \
    -framework "${BUILD_DIR}/$FRAMEWORK_NAME-simulators.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME.framework" \
    -output "${BUILD_DIR}/$FRAMEWORK_NAME.xcframework"