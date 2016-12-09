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
    let blackHoleButton: CustomButton
    let planetButton: CustomButton
    
    init(scene: SKScene, entityManager: EntityManager) {
        
        let sceneBackground = SKSpriteNode(imageNamed: "gameBackground")
        sceneBackground.zPosition = -1
        sceneBackground.position = (scene.view?.center)!
        
        let menuBackground = SKShapeNode(rect: CGRect(x: 0, y: 0, width: scene.frame.width - scene.frame.width/2.25, height: scene.frame.width/15))
        menuBackground.fillColor = UIColor.lightGray
        menuBackground.zPosition = 2
        
        let size = CGSize(width: scene.frame.width/18 , height: scene.frame.width/18)
        planetButton = CustomButton(iconName: "venus",
                                        text: "", view: scene.view!, size: size,
                                        position: CGPoint(x: scene.frame.width/3.25, y: scene.frame.height/22.5),
                                        onButtonPress: entityManager.planetIsClicked, onButtonReleased: {})
        planetButton.zPosition = 3
        
        blackHoleButton = CustomButton(iconName: "blackhole",
                                           text: "", view: scene.view!, size: size,
                                           position: CGPoint(x: scene.frame.width/2.25, y: scene.frame.height/22.5),
                                           onButtonPress: entityManager.blackHoleIsClicked, onButtonReleased: {})
        blackHoleButton.zPosition = 3
        
        let resetButton = TriggerButton(iconName: "play",
                       text: "", view: scene.view!, size: size,
                       position: CGPoint(x: 3 * scene.frame.width/5, y: scene.frame.height/22.5),
                       onButtonPress: { }, onButtonReleased: { entityManager.manageStartRestartLevel() })
        resetButton.zPosition = 3
        
        scene.addChild(sceneBackground)
        scene.addChild(menuBackground)
        scene.addChild(planetButton)
        scene.addChild(blackHoleButton)
        scene.addChild(resetButton)
    }
}
