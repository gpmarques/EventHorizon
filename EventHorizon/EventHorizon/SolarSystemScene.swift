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
    
    var viewController: UIViewController?
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor(colorLiteralRed: 0.05, green: 0.07, blue: 0.17, alpha: 1)
        
        let descriptionButtom = SKLabelNode(text: "Solar system")
        descriptionButtom.fontSize = 30
        descriptionButtom.fontColor = SKColor.white
        descriptionButtom.position = CGPoint(x: size.width/2, y: 0.12 * size.height)
        descriptionButtom.zPosition = 1
        descriptionButtom.verticalAlignmentMode = .center
        self.addChild(descriptionButtom)
        
        let startGameButton = CustomButton(iconName: "sistema solar 2", text: "", view: view, size: CGSize(width: 0.8 * size.width, height: 0.65 * size.height), onButtonPress:{
//            let transition: SKTransition = SKTransition.crossFade(withDuration: 1)
//            let nextScene: SKScene = PlanetSelectScene(size: self.size)
//            nextScene.scaleMode = SKSceneScaleMode.resizeFill
//            self.scene?.view?.presentScene(nextScene, transition: transition)
            self.viewController?.performSegue(withIdentifier: "sistema solar", sender: self)
        })
        addChild(startGameButton)
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
