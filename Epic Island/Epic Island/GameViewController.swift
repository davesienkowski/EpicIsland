//
//  GameViewController.swift
//  Epic Island
//
//  Created by Dave Sienk on 4/28/15.
//  Copyright (c) 2015 Quest Realm. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation


class GameViewController: UIViewController {
    
    lazy var backgroundMusic: AVAudioPlayer = {
        let url = NSBundle.mainBundle().URLForResource("Mining by Moonlight", withExtension: "mp3")
        let player = AVAudioPlayer(contentsOfURL: url, error: nil)
        player.numberOfLoops = -1
        return player
        }()
    
    var movesLeft = 0
    var score = 0
    
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    // The scene draws the tiles and cookie sprites, and handles swipes.
    var scene: GameScene!
    
    // The level contains the tiles, the cookies, and most of the gameplay logic.
    // Needs to be ! because it's not set in init() but in viewDidLoad().
    var level: Level!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.dismissViewControllerAnimated(true, completion: nil)
        
        backgroundMusic.play()
        
        //if let scene = GameScene.unarchiveFromFileGame("GameScene") as? GameScene {
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.multipleTouchEnabled = false
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = false
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        // Load the level.
        level = Level(filename: "Level_0")
        scene.level = level
        scene.addTiles()
        scene.swipeHandler = handleSwipe
        
        scene.viewController = self
        
        // Present the scene.
        skView.presentScene(scene)
        //}
        
        // Let's start the game!
            beginGame()
        //}
    }
    
    func beginGame() {
        
        
        movesLeft = level.maximumMoves
        score = 0
        updateLabels()
        level.resetComboMultiplier()
        shuffle()
    }
    
    func shuffle() {
        // Fill up the level with new cookies, and create sprites for them.
        let newGems = level.shuffle()
        scene.addSpritesForGems(newGems)
    }
    
    func beginNextTurn() {
        level.resetComboMultiplier()
        level.detectPossibleSwaps()
        view.userInteractionEnabled = true
        decrementMoves()
    }
    
    func decrementMoves() {
        --movesLeft
        updateLabels()
    }
    
    func handleMatches() {
        let chains = level.removeMatches()
        if chains.count == 0 {
            beginNextTurn()
            return
        }
        scene.animateMatchedGems(chains) {
            for chain in chains {
                self.score += chain.score
            }
            self.updateLabels()
            let columns = self.level.fillHoles()
            self.scene.animateFallingGems(columns) {
                let columns = self.level.topUpGems()
                self.scene.animateNewGems(columns) {
                    self.handleMatches()
                }
            }
        }
    }
    
    func updateLabels() {
        targetLabel.text = String(format: "%ld", level.targetScore)
        movesLabel.text = String(format: "%ld", movesLeft)
        scoreLabel.text = String(format: "%ld", score)
    }
    
    // This is the swipe handler. MyScene invokes this function whenever it
    // detects that the player performs a swipe.
    func handleSwipe(swap: Swap) {
        // While cookies are being matched and new cookies fall down to fill up
        // the holes, we don't want the player to tap on anything.
        view.userInteractionEnabled = false
        
        if level.isPossibleSwap(swap) {
            level.performSwap(swap)
            scene.animateSwap(swap, completion: handleMatches)
        } else {
            scene.animateInvalidSwap(swap) {
                self.view.userInteractionEnabled = true
            }
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
