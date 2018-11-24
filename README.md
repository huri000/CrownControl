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
* [Usage](#usage)
  * [Quick Usage](#quick-usage)
  * [Crown Attributes](#crown-attributes)
    * [Scroll Axis](#scroll-axis)
    * [Anchor Position](#anchor-position)
    * [Spin Direction](#spin-direction)
    * [User Interactions](#user-interactions)
    * [Style](#style)
    * [Sizes](#sizes)
    * [Feedback](#feedback)
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

**CrownControl is currently a WIP and will be available soon.**

## Usage

### Quick Usage

Using `CrownControl` is really simple.

1. Define and bind `CrownAttributes` to a scroll view instance (And optionally customize the attributes).
2. Instantiate and bind `CrownIndicatorViewController` instance to the `CrownAttributes` instance.
3. Add `CrownIndicatorViewController` instance to view controllers and views heirarchy.
4. Layout `CrownIndicatorViewController` horizontally and vertically in its superview.

```Swift

var crownViewController: CrownIndicatorViewController!
var scrollView: UIScrollView!

private func setupCrownViewController() {
    let attributes = CrownAttributes(using: scrollView)
    crownViewController = CrownIndicatorViewController(with: attributes)
    addChild(crownViewController)
    view.addSubview(crownViewController.view)
    crownViewController.layoutVertically(.bottom, to: .bottom, of: webView, offset: -35)
    crownViewController.layoutHorizontally(.trailing, to: .trailing, of: view, offset: -50)
}
```

### Crown Attributes

`CrownAttributes` is the crown appearence descriptor. All of its nested properties describes the look and feel of the crown.

#### Scroll Axis

The axis of the scroll view can be horizontal or vertical.

Example for setting the scroll axis to vertical:
```Swift
attributes.scrollAxis = .vertical
```

The default value is `.vertical`.

####  Anchor Position

The anchor position of the foreground indicator. Indicates where the it initially points.

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

#### User Interactions

Describes the user interactions with the crown.
Currently supported user interactions: tap, double tap, long-press, and force-touch events.

##### Tap Gestures

When a single tap event occurs, scroll forward with the specified offset value: 
```Swift
attributes.userInteractions.singleTap = .scrollsForwardWithOffset(value: 20)
```

When a single tap event occurs, perform a custom action. 
```Swift
attributes.userInteractions.singleTap = .custom(action: {
    /* Do something */
})
```

When a double tap event occurs, scroll to the leading edge of the scroll view. 
```Swift
attributes.userInteractions.doubleTap = .scrollsToLeadingEdge
```

##### Drag and Drop

The crown can be dragged and dropped using force-touch if the force-touch trait is supported by the device hardware. If not, there is a fallback to long-press gesture.
```Swift
attributes.placementGesture = .prefersForceTouch(attributes: .init())
```

#### Style

The background and foreground surfaces can be customized with various styles.

Example for setting the crown background to gradient style, and its border to a specific color and width. 
```Swift
attributes.backgroundStyle.content = .gradient(gradient: .init(colors: [.white, .gray], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
attributes.backgroundStyle.border = .value(color: .gray, width: 1)
```

#### Sizes

Describes the size of the crown and relations between the foreground and the background surfaces. 

In the following example, setting `scrollRelation` property to 10, means that 10 full spins of the foreground would make the scroll view offset reach its trailing edge.
```Swift
attributes.sizes.scrollRelation = 10
```

Example for setting the edge size (width and height) of the crown to 60pts, and the foreground edge ratio to 25 precent of that size, which is 15pts.
```Swift
attributes.sizes.backgroundSurfaceDiameter = 60
attributes.sizes.foregroundSurfaceEdgeRatio = 0.25
```

#### Feedback

Feedback descriptor for the foreground reaching the anchor point on the crown surface.

The device generates impact-haptic-feedback when the scroll-view offset reaches the leading edge.
The background surface of the crown flashes with color.
```Swift
attributes.feedback.leading.impactHaptic = .light
attributes.feedback.leading.backgroundFlash = .active(color: .white, fadeDuration: 0.3)
```

## Author

Daniel Huri, huri000@gmail.com

## License

CrownControl is available under the MIT license. See the LICENSE file for more info.
