# CrownControl (WIP)

[![Platform](http://img.shields.io/badge/platform-iOS-blue.svg?style=flat)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-Swift-brightgreen.svg?style=flat)](https://developer.apple.com/swift)
[![Version](https://img.shields.io/cocoapods/v/CrownControl.svg?style=flat-square)](http://cocoapods.org/pods/CrownControl)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](http://mit-license.org)
![](https://travis-ci.com/huri000/CrownControl.svg?branch=master)

* [Overview](#overview)
  * [Features](#features)
* [Example Project](#example-project)
* [Requirements](#requirements)
* [Installation](#installation)
* [Author](#author)
* [License](#license)

## Overview

CrownControl is a simple scroll-view controller inspired by Apple Watch Digital Crown.

### Features

The crown consists of background and foreground surfaces. The foreground is an indicator which spins around the center as the attached scroll view scrolls. 

## Example Project

The example project contains samples where each demonstrate CrownControl usability in a scrollable context.

## Requirements

- iOS 9 or any higher version.
- Swift 4.2 or any higher version.
- CrownControl leans heavily on [QuickLayout](https://github.com/huri000/QuickLayout) - A lightwight library written in Swift that is used to easily layout views programmatically.

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate QuickLayout into your Xcode project using CocoaPods, specify the following in your `Podfile`:

```ruby
pod 'CrownControl'
```

Then, run the following command:

```bash
$ pod install
```
## Author

Daniel Huri, huri000@gmail.com

## License

CrownControl is available under the MIT license. See the LICENSE file for more info.
