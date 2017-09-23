//this file will handel all of our login, create users, register users functions
import Foundation
import Alamofire

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
    }

