//
//  CreateAccountVC.swift
//  Smack
//
//  Created by Yasamin Sa on 17/09/2017.
//  Copyright © 2017 Yasamin Sa. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func closePressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
    

}
