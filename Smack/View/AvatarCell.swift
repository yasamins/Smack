//
//  AvatarCell.swift
//  Smack
//
//  Created by Yasamin Sa on 18/10/2017.
//  Copyright © 2017 Yasamin Sa. All rights reserved.
//

import UIKit


enum AvatarType {
    case dark
    case light
}
class AvatarCell: UICollectionViewCell {
    
    
    @IBOutlet weak var avatarImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    func configureCell(index: Int, type: AvatarType) {
        if type == AvatarType.dark {
            avatarImg.image = UIImage(named: "dark\(index)")
            self.layer.backgroundColor = UIColor.lightGray.cgColor
        } else {
            avatarImg.image = UIImage(named: "light\(index)")
            self.layer.backgroundColor = UIColor.gray.cgColor
        }
    }
    
    
    func setUpView() {
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        //the view is not out of the corner radius
        self.clipsToBounds = true
        
    }
    
}
