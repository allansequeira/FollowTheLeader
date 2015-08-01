//
//  GameScene.swift
//  FollowTheLeader
//
//  Created by Roshan Sequeira on 7/22/15.
//  Copyright (c) 2015 mcsyon. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    // constants
    let zombie:SKSpriteNode
    
    // keep track of the last time SpriteKit called update(...)
    var lastUpdateTime: NSTimeInterval
    // keep track of the delta time since the last update(...)
    var dt: NSTimeInterval
    
    // in 1 sec, zombie should move 480 points (1/4 of the scene width)
    let zombieMovePointsPerSec: CGFloat = 480
    
    var velocity = CGPointZero
    
    override init(size: CGSize) {
        // create zombie sprite
        self.zombie = SKSpriteNode(imageNamed: "zombie1")
        
        lastUpdateTime = 0
        dt = 0
        
        super.init(size: size)
    }
    
    // A way to declare to the compiler and the built program that 
    // I really don't want to be NSCoding-compatible
    // http://stackoverflow.com/questions/25126295/swift-class-does-not-implement-its-superclasss-required-members
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported. init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        backgroundColor = SKColor.whiteColor()
        
        // create (background) sprite
        let background = SKSpriteNode(imageNamed: "background1")
        
        // Position the (background) sprite
        // by default SpriteKit positions sprites at (0,0) which in
        // SpriteKit represents bottom left. Note this is different 
        // from the UIKit coordinate system in iOS, where (0,0) represents
        // the top left
        // Positioning the center of the (background) sprite at the center 
        // of the screen
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        // set the (background) zPosition so SpriteKit will draw it before
        // anything else you add to the scene (which will default to a 
        // zPosition of 0
        background.zPosition = -1
            
        // add (background) sprite to scene
        addChild(background)

        // position zombie sprite
        zombie.position = CGPoint(x: 400, y: 400)
        // scale zombie to 2x
        zombie.setScale(2.0)
        
        // add zombie sprite to scene
        addChild(zombie)
        
        // get size of sprite
        let mySize = background.size
        println("Size: \(mySize)")
        
    }
    
    // update(...) is called each frame by SpriteKit.
    override func update(currentTime: NSTimeInterval) {
        // calculate the time since the last call to update() and store that in dt
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        println("\(dt * 1000) milliseconds since last update")
        
        // Iteration 1:
        // move zombie left to right. i.e move the zombie along the x-axis, keep
        // same position along the y-axis
        // zombie.position = CGPoint(x: zombie.position.x + 4, y: zombie.position.y)
        // Iteration 2:
        // sprite's position + amount to move = new position of sprite
        moveSprite(zombie, velocity: CGPoint(x: zombieMovePointsPerSec, y: 0))
        
    }
    
    // Reusable method that takes the sprite to be moved and
    // a velocity vector by which to move it
    // sprite's position + amount to move = new position of sprite
    func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) {
        
        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt), y: velocity.y * CGFloat(dt))
        println("Amount to move: \(amountToMove)")
        
        sprite.position = CGPoint(x: sprite.position.x + amountToMove.x, y: sprite.position.y + amountToMove.y)
    }
    
    // Move the zombie towards the point the player taps and 
    // keep moving even after passing the tap location, until the player taps
    // another location to draw his attention
    func moveZombieToward(location: CGPoint) {
        // 1. figure out the offset between the location of the player's tap and the 
        //    location of the zombie. 
        //    You can get this by subtracting the zombie's position from the tap position
        //          tap position - zombie position = offset
        //    By subtracting these two positions, you get a vector with a direction and a length.
        let offset = CGPoint(x: location.x - zombie.position.x, y: location.y - zombie.position.y)
        
        // 2. find the length of the offset vector
        //    Think of the offset vector as the hypotenuse of a right triangle, where the lengths
        //    of the other two sides of the triangle are defined by x and y components of the vector
        //          
        //
        //    So to find the length of the hypotenuse, you can use the Pythagorean theorem
        //          sqrt(a^2 + b^2) = c
        //    where a = offset.x, b = offset.y, c = length of hypotenuse
        set length = sqrt(Double(offset.x * offset.x + offset.y * offset.y))
        
        
    }
    
}
