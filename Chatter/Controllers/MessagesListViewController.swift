//
//  ViewController.swift
//  ChatterLayout
//
//  Created by Devesh Nema on 5/5/18.
//  Copyright © 2018 Devesh Nema. All rights reserved.
//

import UIKit

class MessagesListViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let cellID = "cellID"
    let friendCellHeight : CGFloat = 100
    
    var messages: [Message]?
    
    func setupData() {
        let alia = Friend()
        alia.name = "Alia Bhatt"
        alia.profileImageName = "alia"
        
        let kriti = Friend()
        kriti.name = "Kriti Sanon"
        kriti.profileImageName = "kriti"
        
        let deepika = Friend()
        deepika.name = "Deepika Padukone"
        deepika.profileImageName = "deepika"
        
        let katrina = Friend()
        katrina.name = "Katrina Kaif"
        katrina.profileImageName = "katrina"
        
        
        
        let message = Message()
        message.friend = alia
        message.text = "Hi this is Alia Bhatt, nice to meet you!"
        message.date = Date().addingTimeInterval(-3 * 60)
        
        let kritiMessage = Message()
        kritiMessage.friend = kriti
        kritiMessage.text = "This is Kriti Sanon, how are you?"
        kritiMessage.date = Date().addingTimeInterval(-2 * 60)
        
        let kritiMessage2 = Message()
        kritiMessage2.friend = kriti
        kritiMessage2.text = "Did you watch Bareilly ki barfi?"
        kritiMessage2.date = Date().addingTimeInterval(-4 * 60)
        
        let kritiMessage3 = Message()
        kritiMessage3.friend = kriti
        kritiMessage3.text = "What's your next project?"
        kritiMessage3.date = Date().addingTimeInterval(-6 * 60)
        
        let deepikaMessage = Message()
        deepikaMessage.friend = deepika
        deepikaMessage.text = "Deepika here! Did you watch Padmavat?"
        deepikaMessage.date = Date().addingTimeInterval(-24 * 60 * 60)
        
        let katrinaMessage = Message()
        katrinaMessage.friend = katrina
        katrinaMessage.text = "Koi Tiger Zinda Hai bhi dekhlo!"
        katrinaMessage.date = Date().addingTimeInterval(-24 * 60 * 60 * 8)
        
        messages = [message, kritiMessage, deepikaMessage, kritiMessage2, katrinaMessage, kritiMessage3].sorted(by: { (m1, m2) -> Bool in
            m1.date!.compare(m2.date!) == .orderedDescending
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Recent"
        //navigationItem.backBarButtonItem?.title = "logout"
        //navigationItem.backBarButtonItem?.tintColor = UIColor.red
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: cellID)
        setupData()
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
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
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
