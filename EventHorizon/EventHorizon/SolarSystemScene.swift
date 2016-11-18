//
//  SolarSystemScene.swift
//  EventHorizon
//
//  Created by Rodrigo Labronici on 14/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

//
//  GameScene.swift
//  EventHorizon
//
//  Created by Guilherme Marques on 04/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import SpriteKit
import GameplayKit
import ReplayKit

class SolarSystemScene: SKScene {
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor(colorLiteralRed: 0.15, green: 0.17, blue: 0.48, alpha: 1)
        
        let startGameButton = SolarSystemButton(iconName: "sistemaSolar", text: "", view: view,onButtonPress:{print("start game")})

//        let startGameButtonShadow = SKSpriteNode(imageNamed: "sistemaSolar")
//        startGameButtonShadow.colorBlendFactor = 1;
//        startGameButtonShadow.position = CGPoint(x: size.width/2+10, y: size.height/2-10)
//        startGameButtonShadow.size = CGSize(width: 813, height: 550)
//        startGameButtonShadow.color = SKColor.black
//        startGameButtonShadow.alpha = 0.25
        addChild(startGameButton)
//        addChild(startGameButtonShadow)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(touches.first?.location(in: self.view))
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
