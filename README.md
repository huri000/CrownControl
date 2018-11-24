# CrownControl

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
* [Usage](#usage)
  * [Quick Usage](#quick-usage)
  * [Crown Attributes](#crown-attributes)
    * [Scroll Axis](#scroll-axis)
    * [Anchor Position](#anchor-position)
    * [Spin Direction](#spin-direction)
    * [User Interaction](#user-interaction)
    * [Style](#style)
    * [Sizes](#sizes)
    * [Feedback](#feedback)
* [Author](#author)
* [License](#license)

## Overview

Inspired by Apple Watch Digital Crown, CrownControl is a tiny accessory view that enables scrolling through scrollable content possible without lifting your thumb.

### Features

The crown consists of background and foreground surfaces. 
The foreground is an indicator which spins around the center as the attached scroll view offset changes.

- [x] Can be repositioned either using force touch or long press.
- [x] Can be spinned clockwise and counter clockwise.
- [x] Most of the user interaction actions are configurable.
- [x] The background and foreground sizes are configurable.
- [x] Can be fully stylized.

## Example Project

The example project contains samples where each demonstrates the CrownControl usability in a scrollable context.

Web View / PDF | Contacts | Photo Collection
--- | --- | ---
![pdf_example](https://github.com/huri000/assets/blob/master/crown-control/pdf.gif) | ![contacts_example](https://github.com/huri000/assets/blob/master/crown-control/contacts.gif) | ![photos_example](https://github.com/huri000/assets/blob/master/crown-control/photos.gif)

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

To integrate CrownControl into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/cocoapods/specs.git'
platform :ios, '9.0'
use_frameworks!

pod 'CrownControl', '0.1.1'
```

Then, run the following command:

```bash
$ pod install
```

## Usage

### Quick Usage

Using `CrownControl` is really simple.

In your view controller:

1. Define and bind `CrownAttributes` to a scroll view instance, and optionally customize the attributes.
2. Instantiate and bind `CrownIndicatorViewController` instance to the `CrownAttributes` instance.
3. Define the crown view controller constraints.
4. Layout the crown view controller in its parent.

```Swift

var crownViewController: CrownIndicatorViewController!
var scrollView: UIScrollView!

private func setupCrownViewController() {
    var attributes = CrownAttributes(scrollView: scrollView, scrollAxis: .vertical)
    crownViewController = CrownIndicatorViewController(with: attributes)
    
    // Cling the bottom of the crown to the bottom of a view with -50 offset
    let verticalConstraint = CrownAttributes.AxisConstraint(crownEdge: .bottom, anchorView: view, anchorViewEdge: .bottom, offset: -50)
    
    // Cling the trailing edge of the crown to the trailing edge of a view with -50 offset
    let horizontalConstraint = CrownAttributes.AxisConstraint(crownEdge: .trailing, anchorView: tableView, anchorViewEdge: .trailing, offset: -50)
    
    crownViewController.layout(in: self, horizontalConstaint: horizontalConstraint, verticalConstraint: verticalConstraint)
}
```

### Crown Attributes

`CrownAttributes` is the crown appearence descriptor. 
Its nested properties describe the look and feel of the crown.

#### Scroll Axis

The axis of the scroll view is a `.horizontal` or `.vertical`. It must be set during `CrownAttributes` initialization.

####  Anchor Position

The anchor position of the foreground indicator. Indicates where the foreground is initially positioned.

```Swift
attributes.anchorPosition = .left
```

The posssible values are `.left`, `.right`, `.top`, `.bottom`.
The default value is `.top`.

#### Spin Direction

The direction to which the the indicator spins.

Example for setting the spin direction to be counter-clockwise.
```Swift
attributes.spinDirection = .counterClockwise
```

The default value is `clockwise`.

#### User Interaction

Describes the user interaction with the crown.
Currently supported user interaction gestures: tap, double tap, long-press, and force-touch events.

##### Tap Gestures

When a single tap event occurs, scroll forward with the specified offset value: 
```Swift
attributes.userInteraction.singleTap = .scrollsForwardWithOffset(value: 20)
```

When a single tap event occurs, perform a custom action. 
```Swift
attributes.userInteraction.singleTap = .custom(action: {
    /* Do something */
})
```

When a double tap event occurs, scroll to the leading edge of the scroll view. 
```Swift
attributes.userInteraction.doubleTap = .scrollsToLeadingEdge
```

##### Drag and Drop

The crown can be dragged and dropped using force-touch if the force-touch trait is supported by the device hardware. If not, there is a fallback to long-press gesture.
```Swift
attributes.repositionGesture = .prefersForceTouch(attributes: .init())
```

#### Style

The background and foreground surfaces can be customized with various styles.

Example for setting the crown background to a gradient style, and its border to a specific color and width. 
```Swift
attributes.backgroundStyle.content = .gradient(gradient: .init(colors: [.white, .gray], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
attributes.backgroundStyle.border = .value(color: .gray, width: 1)
```

#### Sizes

Describes the size of the crown and relations between the foreground and the background surfaces. 

In the following example, setting `scrollRelation` property to 10 means that 10 full spins of the foreground would make the scroll view offset reach its trailing edge.
```Swift
attributes.sizes.scrollRelation = 10
```

Example for setting the edge size (width and height) of the crown to 60pts, and the foreground edge ratio to 25 precent of that size, which is 15pts.
```Swift
attributes.sizes.backgroundSurfaceDiameter = 60
attributes.sizes.foregroundSurfaceEdgeRatio = 0.25
```

#### Feedback

Feedback descriptor for the foreground when it reaches the anchor point on the crown surface.

The device generates impact-haptic-feedback when the scroll-view offset reaches the leading edge.
The background surface of the crown flashes with color.
```Swift
attributes.feedback.leading.impactHaptic = .light
attributes.feedback.leading.backgroundFlash = .active(color: .white, fadeDuration: 0.3)
```

## Author

Daniel Huri, huri000@gmail.com

## License

CrownControl is available under the MIT license. See the [LICENSE](/LICENSE) file for more info.
