#!/bin/bash
export XCODE_XCCONFIG_FILE=$PWD/../tmp.xcconfig
carthage update --cache-builds --no-use-binaries --platform ios

