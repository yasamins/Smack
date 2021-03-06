//
//  ChannelVC.swift
//  Smack
//
//  Created by Yasamin Sa on 16/09/2017.
//  Copyright © 2017 Yasamin Sa. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController, UITableViewDelegate,
    UITableViewDataSource {
    
    //outlets
    //we need to chnage the text on the button when the user login so thats why we need the outlet
    @IBOutlet weak var loginBtn: UIButton!
    //we use unwind so when user click on exit button on signup VC they will come all the way back to initial VC
    
    @IBOutlet weak var userImg: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // the width of the back view when swiping
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        //we are listening for the notification in createaccountVC
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.channelsLoaded(_:)), name: NOTIF_CHANNELS_LOADED, object: nil)
        
        
        SocketService.instance.getChannel { (success) in
            if success {
                
                self.tableView.reloadData()
                
            }
            
        }
    }

    @IBAction func addChannelPressed(_ sender: Any) {
        //user can add channel only if they are logged in
        if AuthService.instance.isLoggedIn {
            let addChannel = AddChannelVC()
            addChannel.modalPresentationStyle = .custom
            present(addChannel, animated: true, completion: nil)
    }
    }
    @IBAction func loginBtnPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            //show profile page
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
        } else {
        //after pressing the login button we wanna segue to the login vc
        performSegue(withIdentifier: TO_LOGIN, sender: nil)
    }
    }
    //this func is gonna be called everytime we receive the notification
    @objc func userDataDidChange(_ notif: Notification) {
        //if the suer loggedin we gonna change the btn name and image
        if AuthService.instance.isLoggedIn {
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            userImg.image = UIImage(named:
            UserDataService.instance.avatarName)
        } else {
            loginBtn.setTitle("Login", for: .normal)
            userImg.image = UIImage(named: "menuProfileIcon")
            tableView.reloadData()
        }
        
    }
    
    @objc func channelsLoaded(_ notif: Notification) {
        tableView.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath:
        IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as? ChannelCell {
            //this channel is coming from our MessageSerbice array of channels
            let channel = MessageService.instance.channels[indexPath.row]
            cell.configureCell(channel: channel)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }
    //select the channel and then shoot off a notification that we selected the channel
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = MessageService.instance.channels[indexPath.row]
        MessageService.instance.selectedChannel = channel
        NotificationCenter.default.post(name: NOTIF_CHANNEL_SELECTED, object: nil)
        //make the menu slide back
        self.revealViewController().revealToggle(animated: true)
    }
}
