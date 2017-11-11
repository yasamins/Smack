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
                    completion(true)
                }
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
            
        }
        
    }
    //after user log out the channels will be  removed
    func clearChannels() {
        channels.removeAll()
    }
    
}
