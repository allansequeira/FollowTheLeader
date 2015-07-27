//
//  GameScene.swift
//  FollowTheLeader
//
//  Created by Roshan Sequeira on 7/22/15.
//  Copyright (c) 2015 mcsyon. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        backgroundColor = SKColor.whiteColor();
        
        // create (background) sprite
        let background = SKSpriteNode(imageNamed: "background1");
        
        // Position the sprite
        // by default SpriteKit positions sprites at (0,0) which in
        // SpriteKit represents bottom left. Note this is different 
        // from the UIKit coordinate system in iOS, where (0,0) represents
        // the top left
        // Positioning the center of the (background) sprite at the center of the screen
        background.position = CGPoint(x: size.width / 2, y: size.height / 2);
        
        // add (background) sprite to scene
        addChild(background);
        
    }
    
}
