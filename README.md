# watchdoggy - mlaunch watchdog shutdown bug repro

Minimal reproduction for a flaky simulator failure caused by mlaunch's watchdog-disabling sequence inside xharness.

## The bug

When xharness launches an app on the iOS Simulator, mlaunch checks whether
simulator watchdog timers are disabled. If they aren't, mlaunch:

1. **Shuts down** the simulator
2. Writes watchdog plist files to disk
3. **Reboots** the simulator

This shutdown/reboot sequence is **flaky on CI** (especially GitHub Actions
`macos-15` runners). The simulator sometimes gets stuck in a broken state:

```
[09:14:34.164] Waiting for sim to boot...
[09:14:45.012] Unable to lookup in current state: Shutdown
[09:14:45.013] Failed to boot the simulator
```

Or it may time out waiting for the boot to complete after mlaunch's reboot.

## What mlaunch checks

Two plist files in `~/Library/Developer/CoreSimulator/Devices/<UDID>/data/Library/Preferences/`:
- `com.apple.springboard.plist`
- `com.apple.frontboard.plist`

Six keys, all must be >= 100:
- `FBLaunchWatchdogScale`
- `FBLaunchWatchdogFirstPartyScale`
- `FBLaunchWatchdogResumeScale`
- `FBLaunchWatchdogScaleOverride`
- `FBLaunchWatchdogFirstPartyScaleOverride`
- `FBLaunchWatchdogResumeScaleOverride`

## Workaround

Pre-write the watchdog plists **before boot** so mlaunch skips its shutdown/reboot dance entirely.

## This repo

A bare `net10.0-ios` app (`dotnet new ios`) that exits with code 0
from `FinishedLaunching`. The CI workflow runs it via xharness **without** any
watchdog pre-disabling, so it will intermittently fail when mlaunch's
shutdown/reboot dance hits the race condition.

