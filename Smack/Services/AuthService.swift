//this file will handel all of our login, create users, register users functions
import Foundation
import Alamofire
import SwiftyJSON

//this class is a singleton (accessed globally, one instance of it at a time )
class AuthService {
    static let instance = AuthService()
    
    
    
    //we gonna use userdefaults(an interface to user defaults database) for some data that will be persisted after user close the app. there are 3 of them which we have below.
    let defaults = UserDefaults.standard
    //we gonna look into the userdefaults and see if this value exist
    var isLoggedIn : Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    
    var authToken: String {
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail: String {
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
    }
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
        }
    func registerUser(email: String, password: String, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        //headers are attached to HTTP req where you can specify the type,api keys, etc (like header in postman)
        let header = [
            "Content-Type": "application/json; charset=utf-8"
        ]
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body,
                          encoding: JSONEncoding.default, headers: header).responseString
            {(response) in
                if response.result.error == nil {
                    
                    completion(true)
                    
                }
                else {
                    completion(false)
                    debugPrint(response.result.error as Any)
                }
            }
        
    }
    
    
    func loginUser(email: String, password: String, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        //headers are attached to HTTP req where you can specify the type,api keys, etc (like header in postman)
        let header = [
            "Content-Type": "application/json; charset=utf-8"
        ]
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON {
            (response) in
            
            if response.result.error == nil {
                
                //we need data cus swiftyjson creates a json object out of the json data
                guard let data = response.data else {return}
                let json = JSON(data: data)
                //this part is similar to the response we get in postman
                //unwrap the value
                self.userEmail = json["user"].stringValue
                self.authToken = json["token"].stringValue
                
                self.isLoggedIn = true
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
    func createUser(name: String, email: String, avatarName: String,
                    avatarColor: String, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        
        //based on postman  this is what we have in the body for create user
        let body: [String: Any] = [
            "name": name,
            "email": lowerCaseEmail,
            "avatarName": avatarName,
            "avatarColor": avatarColor
        ]

        
        let header = [
            "Authorization":"Bearer \(AuthService.instance.authToken)",
            "Content-Type": "application/json; charset=utf-8"

        ]
        Alamofire.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default,
                          headers: header).responseJSON { (response) in
                            
                            if response.result.error == nil {
                                guard let data = response.data else {return}
                                let json = JSON(data: data)
                                let id = json["_id"].stringValue
                                let color = json["avatarColor"].stringValue
                                let avatarName = json["avatarName"].stringValue
                                let email = json["email"].stringValue
                                let name = json["name"].stringValue
                                
                                UserDataService.instance.setUserData(id: id, color: color, avatarName: avatarName, email: email, name: name)

                                completion(true)
                                
                            } else {
                                completion(false)
                                debugPrint(response.result.error as Any)
                                
                            }
                            
                          }
    }
    //the response here is same as createUser func up there
    func findUserByEmail(completion: @escaping CompletionHandler) {
        
        let header = [
            "Authorization":"Bearer \(AuthService.instance.authToken)",
            "Content-Type": "application/json; charset=utf-8"
            
        ]
    
        Alamofire.request("\(URL_USER_BY_EMAIL)\(userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            //if the response rrsult is nil we gonna extract those data
            if response.result.error == nil {
                guard let data = response.data else {return}
                let json = JSON(data: data)
                let id = json["_id"].stringValue
                let color = json["avatarColor"].stringValue
                let avatarName = json["avatarName"].stringValue
                let email = json["email"].stringValue
                let name = json["name"].stringValue
                
                UserDataService.instance.setUserData(id: id, color: color, avatarName: avatarName, email: email, name: name)
                
                completion(true)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
                
            }
            
                
    }
}
}

