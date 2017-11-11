//
//  ChatVC.swift
//  Smack
//
//  Created by Yasamin Sa on 16/09/2017.
//  Copyright © 2017 Yasamin Sa. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var menuBtn: UIButton!
    
    @IBOutlet weak var channelNameLbl: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //revealToggle is connected to action method of a button
        //selector is the method inside SWReavelViewController
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        //swipe recognizer
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        //tap recognizer
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)

        // if we are logged in
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail(completion: { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            })
        }
    }

    //this func is gonna be called everytime we receive the notification
    @objc func userDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLoggedIn {
            //get channels
            onLoginGetMessages()
        } else {
            channelNameLbl.text = "Please log in"
            
        }
        
    }
    
    func onLoginGetMessages() {
        MessageService.instance.findAllChannel { (success) in
            //do stuff with channels
        }
    }


}
