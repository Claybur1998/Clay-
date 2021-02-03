//
//  MessageReaction.swift
//  CometChatSwift
//
//  Created by Pushpsen Airekar on 24/11/20.
//  Copyright © 2020 MacMini-03. All rights reserved.
//


import Foundation
import UIKit

class CometChatMessageReaction {
    
    var title: String?
    var name: String?
    var messageId: Int?
    var reactors: [CometChatMessageReactor]?
    
    init(title: String ,name: String, messageId: Int, reactors: [CometChatMessageReactor]) {
        self.title = title
        self.name = name
        self.messageId = messageId
        self.reactors = reactors
    }
}
