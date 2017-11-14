//
//  MessageCell.swift
//  Smack
//
//  Created by Yasamin Sa on 13/11/2017.
//  Copyright © 2017 Yasamin Sa. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var userImg: UIImageView!
    
    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var timeStampLbl: UILabel!
    
    @IBOutlet weak var messageBodyLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(message: Message) {
        messageBodyLbl.text = message.message
        userNameLbl.text = message.userName
        userImg.image = UIImage(named: message.userAvatar)
    }

}
