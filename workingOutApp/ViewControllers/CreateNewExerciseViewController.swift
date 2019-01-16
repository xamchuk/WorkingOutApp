//
//  CreateNewExerciseViewController.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 15/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

class CreateNewExerciseViewController: UIViewController {

    let name = UITextField()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        view.addSubview(name)
        name.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: CGSize(width: 0, height: 50))
        name.layer.borderColor = UIColor.red.cgColor
        name.layer.borderWidth = 2
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
