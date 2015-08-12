//
//  MenuScene.swift
//  Epic Island
//
//  Created by Dave Sienk on 8/6/15.
//  Copyright (c) 2015 Quest Realm. All rights reserved.
//

import UIKit
import SpriteKit

class MenuScene: SKScene {
    
    weak var viewController: UIViewController?
  
    override func didMoveToView(view: SKView) {
        
        self.backgroundColor = SKColor(red: 0.15, green:0.15, blue:0.3, alpha: 1.0)
        var button = SKSpriteNode(imageNamed: "nextButton.png")
        button.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        button.name = "nextButton"
        
        self.addChild(button)

    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touch = touches as!  Set<UITouch>
        var location = touch.first!.locationInNode(self)
        var node = self.nodeAtPoint(location)
        
        if (node.name == "nextButton") {
            //if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
                var sceneGame = GameScene(size: self.size)
                sceneGame.scaleMode = SKSceneScaleMode.AspectFill
                //var transition = SKTransition.flipVerticalWithDuration(1.0)
                self.scene!.view?.presentScene(sceneGame)
            //gameTime()
            //}
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func gameTime(){
        //self.viewController?.performSegueWithIdentifier("game", sender: GameViewController())
        let window = UIApplication.sharedApplication().windows[0] as! UIWindow;
        window.rootViewController = GameViewController();
    }
    
}
