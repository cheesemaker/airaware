# AirAware
<img src = "https://raw.githubusercontent.com/cheesemaker/airaware/main/Documents/icon.png" width=64 height = 64>

AirAware is an open source framework to help developers monitor and understand the air quality around them. Currently, AirAware supports:
- Awair© smart devices for monitoring indoor air quality
- AirNow - the EPA supported AQI (Air Quality Indicator) service
- WeatherFlow - Outdoor weather station readings when configured to use a WF base-station
- PurpleAir - Network of weather stations maintained and owned by private citizens


## Accounts and API Keys:
- For Awair© devices, the library supports both OAuth and direct access token integrations. See [https://docs.developer.getawair.com](https://docs.developer.getawair.com) for more information.

- For WeatherFlow© devices, it supports OAuth.

- For the AirNow service, it supports both an embedded web login as well as native username/password support. An active user account is required for each user, however retrieval of the access key has been automated.

- For the PurpleAir service, no login is required, however an API key must be requested and obtained from Purple


<img src = "https://raw.githubusercontent.com/cheesemaker/airaware/main/Documents/screenshot.jpeg">

## Installation

### - Swift Package Manager

AirAware has native SPM support.

### - Carthage

AirAware may be installed via [Carthage](https://github.com/Carthage/Carthage). To install it, simply add the following line to your `Cartfile`:

```
github "cheesemaker/airaware"
```

Then, following the instructions for [integrating Carthage frameworks into your app](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos), link the `UUSwift` framework into your project.

## Requirements

This library requires a deployment target of iOS 13.0 or greater or OSX 10.10 or greater.
AirAware currently supports Swift version 4.0 

## Contributing

Please **open pull requests against the `develop` branch**

## Swift

AirAware is written entirely in Swift and currently does not support Objective-C interoperability.

## License

AirAware is available under the Apache 2.0 license. See [`LICENSE.md`](https://github.com/cheesemaker/airaware/blob/master/LICENSE.md) for more information.

## Contributors

[A list of contributors is available through GitHub.](https://github.com/cheesemaker/airaware/graphs/contributors)
