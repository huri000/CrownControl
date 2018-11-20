//
//  CrownAttributes+Style.swift
//  CrownControl
//
//  Created by Daniel Huri on 11/13/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import UIKit

public extension CrownAttributes {
    
    /** Describes the style of the crown */
    public struct Style {
        
        /** The content that populates the background of the view */
        public enum Content {
            
            /** Gradient background style */
            public struct Gradient {
                public var colors: [UIColor]
                public var startPoint: CGPoint
                public var endPoint: CGPoint
                
                public init(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) {
                    self.colors = colors
                    self.startPoint = startPoint
                    self.endPoint = endPoint
                }
            }
            
            /** Visual Effect (Blurred) background style */
            case visualEffect(style: UIBlurEffect.Style)
            
            /** Color background style */
            case color(color: UIColor)
            
            /** Gradient background style */
            case gradient(gradient: Gradient)
            
            /** Image background style */
            case image(image: UIImage)
            
            /** Clear background style */
            case clear
        }
        
        /** The shadow around the crown */
        public enum Shadow {
            
            /** No shadow */
            case none
            
            /** Shadow with value */
            case active(with: Value)
            
            /** The shadow properties */
            public struct Value {
                let radius: CGFloat
                let opacity: Float
                let color: UIColor
                let offset: CGSize
                
                public init(color: UIColor = .black, opacity: Float, radius: CGFloat, offset: CGSize = .zero) {
                    self.color = color
                    self.radius = radius
                    self.offset = offset
                    self.opacity = opacity
                }
            }
        }
        
        /** The border around the crown */
        public enum Border {
            
            /** No border */
            case none
            
            /** Border with color and width */
            case value(color: UIColor, width: CGFloat)
            
            var hasBorder: Bool {
                switch self {
                case .none:
                    return false
                default:
                    return true
                }
            }
            
            var borderValues: (color: UIColor, width: CGFloat)? {
                switch self {
                case .value(color: let color, width: let width):
                    return(color: color, width: width)
                case .none:
                    return nil
                }
            }
        }
        
        /** The content which populates the view */
        public var content = Content.color(color: UIColor(white: 1, alpha: 1))
        
        /** The border around the crown */
        public var border = Border.value(color: UIColor(white: 0.8, alpha: 1), width: 0.5)
        
        /** The shadow around the crown */
        public var shadow = Shadow.active(with: .init(color: .black, opacity: 0.2, radius: 2, offset: .zero))
        
        /** Initializer */
        init() {}
    }
}


