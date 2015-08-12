//
//  MainmenuViewController.swift
//  Epic Island
//
//  Created by Dave Sienk on 8/6/15.
//  Copyright (c) 2015 Quest Realm. All rights reserved.
//
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! MenuScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class MenuViewController: UIViewController {
    
    var scene: MenuScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.dismissViewControllerAnimated(true, completion: nil)
        
        if let scene = MenuScene.unarchiveFromFile("MainMenu") as? MenuScene {
        
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
        
            scene.size = skView.bounds.size
        
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = false
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
           // scene.viewController = self
            
            skView.presentScene(scene)
        }
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}
