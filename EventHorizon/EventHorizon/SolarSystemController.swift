//
//  SolarSystemController.swift
//  EventHorizon
//
//  Created by Rodrigo Labronici on 14/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class SolarSystemController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sceneSize = CGSize(width: view.bounds.width, height: view.bounds.size.height)
        let scene =
            SolarSystemScene(size: sceneSize)
        
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


