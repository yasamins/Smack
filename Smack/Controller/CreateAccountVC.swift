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
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    //variables
    //if the user does not pick any image this is the default one
    var avatarName = "profileDefault"
    //default gray color
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //spinner is first hidden
        spinner.isHidden = true

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDataService.instance.avatarName != "" {
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
            avatarName = UserDataService.instance.avatarName
        }
    }
    
    @IBAction func createAccntPressed(_ sender: Any) {
        //we want the spinner to show right when we click on createaccbtn
        spinner.isHidden = false
        spinner.startAnimating()
        //creating variable for our email and pass
        guard let name = usernameTxt.text , usernameTxt.text != "" else { return }
        guard let email = emailTxt.text , emailTxt.text != "" else { return }
        guard let pass = passTxt.text , passTxt.text != "" else { return }
        //we created registerUser function in AuthService class
        AuthService.instance.registerUser(email: email, password: pass){
            (success) in
            if success {
                AuthService.instance.loginUser(email: email, password: pass,
                                               completion: { (success) in
                                                if success {
                                                    AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
                                                        if success {
                                                            self.spinner.isHidden = true
                                                            self.spinner.stopAnimating()
                                                            self.performSegue(withIdentifier: UNWIND, sender: nil)
                                                            //after clicking on create account and after everything is successfull we gonna send this notification
                                                            NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                                                        }
                                                    })
                                                }
                                                
                })
//                print("register user!")
            }
        }
    }
    
    @IBAction func pickAvatarPressed(_ sender: Any) {
        
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }

    @IBAction func pickBGColorPressed(_ sender: Any) {
    }
    
    
    @IBAction func closePressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }

}


