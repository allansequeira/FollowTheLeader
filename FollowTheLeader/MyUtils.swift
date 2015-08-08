//
//  MyUtils.swift
//  FollowTheLeader
//
//  Created by Roshan Sequeira on 8/6/15.
//  Copyright (c) 2015 mcsyon. All rights reserved.
//

import Foundation
import CoreGraphics

/* Utility override operators for addition, subtraction, multiplication, and division on CGPoint 
   For example, you will be able to add points like this:
        let testPoint1 = CGPoint(x: 100, y: 100) 
        let testPoint2 = CGPoint(x: 50, y: 50) 
        let testPoint3 = testPoint1 + testPoint2

    And you will be able to multiple/divide points by scalar values as:
        let testPoint4 = testPoint1 * 2
        let testPoint5 = testPoint1 / 10
*/

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func += (inout left: CGPoint, right: CGPoint) {
    left = left + right
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func -= (inout left: CGPoint, right: CGPoint) {
    left = left - right
}

func * (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x * right.x, y: left.y * right.y)
}

func *= (inout left: CGPoint, right: CGPoint) {
    left = left * right
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func *= (inout point: CGPoint, scalar: CGFloat) {
    point = point * scalar
}

func / (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x / right.x, y: left.y / right.y)
}

func /= (inout left: CGPoint, right: CGPoint) {
    left = left / right
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

func /= (inout point: CGPoint, scalar: CGFloat) {
    point = point / scalar
}

// class extension on CGPoint with a few helper methods

// The #if/#endif block is true when the app is running on 32-bit architecture. 
// In this case, CGFloat is the same size as Float, so this code makes versions 
// of atan2 and sqrt that accept CGFloat/Float values (rather than the default 
// of Double), allowing you to use atan2 and sqrt with CGFloats, regardless of
// the device’s architecture.
#if !(arch(x86_64) || arch(arm64))
    func atan2(y: CGFloat, x: CGFloat) -> CGFloat {
        return CGFloat(atan2f(Float(y), Float(x)))
    }

    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
    
#endif

// the class extension adds some handy methods to get the length of the point, 
// return a normalized version of the point (i.e., length 1) and get the angle
// of the point.
extension CGPoint {
    
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
    
    var angle: CGFloat {
        return atan2(y, x)
    }
}