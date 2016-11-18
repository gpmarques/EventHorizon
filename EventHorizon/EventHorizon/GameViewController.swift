//
//  GameViewController.swift
//  EventHorizon
//
//  Created by Guilherme Marques on 04/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sceneSize = CGSize(width: view.bounds.size.width, height: view.bounds.size.height)
        let scene =
            GameScene(size: sceneSize)
        
        //let scroll =

        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFit
        skView.presentScene(scene)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
