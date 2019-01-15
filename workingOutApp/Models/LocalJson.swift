//
//  LocalJson.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 09/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit
// excercises
class LocalJson {
    func loadJson() -> [ItemJ]? {
        if let url = Bundle.main.url(forResource: "excercises", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(Items.self, from: data)
               
                return jsonData.items
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}
