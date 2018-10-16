//
//  EmojiType.swift
//  EmojiDictionary
//
//  Created by Dennis Zubkoff on 10/10/2018.
//  Copyright © 2018 Denis Zubkov. All rights reserved.
//

import Foundation

class EmojiType: Codable {
    var name: String
    var emojis: [Emoji]
    
    init(name: String, emojis: [Emoji]) {
        self.name = name
        self.emojis = emojis
    }
}

