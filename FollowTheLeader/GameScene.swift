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

    // playable area
    let playableRect: CGRect
    
    // optional to help with stopping the zombie at the last location touched
    var lastTouchLocation: CGPoint?
    
    // how many radians to rotate per sec
    let zombieRotateRadiansPerSec: CGFloat = 4.0 * π
    
    override init(size: CGSize) {
        // create zombie sprite
        self.zombie = SKSpriteNode(imageNamed: "zombie1")
        
        // initialize lastUpdateTime and delta time
        lastUpdateTime = 0
        dt = 0
        
        // support aspect ratios from 3:2 (1.33) to 16:9 (1.77). Creating constant for
        // max aspect ratio supported 16:9 (1.77)
        let maxAspectRatio:CGFloat = 16.0/9.0
        
        // with aspect fit, regardless of aspect ratio the playable width will be equal to
        // scene width. For playable height, divide scene with by max aspect ratio
        let playableHeight = size.width / maxAspectRatio
        
        // To center the playable rectangle on the screen, determine the margin on the top and bottom
        // by subtracting the playable height from scene height and dividing the result by 2
        let playableMargin = (size.height - playableHeight) / 2.0
        
        // put it all together and make a centered rectangle with max aspect ratio
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        
        // call initializer on super class
        super.init(size: size)
    }
    
    // A way to declare to the compiler and the built program that 
    // I really don't want to be NSCoding-compatible
    // http://stackoverflow.com/questions/25126295/swift-class-does-not-implement-its-superclasss-required-members
    //
    // Whenever you override the default initializer of a SpriteKit node, you must also 
    // override the required NSCoder initializer. This is used when you are 
    // loading a scene from the scene editor. Since we are not using the scene 
    // editor in this game, we simply add a placeholder implementation that logs 
    // an error for now
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
        //zombie.setScale(2.0)
        
        // add zombie sprite to scene
        addChild(zombie)
        
        // spawn enemy
        spawnEnemy()
        
        // get size of sprite
        let mySize = background.size
        println("Size: \(mySize)")
        
        // DEBUG: drawing a playable rectangle area on the scene to denote playable area.
        debugDrawPlayableArea()
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
        //println("\(dt * 1000) milliseconds since last update")
        
        // To stop the zombie at the touch location, check the distance between the last touch
        // location and the zombie position. If that remaining distance is less than or equal to
        // the amount the zombie will move this frame (zombieMovePointsPerSec * dt), then set
        // the zombie position to the lastTouchedLocation and velocity to zero. Otherwise, move 
        // the zombie (and rotate the sprite as necessary)
        if let lastTouch = lastTouchLocation {
            let diff = lastTouch - zombie.position
            if (diff.length() <= zombieMovePointsPerSec * CGFloat(dt)) {
                zombie.position = lastTouchLocation!
                velocity = CGPointZero
            } else {
                // Iteration 1:
                // move zombie left to right. i.e move the zombie along the x-axis, keep
                // same position along the y-axis
                // zombie.position = CGPoint(x: zombie.position.x + 4, y: zombie.position.y)
        
                // Iteration 2:
                // sprite's position + amount to move = new position of sprite
                // moveSprite(zombie, velocity: CGPoint(x: zombieMovePointsPerSec, y: 0))
        
                // Iteration 3:
                // moving towards touches
                moveSprite(zombie, velocity: velocity)
        
                // rotate zombie smoothly over time so he is facing in the direction he is moving
                //rotateSprite(zombie, direction: velocity)
                rotateSprite(zombie, direction: velocity, rotateRadiansPerSec: zombieRotateRadiansPerSec)
            }
        }
        
        // Iteration 4:
        // bounds check - keep the zombie inside the screen
        boundsCheckZombie()
    }
    
    // Reusable method that takes the sprite to be moved and
    // a velocity vector by which to move it
    // sprite's position + amount to move = new position of sprite
    func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) {

        // using helper functions (*) from MyUtils.swift
        //let amountToMove = CGPoint(x: velocity.x * CGFloat(dt), y: velocity.y * CGFloat(dt))
        let amountToMove = velocity * CGFloat(dt)
        println("Amount to move: \(amountToMove)")
        
        // using helper functions (+=) from MyUtils.swift
        //sprite.position = CGPoint(x: sprite.position.x + amountToMove.x, y: sprite.position.y + amountToMove.y)
        sprite.position += amountToMove
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
        // using helper functions (-) from MyUtils.swift
        //let offset = CGPoint(x: location.x - zombie.position.x, y: location.y - zombie.position.y)
        let offset = location - zombie.position
        
        // 2. find the length of the offset vector
        //    Think of the offset vector as the hypotenuse of a right triangle, where the lengths
        //    of the other two sides of the triangle are defined by x and y components of the vector
        //          
        //
        //    So to find the length of the hypotenuse, you can use the Pythagorean theorem
        //          sqrt(a^2 + b^2) = c
        //    where a = offset.x, b = offset.y, c = length of hypotenuse
        let length = sqrt(Double(offset.x * offset.x + offset.y * offset.y))
        
        // 3. make the offset vector a set/certain length
        //    Currently you have an offset vector where
        //      - the direction of the vector points towards where the zombie should go
        //      - the length of the vector is the length of the line b/w the zombie's current position
        //        and the tap position
        //    What you want is a velocity vector where
        //      - the direction of the vector points towards where the zombie should go
        //      - the length is "zombieMovePointsPerSec" (constant defined above, 480 points per second)
        //    To do the above, we convert the offset vector to a unit vector (vector of length 1). You
        //    do this by dividing the offset vector's x and y components by the offset vector's length.
        //    The process of converting a vector into a unit vector is called "normalizing" a vector
        //    Once you have this unit vector (of length 1), it's easy to multiply it by 
        //    zombieMovePointsPerSec to make it the exact length you want
        //    
        let direction = CGPoint(x: offset.x / CGFloat(length), y: offset.y / CGFloat(length))
        // using helper functions (*) from MyUtils.swift
        //velocity = CGPoint(x: direction.x * zombieMovePointsPerSec, y: direction.y * zombieMovePointsPerSec)
        velocity = direction * zombieMovePointsPerSec
        // So now we have a velocity vector with correct direction and length
        
    }
    
    // hooking up touch events
    func sceneTouched(touchLocation: CGPoint) {
        // updating property lastTouchLocation with the location of the touch whenever 
        // player touches the scene
        lastTouchLocation = touchLocation
        
        // move the zombie towards the touch location
        moveZombieToward(touchLocation)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let touchLocation = touch.locationInNode(self)
        sceneTouched(touchLocation)
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let touchLocation = touch.locationInNode(self)
        sceneTouched(touchLocation)
    }
    
    //
    // Keep the zombie inside the bounds of a playable area
    //
    func boundsCheckZombie() {
        // constants for bottom-left and top-right coordinates of the scene
        let bottomLeft = CGPoint(x: 0, y: CGRectGetMinY(playableRect))
        let topRight = CGPoint(x: size.width, y: CGRectGetMaxY(playableRect))
        
        // check the zombie's position to see if it's beyond or at any of the screen (scene) edges
        // If it is, clamp the position and reverse the appropriate velocty component to make the
        // zombie bounce in the opposite direction
        if zombie.position.x <= bottomLeft.x {
            zombie.position.x = bottomLeft.x
            velocity.x = -velocity.x
        }
        
        if zombie.position.x >= topRight.x {
            zombie.position.x = topRight.x
            velocity.x = -velocity.x
        }
        
        if zombie.position.y <= bottomLeft.y {
            zombie.position.y = bottomLeft.y
            velocity.y = -velocity.y
        }
        
        if zombie.position.y >= topRight.y {
            zombie.position.y = topRight.y
            velocity.y = -velocity.y
        }
    }
    
    
    // Rotate a given sprite (in this case, zombie) by a computed angle
    //
    // We have to find the angle to rotate to get the zombie to face in that direction he will moving
    // Start by thinking of the "direction" vector as the hypotenuse of a right triangle. You want 
    // to find the angle (a) across from the opposite side since the zombie is facing right.
    //         /|
    //        / |
    //       /  | opposite (direction.y)
    //      /)a |
    //      ----
    //      adjacent (direction.x)
    //
    // Since we have the lengths of the opposite and adjacent sides, we can find the angle of rotation
    // using the formula
    //      tan (angle) =  opposite / adjacent. Therefore, angle = arctan(opposite/adjacent)
    // TIP: From Trigonometry, SOH CAH TOA
    // NOTE: The below computation works because the zombie is facing right. If the zombie image 
    // were instead facing toward the top of the screen, you’d have to add an additional
    // rotation to compensate because an angle of 0 points to the right
    func rotateSprite(sprite: SKSpriteNode, direction: CGPoint) {
        
        // using helper functions (CGPoint extension "angle") from MyUtils.swift
        //sprite.zRotation = CGFloat(atan2(Double(direction.y), Double(direction.x)))
        sprite.zRotation = direction.angle
    }
    

    // Rotate a given sprite (in this case, zombie) by a computed angle and smoothly over 
    // time (zombieRotateRadiansPerSec) to face in the new direction
    func rotateSprite(sprite: SKSpriteNode, direction: CGPoint, rotateRadiansPerSec: CGFloat) {
        
        // Use shortestAngleBetween() to find the distance between the current angle (sprite.zRotation) and
        // the target angle (velocty.angle - since velocity/direction is where there zombie should be facing).
        let shortest = shortestAngleBetween(sprite.zRotation, direction.angle)
        
        // Figure out the amount to rotate this frame based on rotateRadiansPerSec and dt. If the 
        // absolute value of shortest is less than (rotateRadiansPerSec * dt) then use that.
        let amountToRotate = min(rotateRadiansPerSec * CGFloat(dt), abs(shortest))
        println("dt : \(dt), rotateRadiansPerSec * CGFloat(dt) :\(rotateRadiansPerSec * CGFloat(dt)), shortest: \(shortest)")
        
        // Add amountToRotate to the sprite’s zRotation — but multiply it by sign() first, so that 
        // you rotate in the correct direction.
        sprite.zRotation += shortest.sign() * amountToRotate
        //sprite.zRotation = amountToRotate
    }
    
    // Spawn enemy
    // Create the zombie sprite and position it at the vertical center of the screen, just out 
    // of view to the right
    func spawnEnemy() {
        // create enemy sprite
        let enemy = SKSpriteNode(imageNamed: "enemy")
        
        // position enemy sprite
        enemy.position = CGPoint(x: size.width + enemy.size.width/2, y: size.height/2)
        
        // add enemy sprite to scene
        addChild(enemy)
        
        // create an action to move the sprite to a specified position over a specified duration (in seconds)
        //let actionMove = SKAction.moveTo(CGPoint(x: -enemy.size.width/2, y: enemy.position.y), duration: 2.0)
        
        // run the action on the SKNode
        //enemy.runAction(actionMove)
        
        // create a new move action that represents the "mid-point" of the action - the bottom middle
        // of the playable rectangle (essentially the top of the "V" to the bottom of the "V")
        //let actionMidMove = SKAction.moveTo(CGPoint(x: size.width/2, y: CGRectGetMinY(playableRect) + enemy.size.height/2), duration:1.0)
        // switching to moveByX Action from moveTo since this Action is reversible
        let actionMidMove = SKAction.moveByX(-size.width/2 - enemy.size.width/2, y: -CGRectGetHeight(playableRect)/2 + enemy.size.height/2, duration:1.0)
        // pause the enemy briefly at the bottom of the screen
        let wait = SKAction.waitForDuration(0.25)
        // create a new move action to move from bottom of the "V", off-screen to the left
        //let actionMove = SKAction.moveTo(CGPoint(x: -enemy.size.width/2, y: enemy.position.y), duration:1.0)
        // switching to moveByX Action from moveTo since this Action is reversible
        let actionMove = SKAction.moveByX(-size.width/2 - enemy.size.width/2, y: CGRectGetHeight(playableRect)/2 - enemy.size.height/2, duration: 1.0)
        // run own block of code - log out a message, in this case
        let logMessage = SKAction.runBlock() {
            println("Reached Bottom")
        }
        
        // create reverse actions
//        let reverseMid = actionMidMove.reversedAction()
//        let reverseMove = actionMove.reversedAction()
        // sequence actions are reversible. commenting out the previous actions
        let halfSequence = SKAction.sequence([actionMidMove, logMessage, wait, actionMove])
        // create the sequence of actions (including the reverse actions)
        let sequence = SKAction.sequence([halfSequence, halfSequence.reversedAction()])
        // run the sequence of actions
        //enemy.runAction(sequence)
        // Repeating the sequence forever
        let repeat = SKAction.repeatActionForever(sequence)
        enemy.runAction(repeat)
    }
    
    // ----------- Handy methods for debugging -----------
    
    // draws a rectangular playable area
    func debugDrawPlayableArea() {
        let shape = SKShapeNode()
        let path = CGPathCreateMutable()
        CGPathAddRect(path, nil, playableRect)
        shape.path = path
        shape.strokeColor = SKColor.blueColor()
        shape.lineWidth = 20.0
        addChild(shape)
    }
    
}
