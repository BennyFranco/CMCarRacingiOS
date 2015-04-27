//
//  AppDelegate.swift
//  CMCarRacingClient
//
//  Created by Benny Franco Dennis on 24/04/15.
//  Copyright (c) 2015 Benny Franco. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        let addr = "192.168.43.1"
        let port = 3389
        
        let jsonObject2 = "{\"accion\": \"desconexion\", \"tag\": \""+hashCar!+"\"}"
        
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
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        let addr = "192.168.43.1"
        let port = 3389
        
        let jsonObject2 = "{\"accion\": \"desconexion\", \"tag\": \""+hashCar!+"\"}"
        
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
        
    }


}

