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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //revealToggle is connected to action method of a button
        //selector is the method inside SWReavelViewController
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        //swipe recognizer
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        //tap recognizer
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
