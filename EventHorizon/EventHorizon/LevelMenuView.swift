//
//  LevelMenuView.swift
//  EventHorizon
//
//  Created by Matheus Lourenco Fernandes Soares on 22/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import Foundation
import SpriteKit

class LevelMenuView {
    
    init(scene: SKScene, entityManager: EntityManager) {
        
        let sceneBackground = SKSpriteNode(imageNamed: "gameBackground")
        sceneBackground.zPosition = -1
        sceneBackground.position = (scene.view?.center)!
        
        let menuBackground = SKShapeNode(rect: CGRect(x: 0, y: 0, width: scene.frame.width - scene.frame.width/2.25, height: scene.frame.width/15))
        menuBackground.fillColor = UIColor.lightGray
        menuBackground.zPosition = 2
        
        let size = CGSize(width: scene.frame.width/18 , height: scene.frame.width/18)
        let planetButton = CustomButton(iconName: "jupiter",
                                        text: "", view: scene.view!, size: size,
                                        position: CGPoint(x: scene.frame.width/3.25, y: scene.frame.height/22.5),
                                        onButtonPress: entityManager.planetIsClicked, onButtonReleased: {})
        planetButton.zPosition = 3
        
        let blackHoleButton = CustomButton(iconName: "blackhole",
                                           text: "", view: scene.view!, size: size,
                                           position: CGPoint(x: scene.frame.width/2.25, y: scene.frame.height/22.5),
                                           onButtonPress: entityManager.blackHoleIsClicked, onButtonReleased: {})
        blackHoleButton.zPosition = 3
        
        //let playButton = CustomButton(iconName: String, text: String, view: SKView, position: CGPoint, size: CGSize, onButtonPress: () -> ())
        
        scene.addChild(sceneBackground)
        scene.addChild(menuBackground)
        scene.addChild(planetButton)
        scene.addChild(blackHoleButton)
        
    }
    
}
