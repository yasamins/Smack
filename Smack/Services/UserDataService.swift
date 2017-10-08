//
//  UserDataService.swift
//  Smack
//
//  Created by Yasamin Sa on 08/10/2017.
//  Copyright © 2017 Yasamin Sa. All rights reserved.
//

import Foundation

class UserDataService {
    
    static let instance = UserDataService()
//what we gonna receive as a response like the example in postman
    public private(set) var id = ""
    public private(set) var avatarColor = ""
    public private(set) var avatarName = ""
    public private(set) var email = ""
    public private(set) var name = ""
    
    func setUserData(id: String, color: String,  avatarName: String,
                     email: String, name: String) {
        
        self.id = id
        self.avatarColor = color
        self.avatarName = avatarName
        self.email = email
        self.name = name
    }
    
    func setAvatarName(avatarName: String) {
        self.avatarName = avatarName
    }

}
