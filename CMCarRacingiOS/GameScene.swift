//
//  GameScene.swift
//  CMCarRacingClient
//
//  Created by Benny Franco Dennis on 24/04/15.
//  Copyright (c) 2015 Benny Franco. All rights reserved.
//

import SpriteKit
import Foundation

public var hashCar :String?

class GameScene: SKScene, AnalogStickProtocol {
    
    var appleNode: SKSpriteNode?
    
    let moveAnalogStick: AnalogStick = AnalogStick()
    let rotateAnalogStick: AnalogStick = AnalogStick()

    var inputStream : NSInputStream?
    var outputStream : NSOutputStream?
    
    let jsonObject2 = "{\"accion\": \"conecta\"}"
    
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, Don Benny!";
        myLabel.fontSize = 55;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(myLabel)
        
        let bgDiametr: CGFloat = 240
        let thumbDiametr: CGFloat = 120
        let joysticksRadius = bgDiametr / 2
        moveAnalogStick.bgNodeDiametr = bgDiametr
        moveAnalogStick.thumbNodeDiametr = thumbDiametr
        moveAnalogStick.position = CGPointMake(joysticksRadius + 30, joysticksRadius + 30)
        moveAnalogStick.delagate = self
        self.addChild(moveAnalogStick)
        
        self.connect();

    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        super.touchesBegan(touches, withEvent: event)
    }
    
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
 
    }
        
    func connect() {
        let addr = "192.168.43.1"
        let port = 3389
        
        var host : String = addr
        var inp :NSInputStream?
        var out :NSOutputStream?
        
        NSStream.getStreamsToHostWithName(host, port: port, inputStream: &inp, outputStream: &out)
        
        let inputStream = inp!
        let outputStream = out!
        inputStream.open()
        outputStream.open()
        
        var readByte :UInt8 = 0
        while inputStream.hasBytesAvailable {
            inputStream.read(&readByte, maxLength: 1)
        }
        
        let jsonString = JSON(jsonObject2)
        NSLog(jsonString.description)

        let parsingJava :ParsingToJavaUTF = ParsingToJavaUTF()
        
        let data: NSData = parsingJava.convertToJavaUTF8(jsonString.description+"\n")
        outputStream.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
        
        hashCar = self.hashCode();
    }
    
    
    // MARK: AnalogStickProtocol
    func moveAnalogStick(analogStick: AnalogStick, velocity: CGPoint, angularVelocity: Float) {
           
            let addr = "192.168.43.1"
            let port = 3389
            
            var host : String = addr
            var inp :NSInputStream?
            var out :NSOutputStream?
            
            NSStream.getStreamsToHostWithName(host, port: port, inputStream: &inp, outputStream: &out)
            
            let inputStream = inp!
            let outputStream = out!
            inputStream.open()
            outputStream.open()
        
        
        var jsonMov = "{\"accion\": \"movimiento\", \"velocidadx\": \"" + (-1*(velocity.x * 0.09)).description + "\", \"velocidady\": \"" + (-1*(velocity.y * 0.09)).description + "\", \"rotacion\": \"" + (angularVelocity).description + "\", \"tag\": \"" + hashCar! + "\"}"
            
            var readByte :UInt8 = 0
            while inputStream.hasBytesAvailable {
                inputStream.read(&readByte, maxLength: 1)
            }

            
            let jsonString = JSON(jsonMov)
            NSLog(jsonString.description)
            
            let parsingJava :ParsingToJavaUTF = ParsingToJavaUTF()
            
            let data: NSData = parsingJava.convertToJavaUTF8(jsonString.description+"\n")
            outputStream.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)

        }
    
        func hashCode ()-> String{
            var hcd :UInt32 = arc4random()
            return hcd.description
        }
    }
