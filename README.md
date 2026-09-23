# Decade IPA

GitHub Actions iOS builder for **Decade**.

This repository contains a native `WKWebView` iOS wrapper and a GitHub Actions workflow that builds an unsigned `.ipa` using GitHub's macOS/Xcode runner.

## Build

1. Open **Actions**.
2. Run **Build Decade IPA**.
3. Download the `Decade-IPA` artifact.
4. Extract `Decade-unsigned.ipa` and sign/sideload it with your preferred tool.

## Game files

The iOS wrapper loads bundled web assets from `App/Resources/Web`.

The full game archive is over GitHub's normal 100 MB single-file repository limit, so large game media should be supplied through a GitHub Release asset or split/uploaded with Git LFS. The project includes a placeholder page so the iOS build itself can be verified before the complete game payload is added.

- App: `Decade`
- Bundle ID: `com.abx.decade`
- Deployment target: iOS 16+
- iPhone + iPad
- Portrait + landscape
- Offline WKWebView wrapper
