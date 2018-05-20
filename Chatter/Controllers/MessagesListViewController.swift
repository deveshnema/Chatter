//
//  ViewController.swift
//  ChatterLayout
//
//  Created by Devesh Nema on 5/5/18.
//  Copyright © 2018 Devesh Nema. All rights reserved.
//

import UIKit
import Firebase

class MessagesListViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let cellID = "cellID"
    let friendCellHeight : CGFloat = 100
    
    var messages: [Message]?
    
    func setupData() {
        let superman = Friend()
        superman.name = "Superman"
        superman.profileImageName = "superman"
        
        let hulk = Friend()
        hulk.name = "The Hulk"
        hulk.profileImageName = "hulk"
        
        let batman = Friend()
        batman.name = "Batman"
        batman.profileImageName = "batman"
        
        let captain = Friend()
        captain.name = "Captain America"
        captain.profileImageName = "captain"
        
        let flash = Friend()
        flash.name = "Flash"
        flash.profileImageName = "flash"
        
        let ironman = Friend()
        ironman.name = "Iron Man"
        ironman.profileImageName = "ironman"
        
        
        appendMessage(for: superman, with: "There is a superhero in all of us, we just need the courage to put on the cape.", sent: 2)
        appendMessage(for: hulk, with: "Hulk...SMASH", sent: 3)
        appendMessage(for: flash, with: "No, what I mean is, he's got your values. He's got your inner drive to help people do what's right. We're supposed to think we're something we're not until we become that thing. That's that path that Wally's on. I'm not gonna stop him from being the hero he's gonna become. I really don't think you should, either.", sent: 24 * 60)
        appendMessage(for: batman, with: "It's not who I am underneath, but what I do that defines me.", sent: 26 * 60)
        appendMessage(for: captain, with: "Alright, listen up. Until we can close that portal, our priority's containment. Barton, I want you on that roof, eyes on everything. Call out patterns and strays. Stark, you got the perimeter. Anything gets more than three blocks out, you turn it back or you turn it to ash.", sent: 24 * 60 * 10)
        appendMessage(for: ironman, with: "There is no throne, there is no version of this where you come out on top! Maybe your army will come, maybe it's too much for us, but it's all on you. Because if we can't protect the Earth, you can be damn sure we'll avenge it!", sent: 24 * 60 * 30)
        
        messages?.sort(by: { (m1, m2) -> Bool in
            m1.date!.compare(m2.date!) == .orderedDescending
        })

    }
    
    func appendMessage(for friend: Friend, with text: String, sent before: TimeInterval) {
        let msg = Message()
        msg.friend = friend
        msg.text = text
        msg.date = Date().addingTimeInterval(-before * 60)
        if messages?.append(msg) == nil {
            messages = [msg]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Recent"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "compose"), style: .plain, target: self, action: #selector(showComposeVC))
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: cellID)
        setupData()
        observeMessages()
    }
    
    func observeMessages() {
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message()
                message.text = dictionary["text"] as? String
                self.messages?.append(message)
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
                
            }
        }, withCancel: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messages?.count {
            return count
        } else {
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MessageCell
        
        if let message = messages?[indexPath.item] {
            cell.message = message
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: view.frame.width, height: friendCellHeight)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        let controller = ComposeViewController(collectionViewLayout: layout)
        controller.friend = messages?[indexPath.item].friend
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleLogout() {
        
    }
    
    @objc func showComposeVC() {
        let layout = UICollectionViewFlowLayout()
        let controller = FriendListViewController(collectionViewLayout: layout)
        navigationController?.pushViewController(controller, animated: true)
    }
}

class MessageCell : BaseCell {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            nameLabel.textColor = isHighlighted ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            timeLabel.textColor = isHighlighted ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            messageLabel.textColor = isHighlighted ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)


        }
    }
    
    var message : Message? {
        didSet {
            nameLabel.text = message?.friend?.name
            messageLabel.text = message?.text
            if let profileImageName = message?.friend?.profileImageName {
                profileImageView.image = UIImage(named: profileImageName)
                hasReadImageView.image = UIImage(named: profileImageName)
            }
            
            if let date = message?.date {
                let timeElapsedInSeconds = Date().timeIntervalSince(date)
                let secondsInDays : TimeInterval = 60 * 60 * 24
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"

                if timeElapsedInSeconds > 7 * secondsInDays {
                    dateFormatter.dateFormat = "MM/dd/yy"
                } else if timeElapsedInSeconds > secondsInDays {
                    dateFormatter.dateFormat = "EEE"
                }
                timeLabel.text = dateFormatter.string(from: date)
            }
        }
    }
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1)
        return imageView
    }()
    
    let dividerLineview : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Taylor Swift"
        return label
    } ()
    
    let messageLabel : UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "This is the message that your friend sent to you and is being displayed as a preview"
        return label
    } ()
    
    let timeLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        label.text = "11:11 pm"
        return label
    } ()
    
    let hasReadImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override func setupViews() {
        addSubview(profileImageView)
        addSubview(dividerLineview)
        
        profileImageView.image = UIImage(named: "taylor")
        hasReadImageView.image = UIImage(named: "taylor")

        addConstraintsWithFormat(format: "H:|-12-[v0(68)]", views: profileImageView)
        addConstraintsWithFormat(format: "V:[v0(68)]", views: profileImageView)
        addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        addConstraintsWithFormat(format: "H:|-82-[v0]|", views: dividerLineview)
        addConstraintsWithFormat(format: "V:[v0(1)]|", views: dividerLineview)
        
        setupContainerViews()
    }
    
    private func setupContainerViews() {
        let container = UIView()
        addSubview(container)
        addConstraintsWithFormat(format: "H:|-90-[v0]|", views: container)
        addConstraintsWithFormat(format: "V:[v0(50)]", views: container)
        addConstraint(NSLayoutConstraint(item: container, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        container.addSubview(nameLabel)
        container.addSubview(messageLabel)
        container.addSubview(timeLabel)
        container.addSubview(hasReadImageView)

        addConstraintsWithFormat(format: "H:|[v0][v1(80)]-12-|", views: nameLabel, timeLabel)
        addConstraintsWithFormat(format: "V:|[v0][v1(24)]|", views: nameLabel, messageLabel)
        addConstraintsWithFormat(format: "H:|[v0]-8-[v1(20)]-12-|", views: messageLabel, hasReadImageView)
        addConstraintsWithFormat(format: "V:|[v0(24)]", views: timeLabel)
        addConstraintsWithFormat(format: "V:[v0(20)]|", views: hasReadImageView)
    }
}

class BaseCell : UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init coder has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = UIColor.white
    }
}


extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String : UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
         addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
