//
//  PlanetSelectScene.swift
//  EventHorizon
//
//  Created by Rodrigo Labronici on 17/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import SpriteKit
import GameplayKit



class PlanetSelectScene: SKScene {
    
//    let moveableNode = SKNode()
    var cam: SKCameraNode!
    
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.green
        
        let top = SKLabelNode(text: "top")
        top.position = CGPoint(x: frame.size.width/2, y: frame.size.height-100)
        top.fontColor = UIColor.white
        top.fontSize = 50
        let bottom = SKLabelNode(text: "bottom")
        bottom.position = CGPoint(x: frame.size.width/2, y: 100)
        bottom.fontColor = UIColor.white
        bottom.fontSize = 50
        print("top \(top.position) bottom \(bottom.position)")
        addChild(top)
        addChild(bottom)
        
        cam = SKCameraNode()
        //cam.xScale = 1
        //cam.yScale = 0.0001
        
        
        self.camera = cam //set the scene's camera to reference cam
        self.addChild(cam) //make the cam a childElement of the scene itself.

        //position the camera on the gamescene.
        
        cam.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        print("position \(positionInScene)")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let previousLocation = touch.previousLocation(in: self)
            let deltaY = location.y - previousLocation.y
            cam.position.y += (deltaY * (-1))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    func drawPlanets(){
        
    }

}
