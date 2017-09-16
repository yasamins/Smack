//
//  ChannelVC.swift
//  Smack
//
//  Created by Yasamin Sa on 16/09/2017.
//  Copyright © 2017 Yasamin Sa. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {
    
    //outlets
    //we need to chnage the text on the button when the user login so thats why we need the outlet
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // the width of the back view when swiping
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        //after pressing the login button we wanna segue to the login vc
        performSegue(withIdentifier: TO_LOGIN, sender: nil)
    }
    
}
