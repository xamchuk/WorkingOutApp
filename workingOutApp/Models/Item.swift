//
//  Item.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 06/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import Foundation

struct Items: Decodable {
    var items: [ItemJson]
}

struct ItemJson: Equatable, Decodable {
    var name: String
    var imageName: String?
    var imageLocalName: String?
    var imageData: Data?
    var rounds: Int?
    var amount: Int?
    var weight: Double?
    var videoString: String?
    var description: String?
    var group: String?

    init(name: String) {
        self.name = name
    }
}
