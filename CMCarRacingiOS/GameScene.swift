//
//  GameScene.swift
//  CMCarRacingClient
//
//  Created by Benny Franco Dennis on 24/04/15.
//  Copyright (c) 2015 Benny Franco. All rights reserved.
//

import SpriteKit
import Foundation

class GameScene: SKScene, AnalogStickProtocol {
    
    var appleNode: SKSpriteNode?
    
    let moveAnalogStick: AnalogStick = AnalogStick()
    let rotateAnalogStick: AnalogStick = AnalogStick()
    
    var carHashCode: Int = -1
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, Don Benny!";
        myLabel.fontSize = 55;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(myLabel)
        
        let bgDiametr: CGFloat = 120
        let thumbDiametr: CGFloat = 60
        let joysticksRadius = bgDiametr / 2
        moveAnalogStick.bgNodeDiametr = bgDiametr
        moveAnalogStick.thumbNodeDiametr = thumbDiametr
        moveAnalogStick.position = CGPointMake(joysticksRadius + 15, joysticksRadius + 15)
        moveAnalogStick.delagate = self
        self.addChild(moveAnalogStick)
        rotateAnalogStick.bgNodeDiametr = bgDiametr
        rotateAnalogStick.thumbNodeDiametr = thumbDiametr
        rotateAnalogStick.position = CGPointMake(CGRectGetMaxX(self.frame) - joysticksRadius - 15, joysticksRadius + 15)
        rotateAnalogStick.delagate = self
        self.addChild(rotateAnalogStick)
        
        // apple
       // appleNode = SKSpriteNode(imageNamed: "apple")
        appleNode = SKSpriteNode(color: UIColor.greenColor(), size: CGSize.zeroSize)
        if let aN = appleNode {
            aN.physicsBody = SKPhysicsBody(texture: aN.texture, size: aN.size)
            aN.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
            aN.physicsBody?.affectedByGravity = false;
            self.insertChild(aN, atIndex: 0)
        }
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        //addOneApple()

       /* socket? = SocketIOClient(socketURL: "192.168.43.1")
        socket?.connect()
        
        socket?.on("connect") {data, ack in
            NSLog ("socket connected")
        }
        
        let jsonObject: [AnyObject] = [
            ["accion": "conecta"],
        ]
        
        let jsonString = self.JSONStringify(jsonObject)
        NSLog(jsonString)
        
        socket?.emit("jsonTest", jsonString)*/
        
        /*let socket = SocketIOClient(socketURL: "192.168.43.1:3389")
        
        
        socket.on("connect") {data, ack in
            NSLog ("socket connected")
        }
        
        socket.on("currentAmount") {data, ack in
            if let cur = data?[0] as? Double {
                socket.emitWithAck("canUpdate", cur)(timeout: 0) {data in
                    socket.emit("update", ["amount": cur + 2.50])
                }
                
                ack?("Got your currentAmount", "dude")
            }
        }
        
        // Connect
        socket.connect()*/
        self.connect();
        
        /*let jsonString = self.JSONStringify(jsonObject)
        NSLog(jsonString)
        
        let data: NSData = jsonString.dataUsingEncoding(NSUTF8StringEncoding)!
        outputStream?.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
        outputStream?.close()*/
}
    
    let jsonObject: [AnyObject] = [
        ["accion": "conecta"],
    ]
    

    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        /*for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }*/
        
        super.touchesBegan(touches, withEvent: event)
        
        if let touch = touches.first as? UITouch {
            
            appleNode?.position = touch.locationInNode(self)
        }
    }
    
    func addOneApple()->Void {
        let appleNode = SKSpriteNode(imageNamed: "apple");
        appleNode.physicsBody = SKPhysicsBody(texture: appleNode.texture, size: appleNode.size)
        appleNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        appleNode.physicsBody?.affectedByGravity = false;
        self.addChild(appleNode)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
 
    }
    
    var inputStream : NSInputStream?
    var outputStream : NSOutputStream?
    
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
        
        // buffer is a UInt8 array containing bytes of the string "Jonathan Yaniv.".
        //outputStream.write(&buffer, maxLength: buffer.count)
        
        //let jsonString = self.JSONStringify(jsonObject)
       
        
        let jsonString = JSON(jsonObject2)
        NSLog(jsonString.description)
        //var writeData = [UInt8]((jsonString).utf8)
       // var writeData = self.convertToJavaUTF8(jsonString)
        let parsingJava :ParsingToJavaUTF = ParsingToJavaUTF()
        
        //let data: NSData = jsonString.dataUsingEncoding(NSUTF8StringEncoding)!
        let data: NSData = parsingJava.convertToJavaUTF8(jsonString.description+"\n")
        outputStream.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
        //outputStream.write(&writeData, maxLength: writeData.length)
        //outputStream.write(&buffer, maxLength: buffer.count)
        
        //outputStream?.close()
        
        
    }
    
    /*- (NSData*) convertToJavaUTF8 : (NSString*) str {
    NSUInteger len = [str lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    Byte buffer[2];
    buffer[0] = (0xff & (len >> 8));
    buffer[1] = (0xff & len);
    NSMutableData *outData = [NSMutableData dataWithCapacity:2];
    [outData appendBytes:buffer length:2];
    [outData appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    return outData;
    }*/
    
    // MARK: AnalogStickProtocol
    func moveAnalogStick(analogStick: AnalogStick, velocity: CGPoint, angularVelocity: Float) {
        if let aN = appleNode {
            if analogStick.isEqual(moveAnalogStick) {
                aN.position = CGPointMake((aN.position.x + (velocity.x * 0.0001)), (aN.position.y + (velocity.y * 0.0001)))
            } else if analogStick.isEqual(rotateAnalogStick) {
                aN.zRotation = CGFloat(angularVelocity/10)
            }
            //var jsonMov = "{\"accion\": \"movimiento\", \"velocidadx\": \"" + aN.position.x.description + "\", \"velocidady\": \"" + aN.position.y.description + "\", \"rotacion\": \"" + aN.zRotation.description + "\", \"tag\": \"" + self.carHashCode.description + "\"}"
            
            var jsonMov = "{\"accion\": \"movimiento\", \"velocidadx\": \"" + (-1*(velocity.x * 0.2)).description + "\", \"velocidady\": \"" + (-1*(velocity.y * 0.2)).description + "\", \"rotacion\": \"" + (angularVelocity*0.2).description + "\", \"tag\": \"" + self.carHashCode.description + "\"}"
           
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

            
            let jsonString = JSON(jsonMov)
            NSLog(jsonString.description)
            
            let parsingJava :ParsingToJavaUTF = ParsingToJavaUTF()
            
            let data: NSData = parsingJava.convertToJavaUTF8(jsonString.description+"\n")
            outputStream.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)

        }
        
    }
    
    let jsonObject2 = "{\"accion\": \"conecta\"}"
    
    func JSONParseDictionary(jsonString: String) -> [String: AnyObject] {
        if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
            if let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil)  as? [String: AnyObject] {
                return dictionary
            }
        }
        return [String: AnyObject]()
    }
    
    func JSONStringify(value: AnyObject, prettyPrinted: Bool = false) -> String {
        var options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : nil
        if NSJSONSerialization.isValidJSONObject(value) {
            if let data = NSJSONSerialization.dataWithJSONObject(value, options: options, error: nil) {
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    return string as String
                }
            }
        }
        return ""
    }
    
}
