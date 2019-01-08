//
//  AddNewExCollectionViewController.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 07/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

protocol SelectedItemFromCollectionView: class {
    func appendingItem(item: Item)
}

class AddNewExCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var items: [Item]?

    private let reuseIdentifier = "Cell"

    weak var delegate: SelectedItemFromCollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        collectionView.backgroundColor = .white

        collectionView!.register(AddNewExCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        items = [Item(name: "Breast", imageName: "https://images.pexels.com/photos/1229356/pexels-photo-1229356.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940", rounds: 0, amount: 0, weight: 0, videoString: "gRVjAtPip0Y"), Item(name: "Legs", imageName: "https://images.pexels.com/photos/1431283/pexels-photo-1431283.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940", rounds: 0, amount: 0, weight: 0, videoString: "gRVjAtPip0Y")]
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
    func pasingToController(itemFromFunc: Item) {
        let infoViewController = InfoViewController()
        infoViewController.item = itemFromFunc
        show(infoViewController, sender: nil)
    }
}
