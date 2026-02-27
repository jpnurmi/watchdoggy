#!/bin/bash
set -euo pipefail

UDID="${1:?Usage: $0 <simulator-udid>}"

PREFS="$HOME/Library/Developer/CoreSimulator/Devices/$UDID/data/Library/Preferences"
mkdir -p "$PREFS"

for plist in com.apple.springboard.plist com.apple.frontboard.plist; do
  P="$PREFS/$plist"
  [ -f "$P" ] || plutil -create xml1 "$P"
  for key in \
    FBLaunchWatchdogScale \
    FBLaunchWatchdogFirstPartyScale \
    FBLaunchWatchdogResumeScale \
    FBLaunchWatchdogScaleOverride \
    FBLaunchWatchdogFirstPartyScaleOverride \
    FBLaunchWatchdogResumeScaleOverride
  do
    /usr/libexec/PlistBuddy -c "Delete :$key" "$P" 2>/dev/null || true
    /usr/libexec/PlistBuddy -c "Add :$key real 100" "$P"
  done
done
