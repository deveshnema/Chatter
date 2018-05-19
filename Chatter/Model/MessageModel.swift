//
//  MessageModel.swift
//  ChatterLayout
//
//  Created by Devesh Nema on 5/6/18.
//  Copyright © 2018 Devesh Nema. All rights reserved.
//

import Foundation

class Friend : NSObject {
    var name: String?
    var profileImageName: String?
}

class Message : NSObject {
    var text: String?
    var date: Date?
    var friend: Friend?
    var isSender: Bool?
}
