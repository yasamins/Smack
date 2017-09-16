//
//  ChannelVC.swift
//  Smack
//
//  Created by Yasamin Sa on 16/09/2017.
//  Copyright © 2017 Yasamin Sa. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // the width of the back view when swiping
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
