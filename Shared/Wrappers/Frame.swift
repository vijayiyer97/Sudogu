//
//  Frame.swift
//  Shared
//
//  Created by Vijay Iyer on 7/25/20.
//

import CoreGraphics

// MARK: Frame
/**
 Stores data about a view frame.
 */
struct Frame {
    /// The width of a frame.
    var width: CGFloat = .zero
    /// The height of a frame.
    var height: CGFloat = .zero
    /// The center point of a frame.
    var center: CGPoint = .zero
    /// The offset of the frame.
    var offset: Offset = Offset()
    /// The scale factor for the frame.
    var scale: Scale = Scale()
}

// MARK: Encapsulated Types
extension Frame {
    /**
     Stores data regarding the offset of this `Frame` instance.
     */
    struct Offset {
        /// The maximum allowed offset for the frame.
        var max: CGSize = .zero
        /// The minimum allowed offset for the frame.
        var min: CGSize = .zero
        
        private var _width: CGFloat = 0
        private var _height: CGFloat = 0
    }
    
    struct Scale {
        /// The maximum allowed scale factor for the frame.
        var max: CGFloat = 1
        /// The minimum allowed scale factor for the frame.
        var min: CGFloat = 1
        
        private var _value: CGFloat = 1
    }
}

// MARK: Computed Properties
extension Frame.Offset {
    /// The width of the offset.
    var width: CGFloat {
        get {
            _width
        } set {
            if newValue < min.width {
                _width = min.width
            } else if newValue > max.width {
                _width = max.width
            } else {
                _width = newValue
            }
        }
    }
    /// The height of the offset.
    var height: CGFloat {
        get {
            _height
        } set {
            if newValue < min.height {
                _height = min.height
            } else if newValue > max.height {
                _height = max.height
            } else {
                _height = newValue
            }
        }
    }
}

extension Frame.Scale {
    /// The value representing the scale factor of the frame.
    var value: CGFloat {
        get {
            _value
        } set {
            if newValue < min {
                _value = min
            } else if newValue > max {
                _value = max
            } else {
                _value = newValue
            }
        }
    }
}
