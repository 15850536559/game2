//
//  GameScene.swift
//  game2
//
//  Created by nju on 16/6/3.
//  Copyright (c) 2016年 NJU. All rights reserved.
//

import SpriteKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    var bow = SKSpriteNode(imageNamed: "bow.png")
    var arrow = SKSpriteNode(imageNamed: "arrow.png")
    var scorelabel = SKLabelNode(fontNamed:"Chalkduster")
    var height = 4000
    var length = 600
    var xBegin = 200
    var yBegin = 200
    var xMid = 800
    
    var arrowposition = CGPoint(x:200, y:200)
    //var rotateP: CGPoint = CGPoint(x: 36,y: 236)
    //var touchP: CGPoint = CGPoint(x:0, y:0)
    
    let planeTexture = SKTexture(imageNamed: "Spaceship")
    let ArrowCategory:UInt32=1<<1
    let PlaneCategory:UInt32=1<<2
    var planenum = 6
    var lastTime:CFTimeInterval = 0
    let remove=SKAction.removeFromParent()
    
    var arrowrunbit: Bool = false
    var score:Int = 0
    var totalscore:Int = 0
    var gameover:Bool = false
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        height = Int(CGRectGetMaxY(self.frame))
        length = Int(CGRectGetMaxX(self.frame))
        
        scorelabel.fontSize = 20
        scorelabel.position = CGPoint(x: length - 200, y: height - 200)
        scorelabel.text = "SCORE: \(totalscore)"
        self.addChild(scorelabel)
        
        srand48(Int(time(nil)))
        self.physicsWorld.contactDelegate=self
        self.physicsWorld.gravity=CGVectorMake(0, -2)

        bow.anchorPoint = CGPoint(x:0, y:0)
        bow.setScale(2.0)
        bow.position = CGPoint(x: xBegin, y:yBegin)
        self.addChild(bow)
        
        arrow.anchorPoint = CGPoint(x:0, y:0)
        arrow.setScale(1.5)
        arrow.position = CGPoint(x:xBegin, y:yBegin)
        arrow.physicsBody = SKPhysicsBody(rectangleOfSize: arrow.size)
        arrow.physicsBody?.dynamic = false
        arrow.physicsBody?.categoryBitMask = ArrowCategory
        arrow.physicsBody?.collisionBitMask = 0
        arrow.physicsBody?.contactTestBitMask = PlaneCategory
        self.addChild(arrow)
        
        //self.addChild(myLabel)
    }
    
    func didBeginContact(contact: SKPhysicsContact){
        let a=contact.bodyA.categoryBitMask
        let b=contact.bodyB.categoryBitMask
        var body=contact.bodyA
        if a < b {
            body=contact.bodyB
        }
        if a | b == ArrowCategory | PlaneCategory{
            print("eneny die")
            score += 1
            body.node?.removeFromParent()
        }
    }
	
	func addscore(hit: Int) -> Int{
	    var total:Int = (hit + 1) * hit / 20
		if hit == planenum {
		    total += hit
		}
		return total
	}
    
    func freshScore(){
        totalscore += score
        score = 0
        scorelabel.text = "SCORE: \(totalscore)"
    }
    
    func calculateAngle(tpoint: CGPoint) -> CGFloat{
        let x:Int = Int(tpoint.x)
        let y:Int = Int(tpoint.y)
       //print("x: \(x) y: \(y)")
   /*     if(x <= xBegin){
            return CGFloat(45.0/180.0 * M_PI)
        }
        if(y <= yBegin){
            return CGFloat(-45.0/180.0 * M_PI)
        }
        if(x >= xMid){
            return 0
        }*/
        let k:Float = (Float(y) - Float(yBegin))/(Float(x)-Float(xBegin))
        return CGFloat(atan(k) - Float(45.0/180.0 * M_PI))
    }
    func back(){
        arrow.position = arrowposition
        arrowrunbit = false
        if(score == 0){
            if let scene = GameOverScene(fileNamed: "overScene"){
                // Configure the view.
                let skView = self.view! as SKView
                skView.showsFPS = true
                skView.showsNodeCount = true
                scene.score = totalscore
                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true
            
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .AspectFill
                
                skView.presentScene(scene)
            }
        }
        else{
            freshScore()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: UITouch in touches {
            if(Int(touch.locationInNode(self).x) <= xBegin){
                continue
            }
            if(Int(touch.locationInNode(self).y) <= yBegin){
                continue
            }
                if(arrowrunbit == false){
                    let an = calculateAngle(touch.locationInNode(self))
                    //print("angle: \(an)")
                    let action = SKAction.rotateToAngle(an, duration: 0)
                    bow.runAction(action)
                    arrow.runAction(action)
                    arrowposition = arrow.position
                    let dx: Double = Double(touch.locationInNode(self).x - CGFloat(xBegin))
                    let dy: Double = Double(touch.locationInNode(self).y - CGFloat(yBegin))
                    let timex = Double(length - xBegin) / dx
                    let timey = Double(height - yBegin) / dy
                    let times = timex > timey ? timey : timex
                    //let dis: Double = sqrt(dx*dx + dy*dy)
                    //let times: Double = pow(sqrt(Double(height * height + length * length)) / dis, 2) / 2
                    //let times: Double = pow(Double(length) / dis, 2)
                    let vec = CGVector(dx: dx * times, dy: dy * times)
                    let action2 = SKAction.moveBy(vec, duration: 1.5)
                    arrow.runAction(action2, completion: back)
                    arrowrunbit = true
                }
    
            //gameover = true
            //let z = arrow.zRotation
            //print("event begin!")
            //print("zrotation = %f", Float(z))
        }
        /*
     let location = touch.locationInNode(self)
     
     let sprite = SKSpriteNode(imageNamed:"Spaceship")
     
     sprite.xScale = 0.5
     sprite.yScale = 0.5
     sprite.position = location
     
     let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
     
     sprite.runAction(SKAction.repeatActionForever(action))
     
     self.addChild(sprite)
        */
    }
    /*
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        for touch: AnyObject in touches {
            let t:UITouch = touch as! UITouch
            print(t.locationInView(self.view))
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        //两点触摸时，计算两点间的距离
        if touches.count == 2{
            //获取触摸点
            let first = (touches as NSSet).allObjects[0] as! UITouch
            let second = (touches as NSSet).allObjects[1] as! UITouch
            //获取触摸点坐标
            let firstPoint = first.locationInView(self.view)
            let secondPoint = second.locationInView(self.view)
            //计算两点间的距离
            let deltaX = secondPoint.x - firstPoint.x
            let deltaY = secondPoint.y - firstPoint.y
            let initialDistance = sqrt(deltaX*deltaX + deltaY*deltaY)
            print("两点间距离：\(initialDistance)")
        }
        print("event end!")
    }
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?)
    {
        print("event canceled!")
    }
   */
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if(currentTime>=lastTime+6){
		    planenum=Int(arc4random()%4)+3
            for i in 0..<planenum{
                createplane(i)
            }
            lastTime=currentTime
        }
    }
    
    func createplane(no:Int){
        let plane=SKSpriteNode(texture: planeTexture)
        plane.setScale(0.1)
        plane.position=CGPointMake(size.width*CGFloat((drand48()+Double(no))*0.6/Double(planenum)+0.4), 1)
        plane.physicsBody=SKPhysicsBody(rectangleOfSize: plane.size)
        plane.physicsBody?.categoryBitMask=PlaneCategory
        plane.physicsBody?.collisionBitMask=0
        plane.physicsBody?.contactTestBitMask=ArrowCategory
        var rdm=CGFloat(arc4random()%200+350)
        plane.physicsBody?.velocity=CGVectorMake(0, rdm)
        self.addChild(plane)
    }
 
}
