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
    
    
    override init(size: CGSize) {
        // create zombie sprite
        self.zombie = SKSpriteNode(imageNamed: "zombie1")
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
        addChild(zombie)
        
        // get size of sprite
        let mySize = background.size
        println("Size: \(mySize)")
        
    }
    
}
