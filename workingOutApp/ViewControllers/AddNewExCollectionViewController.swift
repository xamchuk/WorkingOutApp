//
//  AddNewExCollectionViewController.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 07/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

protocol SelectedItemFromCollectionView: class {
    func appendingItem(item: ItemJson)
}

class AddNewExCollectionViewController: UIViewController {

    private let reuseIdentifier = "Cell"
    var collectionView: UICollectionView? //collectionViewLayout: UICollectionViewFlowLayout())
    var items: [ItemJson]?
    weak var delegate: SelectedItemFromCollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.makeGradients()
        let layer = UICollectionViewFlowLayout()
        layer.scrollDirection = .vertical
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layer)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        view.addSubview(collectionView!)
        collectionView?.backgroundColor = .clear
        setupNavigationBar()
        tabBarController?.tabBar.isHidden = true


        collectionView?.register(AddNewExCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)




        let json = LocalJson()
        items = json.loadJson()
    }
    func setupNavigationBar() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDoneButton))
        let addCustom = UIBarButtonItem(title: "Add Own Exercise", style: .plain, target: self, action: #selector(handleAddCustom))
        navigationItem.leftBarButtonItem = doneButton
        navigationItem.rightBarButtonItem = addCustom
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        tabBarController?.tabBar.isHidden = false

    }
    @objc func handleDoneButton() {
        dismiss(animated: true)
    }

    @objc func handleAddCustom() {
        let vc = CustomExerciseViewController()
        show(vc, sender: self)
    }
}
extension AddNewExCollectionViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AddNewExCollectionViewCell
        cell.item = items?[indexPath.item]
        cell.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = items?[indexPath.item] else { return }
        delegate?.appendingItem(item: item)
        items?.remove(at: indexPath.item)
        collectionView.deleteItems(at: [indexPath])
    }
}

extension AddNewExCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2 - 4, height: view.frame.width / 2 - 4)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension AddNewExCollectionViewController: PassingItemFromCellToController {
    func pasingToController(itemFromFunc: ItemJson) {
        let infoViewController = InfoViewController()
        infoViewController.item = itemFromFunc
        show(infoViewController, sender: nil)
    }
}


