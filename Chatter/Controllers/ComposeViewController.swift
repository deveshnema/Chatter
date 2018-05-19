//
//  ChatLogViewController.swift
//  ChatterLayout
//
//  Created by Devesh Nema on 5/6/18.
//  Copyright © 2018 Devesh Nema. All rights reserved.
//

import UIKit

class ComposeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let cellID = "cellID"
    var messages: [Message]?

    func setupData() {
        let alia = Friend()
        alia.name = "Alia Bhatt"
        alia.profileImageName = "alia"
        
        let message = Message()
        message.friend = alia
        message.text = "Hi this is Alia Bhatt, nice to meet you! My first movie was Student of the Year! It was not a big hit but hey its getting a sequel so thats kinda a big deal! Dont you think so? I mean only hit movies will go for a sequel. Isnt it?"
        message.date = Date().addingTimeInterval(-3 * 60)
        message.isSender = true
        
        let message2 = Message()
        message2.friend = alia
        message2.text = "Hi this is Alia Bhatt, nice to meet you! My first movie was Student of the Year! It was not a big hit but hey its getting a sequel so thats kinda a big deal! Dont you think so? I mean only hit movies will go for a sequel. Isnt it? My first movie was Student of the Year! It was not a big hit but hey its getting a sequel so thats kinda a big deal! Dont you think so? I mean only hit movies will go for a sequel. Isnt it?"
        message2.date = Date().addingTimeInterval(-5 * 60)
        
        let kriti = Friend()
        kriti.name = "Kriti Sanon"
        kriti.profileImageName = "kriti"
        
        let kritiMessage = Message()
        kritiMessage.friend = kriti
        kritiMessage.text = "This is Kriti Sanon, how are you? Hope you are having a good time"
        kritiMessage.date = Date().addingTimeInterval(-2 * 60)
        
        let kritiMessage2 = Message()
        kritiMessage2.friend = kriti
        kritiMessage2.text = "Hi there"
        kritiMessage2.date = Date().addingTimeInterval(-4 * 60)
        
        let kritiMessage3 = Message()
        kritiMessage3.friend = kriti
        kritiMessage3.text = "What's your next project? I might me doing a movie in 2019, but not sure what the cast is as of now. If you are interested please contact my on Instagram."
        kritiMessage3.date = Date().addingTimeInterval(-6 * 60)
        kritiMessage3.isSender = true
        
        messages = [message, message2, kritiMessage, kritiMessage2, kritiMessage3].sorted(by: { (m1, m2) -> Bool in
            m1.date!.compare(m2.date!) == .orderedDescending
        })
    }
    
    var friend: Friend? {
        didSet {
            navigationItem.title = friend?.name
        }
    }
    
    let textInputContainerView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let inputTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter text here"
        return textField
    }()
    
    let sendButton : UIButton = {
       let button = UIButton()
        button.setTitle("Send", for: UIControlState.normal)
        button.setTitleColor(UIColor.blue, for: UIControlState.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(sendButtonPressed), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    @objc func sendButtonPressed() {
        let taylor = Friend()
        taylor.name = "Taylor Swift"
        taylor.profileImageName = "taylor"
        
        let message = Message()
        
        message.friend = taylor
        message.text = inputTextField.text!
        message.date = Date().addingTimeInterval(-4 * 60)
        message.isSender = true
        messages?.append(message)
        
        let item = messages!.count - 1
        let insertionIndexPath = IndexPath(item: item, section: 0)
        collectionView?.insertItems(at: [insertionIndexPath])
        collectionView?.scrollToItem(at: insertionIndexPath, at: UICollectionViewScrollPosition.bottom, animated: true)
        inputTextField.text = nil
    }
    
    var bottomConstraint : NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        tabBarController?.tabBar.isHidden = true
        setupContainerViews()
        setupData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let keyboardIsShowing = notification.name == .UIKeyboardWillShow
            bottomConstraint?.constant = keyboardIsShowing ? -keyboardFrame!.height : 0
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                if keyboardIsShowing {
                    let indexPath = IndexPath(item: self.messages!.count - 1, section: 0)
                    self.collectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.bottom, animated: true)
                }
            }
        }
    }
    
    func setupContainerViews() {
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor.gray
        view.addSubview(textInputContainerView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: textInputContainerView)
        view.addConstraintsWithFormat(format: "V:[v0(48)]", views: textInputContainerView)
        bottomConstraint = NSLayoutConstraint(item: textInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        textInputContainerView.addSubview(inputTextField)
        textInputContainerView.addSubview(sendButton)
        textInputContainerView.addSubview(topBorderView)


        view.addConstraintsWithFormat(format: "H:|-8-[v0][v1(40)]-8-|", views: inputTextField, sendButton)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: inputTextField)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: sendButton)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: topBorderView)
        view.addConstraintsWithFormat(format: "V:|[v0(0.5)]", views: topBorderView)


    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count =  messages?.count {
            return count
        } else {
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ChatLogMessageCell
        cell.messageTextView.text = messages?[indexPath.item].text
        if let message = messages?[indexPath.item], let messageText = message.text, let profileImageName = messages?[indexPath.item].friend?.profileImageName {
            cell.profileImageView.image = UIImage(named: profileImageName)
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16)], context: nil)
            
            if let isSender = message.isSender,  isSender == true {
                cell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 16, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                cell.textBubbleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 8 - 16, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
                cell.profileImageView.isHidden = true
                cell.textBubbleView.backgroundColor = UIColor.blue
                cell.messageTextView.textColor = UIColor.white
            } else {
                cell.messageTextView.frame = CGRect(x: 8 + 40, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                cell.textBubbleView.frame = CGRect(x: 40, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
                cell.profileImageView.isHidden = false
                cell.textBubbleView.backgroundColor = UIColor.lightGray
                cell.messageTextView.textColor = UIColor.black
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let message = messages?[indexPath.item].text {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: message).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16)], context: nil)
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 0, 0, 0)
    }
   
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
    }
}

class ChatLogMessageCell : BaseCell {
    let messageTextView : UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.text = "Sample Message"
        textView.backgroundColor = UIColor.clear
        return textView
    }()
    
    let textBubbleView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView : UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        addConstraintsWithFormat(format: "H:|-8-[v0(30)]", views: profileImageView)
        addConstraintsWithFormat(format: "V:[v0(30)]|", views: profileImageView)
    }
    
}
