//
//  MyUtils.swift
//  FollowTheLeader
//
//  Created by Roshan Sequeira on 8/6/15.
//  Copyright (c) 2015 mcsyon. All rights reserved.
//

import Foundation
import CoreGraphics

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func += (inout left: CGPoint, right: CGPoint) {
    left = left + right
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}