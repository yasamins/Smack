//
//  CreateAccountVC.swift
//  Smack
//
//  Created by Yasamin Sa on 17/09/2017.
//  Copyright © 2017 Yasamin Sa. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var userImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    @IBAction func createAccntPressed(_ sender: Any) {
        //creating variable for our email and pass
        guard let email = emailTxt.text , emailTxt.text != "" else { return
            
        }
        guard let pass = passTxt.text , passTxt.text != "" else { return
            
        }
        //we created registerUser function in AuthService class
        AuthService.instance.registerUser(email: email, password: pass){
            (success) in
            if success {
                print("register user!")
            }
        }
    }
    
    @IBAction func pickAvatarPressed(_ sender: Any) {
    }

    @IBAction func pickBGColorPressed(_ sender: Any) {
    }
    
    
    @IBAction func closePressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
    

}
