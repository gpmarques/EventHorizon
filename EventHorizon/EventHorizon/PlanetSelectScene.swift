//
//  PlanetSelectScene.swift
//  EventHorizon
//
//  Created by Rodrigo Labronici on 17/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

struct PlanetNode {
    let nome: String
    let position: CGPoint
    let size: CGSize
}

class PlanetSelectScene: SKScene {
    
    var cam: SKCameraNode!
    var planets = [PlanetNode]()
    let universeSize: CGFloat = 3900
    var frameHeightSize: CGFloat!
    var backgroundImage: SKSpriteNode!
    let planetSizePercent: CGFloat = 0.25
    var node: TriggerButton!
    
    override func didMove(to view: SKView) {
        
        frameHeightSize = frame.size.height
        self.size = CGSize(width: frame.size.width, height: universeSize)
        
        backgroundColor = SKColor.black
        backgroundImage = SKSpriteNode(imageNamed: "planetSelectBackground")
        backgroundImage.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        addChild(backgroundImage)
        
        
        //self.view?.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePan)))
        
        planets = [PlanetNode(nome: "mercurio",position: CGPoint(x: 250, y: 200), size: CGSize(width: 0.13 * frame.size.width, height: 0.13 * frame.size.width)),
                   PlanetNode(nome: "venus",position: CGPoint(x: 0.8 * frame.size.width, y: 375), size: CGSize(width: 0.18 * frame.size.width, height: 0.18 * frame.size.width)),
                   PlanetNode(nome: "terra" ,position: CGPoint(x: 500, y: 822), size: CGSize(width: planetSizePercent * frame.size.width, height: planetSizePercent * frame.size.width)),
                   PlanetNode(nome: "marte",position: CGPoint(x: 0.55 * frame.size.width, y: 1300), size: CGSize(width: 0.15 * frame.size.width, height: 0.15 * frame.size.width)),
                   PlanetNode(nome: "jupiter" ,position: CGPoint(x: frame.size.width/2 - 150, y: 1900), size: CGSize(width: 0.40 * frame.size.width, height: 0.40 * frame.size.width)),
                   PlanetNode(nome: "saturno",position: CGPoint(x: 0.6 * frame.size.width, y: 2500), size: CGSize(width: 2.1 * 0.32 * frame.size.width, height: 0.32 * frame.size.width)),
                   PlanetNode(nome: "urano" ,position: CGPoint(x: 260, y: 3000), size: CGSize(width: planetSizePercent * frame.size.width, height: 1.9 * planetSizePercent * frame.size.width)),
                   PlanetNode(nome: "netuno2",position: CGPoint(x: frame.size.width - 0.2 * frame.size.width, y: 3500), size: CGSize(width: planetSizePercent * frame.size.width, height: planetSizePercent * frame.size.width))]
        
        cam = SKCameraNode()
        //position the camera on the gamescene.
        //print(frame.size.height)
        cam.position = CGPoint(x: self.frame.midX, y: frameHeightSize/2)
        self.camera = cam
        self.addChild(cam)
        
        //drawPath()
        drawPlanets()
        
        //print(self.children)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
//        print("position \(positionInScene)")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let previousLocation = touch.previousLocation(in: self)
            let deltaY =  previousLocation.y - location.y
//            print(location.y)
            if (cam.position.y + deltaY) <= (0 + frameHeightSize/2) {
                cam.position.y = 0 + frameHeightSize/2
            } else if (cam.position.y + deltaY) > (universeSize - frameHeightSize/2){
                cam.position.y = universeSize - frameHeightSize/2
            } else {
                cam.position.y += deltaY
            }
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    private func drawPath(){
        let path = CGMutablePath()
        path.move(to: planets[0].position)
        
        for index in 1..<planets.count{
            path.addLine(to: planets[index].position)
            path.addCurve(to: planets[index].position, control1: CGPoint(x: 607.500061035156, y:677.000061035156),
                          control2: CGPoint(x: 823.500061035156, y: 192.500030517578))
        }
        //context?.strokePath()
        let line = SKShapeNode()
        //let bezierLine = UIBezierPath(cgPath: path)
        
        line.path = path
        line.lineWidth = CGFloat(10)
        line.strokeColor = UIColor.white
        line.zPosition = 1
        
        addChild(line)
    }
    
    private func drawPlanets(){
        
        
        planets.forEach({planet in
            node = TriggerButton(iconName: planet.nome, text: "", view: view!, size: planet.size , position: planet.position, onButtonPress: {
//                print(planet.nome)

                
                
            }, onButtonReleased: {
                //let transition: SKTransition = SKTransition.moveIn(with: .down, duration: 1)
                let gameScene = GameScene(size: CGSize(width: self.frame.size.width, height: self.frameHeightSize))
                //gameScene.scaleMode = SKSceneScaleMode.resizeFill
                self.scene?.view?.presentScene(gameScene)
            })
            node.zPosition = 2
            //            node.position = planet.position
            addChild(node)
        })
        //        planets.forEach{addChild(SKSpriteNode(imageNamed: $0))}
    }
//    func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
//        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
//            
//            let translation = gestureRecognizer.translation(in: self.view)
//            // note: 'view' is optional and need to be unwrapped
//            gestureRecognizer.view!.center = CGPoint(x: self.frame.midX, y: gestureRecognizer.view!.center.y + translation.y)
//            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
//        }
//    }
}
