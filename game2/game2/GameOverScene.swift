//
//  GameOverScene.swift
//  game2
//
//  Created by nju on 16/6/4.
//  Copyright © 2016年 NJU. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    var score:Int = 0
    let RestartLabel = SKLabelNode(fontNamed:"Chalkduster")

    override func didMoveToView(view: SKView){
//    func setLabel(){
        //self.backgroundColor = SKColor(red:1.0, green:0, blue:1.0, alpha:1.0)
        
        let GGLabel = SKLabelNode(fontNamed:"Chalkduster")
        GGLabel.text = "Game Over :["
        GGLabel.fontSize = 45
        GGLabel.fontColor = SKColor.redColor()
        GGLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        
        let ScoreLabel = SKLabelNode(fontNamed:"Chalkduster")
        ScoreLabel.text = "Score: \(score)"
        ScoreLabel.fontSize = 30
        ScoreLabel.fontColor = SKColor.redColor()
        ScoreLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 50)
        
        
        RestartLabel.text = "RESTART"
        RestartLabel.fontSize = 30
        RestartLabel.fontColor = SKColor.blueColor()
        RestartLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 100)
        
        self.addChild(GGLabel)
        self.addChild(ScoreLabel)
        self.addChild(RestartLabel)
    }
    
    func directorAction() {
        let actions: [SKAction] = [ SKAction.waitForDuration(3.0), SKAction.runBlock({
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            let gameScene = GameScene(size: self.size)
            self.view!.presentScene(gameScene, transition: reveal)
        }) ]
        let sequence = SKAction.sequence(actions)
        
        self.runAction(sequence)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: UITouch in touches {
            
            let tx :CGFloat = touch.locationInNode(self).x
            let ty :CGFloat = touch.locationInNode(self).y
            print("tx: \(tx) ty: \(ty) midx: \(CGRectGetMidX(self.frame) - 100)")
            if(tx >= CGRectGetMidX(self.frame) - 100 && tx <= CGRectGetMidX(self.frame) + 100 && ty >= CGRectGetMidY(self.frame) - 150 && ty <= CGRectGetMidY(self.frame) - 60){
                if let scene = GameScene(fileNamed:"GameScene") {
                    // Configure the view.
                    let skView = self.view! as SKView
                    skView.showsFPS = true
                    skView.showsNodeCount = true
                    
                    /* Sprite Kit applies additional optimizations to improve rendering performance */
                    skView.ignoresSiblingOrder = true
                    
                    /* Set the scale mode to scale to fit the window */
                    scene.scaleMode = .AspectFill
                    
                    skView.presentScene(scene)
                }
            }
            /*
            let an = calculateAngle(touch.locationInNode(self))
            let action = SKAction.rotateToAngle(an, duration: 0)
            bow.runAction(action)
            arrow.runAction(action)
            arrowposition = arrow.position
            var vec = CGVector(dx: touch.locationInNode(self).x - CGFloat(xBegin), dy: touch.locationInNode(self).y - CGFloat(yBegin))
            let action2 = SKAction.moveBy(vec, duration: 1)
            arrow.runAction(action2, completion: back)
             */
            //let z = arrow.zRotation
            //print("event begin!")
            //print("zrotation = %f", Float(z))
        }
    }
}
