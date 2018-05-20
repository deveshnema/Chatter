//
//  FriendListViewController.swift
//  Chatter
//
//  Created by Devesh Nema on 5/20/18.
//  Copyright © 2018 Devesh Nema. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class FriendListViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var friends: [Friend]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white

        self.collectionView!.register(FriendCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        setupData()

    }

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
        
        friends = [ironman, hulk, captain, flash, batman, superman]
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = friends?.count {
            return count
        } else {
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FriendCell
        
        if let friend = friends?[indexPath.item] {
            cell.nameLabel.text = friend.name
            cell.profileImageView.image = UIImage(named: friend.profileImageName!)
        }
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: view.frame.width, height: 100)
    }
}


class FriendCell : BaseCell {
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1)
        return imageView
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        label.text = "Batman"
        return label
    } ()
    
    let dividerLineview : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    let showComposeButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "forward"), for: .normal)
        return button
    }()
    
    
    override func setupViews() {
        super.setupViews()
        
        let container = UIView()
        addSubview(profileImageView)
        addSubview(dividerLineview)
        addSubview(container)
        
        profileImageView.image = UIImage(named: "batman")
        addConstraintsWithFormat(format: "H:|-12-[v0(68)]", views: profileImageView)
        addConstraintsWithFormat(format: "V:[v0(68)]", views: profileImageView)
        addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        
        addConstraintsWithFormat(format: "H:|-82-[v0]|", views: dividerLineview)
        addConstraintsWithFormat(format: "V:[v0(1)]|", views: dividerLineview)
         
        
         addConstraintsWithFormat(format: "H:|-90-[v0]|", views: container)
         addConstraintsWithFormat(format: "V:[v0(50)]", views: container)
         addConstraint(NSLayoutConstraint(item: container, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
         
         container.addSubview(nameLabel)
        container.addSubview(showComposeButton)

         
         addConstraintsWithFormat(format: "H:|-12-[v0][v1(30)]-12-|", views: nameLabel, showComposeButton)
         //addConstraintsWithFormat(format: "V:|[v0][v1(30)]|", views: nameLabel, showComposeButton)
        addConstraintsWithFormat(format: "V:|[v0]|", views: nameLabel)
        addConstraintsWithFormat(format: "V:|[v0(30)]|", views: showComposeButton)

    }
}

