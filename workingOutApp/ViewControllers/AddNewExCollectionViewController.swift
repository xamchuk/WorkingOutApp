//
//  AddNewExCollectionViewController.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 07/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

protocol SelectedItemFromCollectionView: class {
    func appendingItem(item: ItemJ)
}

class AddNewExCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var items: [ItemJ]?

    private let reuseIdentifier = "Cell"

    weak var delegate: SelectedItemFromCollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        collectionView.backgroundColor = .white

        collectionView!.register(AddNewExCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        let backButton = UIBarButtonItem()
        backButton.title = "Done"
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.navigationBar.prefersLargeTitles = false

        let json = LocalJson()
        items = json.loadJson()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        tabBarController?.tabBar.isHidden = false

    }
}
extension AddNewExCollectionViewController {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AddNewExCollectionViewCell
        cell.item = items?[indexPath.item]
        cell.delegate = self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2 - 4, height: view.frame.width / 2 - 4)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = items?[indexPath.item] else { return }
        delegate?.appendingItem(item: item)
        items?.remove(at: indexPath.item)
        collectionView.deleteItems(at: [indexPath])
    }
}

extension AddNewExCollectionViewController: PassingItemFromCellToController {
    func pasingToController(itemFromFunc: ItemJ) {
        let infoViewController = InfoViewController()
        infoViewController.item = itemFromFunc
        show(infoViewController, sender: nil)
    }
}
