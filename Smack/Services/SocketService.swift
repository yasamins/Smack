//
//  SocketService.swift
//  Smack
//
//  Created by Yasamin Sa on 09/11/2017.
//  Copyright © 2017 Yasamin Sa. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {
    //instantiate it
    static let instance = SocketService()
    
    override init() {
        super.init()
    }
    //create the socket
    var socket : SocketIOClient = SocketIOClient(socketURL: URL(string: BASE_URL)!)
    
    //establish the connection between our app and the server
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler) {
        //emit from app to the api with these info (name, description)
        socket.emitWithAck("newChannel", channelName, channelDescription)
        completion(true)
        
        //receive the info from the api after creating the channel and save it in db and send us back name, desc, id, api emits
        func getChannel(completion: @escaping CompletionHandler) {
            socket.on("channelCreated") { (dataArray, ack) in
                guard let channelName = dataArray[0] as? String else { return }
                guard let channelDesc = dataArray[1] as? String else { return }
                guard let channelId = dataArray[2] as? String else { return }
                
                
                //new channel object
                let newChannel = Channel(channelTitle: channelName, channelDescription: channelDesc
                    , id: channelId)
                MessageService.instance.channels.append(newChannel)
                completion(true)

                
                
                
                }
            
        }
    }
    
    
    
    
    
}
