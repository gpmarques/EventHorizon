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
    
    var backgroundImage: SKSpriteNode!
    var buttonShadow: SKSpriteNode!
    var viewController: UIViewController?
    var startGameButton: TriggerButton!
    
    //let lightCamera = SKLightNode()
    
    override func didMove(to view: SKView) {
        //self.backgroundColor = SKColor(colorLiteralRed: 0.05, green: 0.07, blue: 0.17, alpha: 1)
        
        backgroundColor = SKColor.black
        backgroundImage = SKSpriteNode(imageNamed: "gameBackgroundBlur")
        backgroundImage.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        backgroundImage.zPosition = -1
        
        let quad = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        quad.zPosition = 0
        quad.fillColor = UIColor.white
        quad.alpha = 0.1
        
        addChild(backgroundImage)
        addChild(quad)
        
        let descriptionButtom = SKLabelNode(text: "Solar system")
        descriptionButtom.fontSize = 30
        descriptionButtom.fontColor = SKColor.white
        descriptionButtom.position = CGPoint(x: size.width/2, y: 0.12 * size.height)
        descriptionButtom.zPosition = 1
        descriptionButtom.verticalAlignmentMode = .center
        self.addChild(descriptionButtom)
        
        buttonShadow = SKSpriteNode(imageNamed: "solarSystemButtonShadow")
        buttonShadow.position = CGPoint(x: size.width/2 + 50, y: size.height/2 - 20)
        //buttonShadow.position = CGPoint.zero
        
        //addChild(buttonShadow)
        
        
        startGameButton = TriggerButton(iconName: "solarSystemButton2", text: "", view: view, size: CGSize(width: 0.8 * size.width, height: 0.65 * size.height), position: view.center, onButtonPress:{

                
            
        }, onButtonReleased: {
//            let action = SKAction.scale(by: 1.1, duration: 0.1)
//            self.startGameButton.run(SKAction.repeatForever(action))
            self.viewController?.performSegue(withIdentifier: "sistema solar", sender: self)
        })
        startGameButton.zPosition = 1
        
//        startGameButton.lightingBitMask = 1
//        startGameButton.shadowCastBitMask = 1
//        startGameButton.shadowedBitMask = 1
        
        
        
        
        buttonShadow.size = CGSize(width: startGameButton.size.width * 1.1, height: startGameButton.size.height * 1.1)
        addChild(buttonShadow)
        addChild(startGameButton)
        
//        lightCamera.categoryBitMask = 1
//        lightCamera.falloff = 0.5
//        lightCamera.zPosition = 10
//        lightCamera.ambientColor = SKColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.87)
//        lightCamera.lightColor = SKColor(red: 0.8, green: 0.8, blue: 0.4, alpha: 0.8)
//        lightCamera.shadowColor = SKColor(red: 0, green: 0, blue: 0, alpha: 0.8)
//        lightCamera.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
//        addChild(lightCamera)
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
