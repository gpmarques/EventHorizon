//
//  PlanetSelectController.swift
//  EventHorizon
//
//  Created by Rodrigo Labronici on 17/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class PlanetSelectController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sceneSize = CGSize(width: view.bounds.width, height: view.bounds.size.height)
//        print("VC size: \(sceneSize)")
        let scene =
            PlanetSelectScene(size: sceneSize)
        
        let skView = self.view as! SKView
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
