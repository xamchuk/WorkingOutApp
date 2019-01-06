//
//  Protocols.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 06/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import Foundation

protocol DidSetSecondsFromCellToTableController: class {
    func passingSeconds(seconds: Double)
}
protocol PassDataFromTableControllerToTabBar: class {
    func passingSeconds(seconds: Double)
}
protocol PassDataFromTabBarToTimer: class {
    func passingSeconds(seconds: Double)
}

