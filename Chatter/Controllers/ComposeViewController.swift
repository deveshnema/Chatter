//
//  ChatLogViewController.swift
//  ChatterLayout
//
//  Created by Devesh Nema on 5/6/18.
//  Copyright © 2018 Devesh Nema. All rights reserved.
//

import UIKit
import Firebase

class ComposeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    let cellID = "cellID"
    var messages: [Message]?

    
    func appendMessage(for friend: Friend, with text: String, sent before: TimeInterval, isSender: Bool) {
        let msg = Message()
        msg.friend = friend
        msg.text = text
        msg.date = Date().addingTimeInterval(-before * 60)
        msg.isSender = isSender
        if messages?.append(msg) == nil {
            messages = [msg]
        }
    }
    
    func setupData() {
        let ironman = Friend()
        ironman.name = "Iron Man"
        ironman.profileImageName = "ironman"
        
        let captain = Friend()
        captain.name = "Captain America"
        captain.profileImageName = "captain"
        
        appendMessage(for: ironman, with: "There is no throne, there is no version of this where you come out on top! Maybe your army will come, maybe it's too much for us, but it's all on you. Because if we can't protect the Earth, you can be damn sure we'll avenge it!", sent: 2, isSender: true)
       
        appendMessage(for: captain, with: "You may not be a threat but you should stop pretending to be a hero.", sent: 2, isSender: false)

        appendMessage(for: ironman, with: "What is this? Shakespeare in the park?", sent: 2, isSender: true)
        
        appendMessage(for: captain, with: "Alright, listen up. Until we can close that portal, our priority's containment. Barton, I want you on that roof, eyes on everything. Call out patterns and strays. Stark, you got the perimeter. Anything gets more than three blocks out, you turn it back or you turn it to ash.", sent: 2, isSender: false)
        
        appendMessage(for: ironman, with: "You're just a lab experiment, Rogers. Anything special about you came out of the lab bottles.", sent: 2, isSender: true)

        

        
        
        messages?.sort(by: { (m1, m2) -> Bool in
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
    
    lazy var inputTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter text here"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
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
        let ref = Database.database().reference()
        
        let values = ["text" : inputTextField.text!]
        ref.child("messages").childByAutoId().updateChildValues(values)
        
        
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendButtonPressed()
        return true
    }
    
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
                cell.textBubbleView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
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
