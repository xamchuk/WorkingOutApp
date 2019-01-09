//
//  Item.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 06/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import Foundation
struct Items: Decodable {
    var items: [Item]
}
struct Item: Equatable, Decodable {

    var name: String
    var imageName: String
    var rounds: Int
    var amount: Int
    var weight: Double?
    var videoString: String?
    var description: String?
    var group: String?

//    init(name: String, imageName: String, rounds: Int, amount: Int, weight: Double, videoString: String) {
//        self.name = name
//        self.imageName = imageName
//        self.rounds = rounds
//        self.amount = amount
//        self.weight = weight
//        self.videoString = videoString
}
