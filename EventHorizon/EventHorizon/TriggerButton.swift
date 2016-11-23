//
//  TriggerButton.swift
//  EventHorizon
//
//  Created by Rodrigo Labronici on 23/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import SpriteKit

class TriggerButton : SKSpriteNode {
    
    let onButtonPress: () -> ()
    let onButtonReleased: () -> ()
    let actionPress: SKAction
    let action : SKAction
    let actionRelease: SKAction
    var actionSequence: SKAction!
    
    init(iconName: String, text: String, view: SKView, size: CGSize, position: CGPoint, onButtonPress: @escaping () -> (), onButtonReleased: @escaping () -> ()) {
        
        self.onButtonPress = onButtonPress
        self.onButtonReleased = onButtonReleased
        actionPress = SKAction.colorize(with: UIColor.black, colorBlendFactor: 0.5, duration: 0.01)
        action = SKAction.scale(by: 0.9, duration: 0.1)
        actionRelease = SKAction.colorize(with: UIColor.white, colorBlendFactor: 0.5, duration: 0.01)
        
        let texture = SKTexture(imageNamed: iconName)
        super.init(texture: texture, color: SKColor.white, size: view.frame.size)
        self.name = iconName
        self.position = position
        self.size = size
        let label = SKLabelNode(fontNamed: "Courier-Bold")
        label.fontSize = 20
        label.fontColor = SKColor.white
        label.position = CGPoint(x: size.width/2, y: -100)
        label.zPosition = 1
        label.verticalAlignmentMode = .center
        label.text = text
        self.addChild(label)
        
        isUserInteractionEnabled = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        onButtonPress()
        //actionSequence = SKAction.sequence([action, action2])
        self.run(actionPress)
        self.run(action)
        //self.run(actionSequence)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //self.run(actionSequence.reversed())
        self.run(action.reversed())
        self.run(actionRelease)
        onButtonReleased()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
