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
        let planetButton = CustomButton(iconName: "Jupiter",
                                        text: "", view: scene.view!,
                                        position: CGPoint(x: scene.frame.width/3.25, y: scene.frame.height/22.5),
                                        size: size, onButtonPress: entityManager.planetIsClicked)
        planetButton.zPosition = 3
        
        let blackHoleButton = CustomButton(iconName: "blackhole",
                                           text: "", view: scene.view!,
                                           position: CGPoint(x: scene.frame.width/2.25, y: scene.frame.height/22.5),
                                           size: size, onButtonPress: entityManager.blackHoleIsClicked)
        blackHoleButton.zPosition = 3
        
        //let playButton = CustomButton(iconName: <#T##String#>, text: <#T##String#>, view: <#T##SKView#>, position: <#T##CGPoint#>, size: <#T##CGSize#>, onButtonPress: <#T##() -> ()#>)
        
        scene.addChild(sceneBackground)
        scene.addChild(menuBackground)
        scene.addChild(planetButton)
        scene.addChild(blackHoleButton)
        
    }
    
    func nada() { }
    
}
