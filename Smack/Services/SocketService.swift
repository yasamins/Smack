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
        socket.emit("newChannel", channelName, channelDescription)
        completion(true)
        
    }
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
    
    func addMessage(messageBody: String, userId: String, channelId: String, completion: @escaping
        CompletionHandler) {
        let user = UserDataService.instance
        socket.emit("newMessage", messageBody, userId, channelId, user.name, user.avatarName)
        completion(true)
        
    }
    //receive that array of data that we have above
    func getChatMessage(completion: @escaping CompletionHandler) {
        //check if the channelId of the incoming messages matches the channelId that we are in
        //if yes we get the array and parse it
        socket.on("messageCreated") { (dataArray, ack) in
            guard let msgBody = dataArray[0] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            guard let userName = dataArray[3] as? String else { return }
            guard let userAvatar = dataArray[4] as? String else { return }
            guard let id = dataArray[6] as? String else { return }
            guard let timeStamp = dataArray[7] as? String else { return }
            
            if channelId == MessageService.instance.selectedChannel?.id &&
                AuthService.instance.isLoggedIn {
                
                let newMessage = Message(message: msgBody, userName: userName, channelId: channelId,
                                         userAvatar: userAvatar, id: id, timestamp: timeStamp)
                //add to the asrray of messages and in chatCV we reload the table
                MessageService.instance.messages.append(newMessage)
                completion(true)
            } else {
                completion(false)
            }


        }
    }
}
