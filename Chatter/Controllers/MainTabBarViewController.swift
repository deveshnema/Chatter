//
//  MainTabBarViewController.swift
//  ChatterLayout
//
//  Created by Devesh Nema on 5/6/18.
//  Copyright © 2018 Devesh Nema. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        let messagesListViewController = MessagesListViewController(collectionViewLayout: layout)
        let recentMessagesNavController = UINavigationController(rootViewController: messagesListViewController)
        recentMessagesNavController.tabBarItem.title = "Recent"
        recentMessagesNavController.tabBarItem.image = #imageLiteral(resourceName: "recent")

        
        let friendsListViewController = FriendListViewController(collectionViewLayout: layout)
        let friendsListNavController = UINavigationController(rootViewController: friendsListViewController)
        friendsListNavController.tabBarItem.title = "Friends"
        friendsListNavController.tabBarItem.image = #imageLiteral(resourceName: "people")
        
        let dvc1 = createDummyNavController(with: "Calls", image: #imageLiteral(resourceName: "calls"))
        let dvc2 = createDummyNavController(with: "Groups", image: #imageLiteral(resourceName: "groups"))
        let dvc4 = createDummyNavController(with: "Settings", image: #imageLiteral(resourceName: "settings"))

        viewControllers = [recentMessagesNavController, friendsListNavController, dvc1, dvc2, dvc4]
    }

    func createDummyNavController(with title: String, image: UIImage) -> UINavigationController {
        let controller = UIViewController()
        let navController = UINavigationController(rootViewController: controller)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
    }
   

}
