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


let π = CGFloat(M_PI)

// This function returns the shortest angle between 2 angles. It's not as simple as 
// subtracting the two angles for 2 reasons:
// i) Angles "wrap around" after 360 degrees (2 * M_PI). In other words, 30 degrees
//    and 390 degrees represent the same angle
// ii) Sometimes the shortest way to rotate between 2 angles is to go left, and other 
//     times to go right. For example, if you start at 0 degrees and want to turn 270 
//     degrees, it shorter to turn -90 degrees than 270 degrees. You don't want the
//     zombie to turn the long way around
// So this routine finds the difference between the 2 angles, chops of any amount
// greater than 360 degrees and decides if it's faster to go left or right.
func shortestAngleBetween(angle1: CGFloat, angle2: CGFloat) -> CGFloat {
    let twoπ = π * 2.0
    var angle = (angle2 - angle1) % twoπ
    if (angle >= π) {
        angle = angle - twoπ
    }
    if (angle >= -π) {
        angle = angle + twoπ
    }
    return angle
}

extension CGFloat {

    func sign() -> CGFloat {
        return (self >= 0.0) ? 1.0 : -1.0
    }
}
