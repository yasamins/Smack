//
//  MessageService.swift
//  Smack
//
//  Created by Yasamin Sa on 05/11/2017.
//  Copyright © 2017 Yasamin Sa. All rights reserved.
//
//we gonna have a bunch of channels here + messages on those channels
import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    
    static let instance = MessageService()
    
    var channels = [Channel]()
    var messages = [Message]()
    var selectedChannel : Channel?
    
    //we gonna make the function that is going to have our web request and bring back all our channels for us
    func findAllChannel(completion: @escaping CompletionHandler) {
        
        let header = [
            "Authorization":"Bearer \(AuthService.instance.authToken)",
            "Content-Type": "application/json; charset=utf-8"
            
        ]
        
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.result.error == nil {
                //if successful we gonna parse the json ==> we want to turn our json into an array of object cus in postman it was an array of channels
                guard let data = response.data else { return }
                if let json = JSON(data: data).array {
                    for item in json {
                        let name  = item["name"].stringValue
                        let channelDescription = item["description"].stringValue
                        let id = item["_id"].stringValue
                        //we these properties now we can initialize a new channel obj
                        let channel = Channel(channelTitle: name, channelDescription: channelDescription
                            , id: id)
                        //now we gonna add our new channel to our channels array
                        self.channels.append(channel)
                    }
                    NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                    completion(true)
                }
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
            
        }
        
    }
    //retrieve all messages for a channel
    func findAllMessssagesForChannel(channelId: String, completion: @escaping CompletionHandler) {
        
        let header = [
            "Authorization":"Bearer \(AuthService.instance.authToken)",
            "Content-Type": "application/json; charset=utf-8"
            
        ]
        Alamofire.request("\(URL_GET_MESSAGES)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.result.error == nil {
                self.clearMessages()
                //parsing
                guard let data = response.data else { return }
                if let json = JSON(data: data).array {
                    //each message is one item
                    for item in json {
                        let messageBody = item["messageBody"].stringValue
                        let channelId = item["channelId"].stringValue
                        let id = item["_id"].stringValue
                        let userName = item["userName"].stringValue
                        let userAvatar = item["userAvatar"].stringValue
                        let timestamp = item["timeStamp"].stringValue
                        
                        //create a new message object
                        let message = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, id: id, timestamp: timestamp)
                        //append it to the array
                        self.messages.append(message)
                    }
                    print(self.messages)
                    completion(true)

                }
                
            } else {
                debugPrint(response.result.error as Any)
                completion(false)
            }
        }
    }
    //when we switch to another channel we clear the messages and load the messages f that channel
    func clearMessages(){
        messages.removeAll()
    }
    
    //after user log out the channels will be  removed
    func clearChannels() {
        channels.removeAll()
    }
    
}
