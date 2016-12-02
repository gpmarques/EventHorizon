//
//  SolarSystemScene.swift
//  EventHorizon
//
//  Created by Rodrigo Labronici on 14/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import SpriteKit
import GameplayKit
import ReplayKit

class SolarSystemScene: SKScene {
    
    var viewController: UIViewController?
    var startGameButton: TriggerButton!
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor(colorLiteralRed: 0.05, green: 0.07, blue: 0.17, alpha: 1)
        
        let descriptionButtom = SKLabelNode(text: "Solar system")
        descriptionButtom.fontSize = 30
        descriptionButtom.fontColor = SKColor.white
        descriptionButtom.position = CGPoint(x: size.width/2, y: 0.12 * size.height)
        descriptionButtom.zPosition = 1
        descriptionButtom.verticalAlignmentMode = .center
        self.addChild(descriptionButtom)
        

        startGameButton = TriggerButton(iconName: "sistema solar 2", text: "", view: view, size: CGSize(width: 0.8 * size.width, height: 0.65 * size.height), position: view.center, onButtonPress:{
                
            
        }, onButtonReleased: {
//            let action = SKAction.scale(by: 1.1, duration: 0.1)
//            self.startGameButton.run(SKAction.repeatForever(action))
            self.viewController?.performSegue(withIdentifier: "sistema solar", sender: self)
        })
        
        addChild(startGameButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
}
