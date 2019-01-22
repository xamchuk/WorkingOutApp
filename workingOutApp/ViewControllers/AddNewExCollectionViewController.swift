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
    var collectionView: UICollectionView?
    var items: [ItemJson]?
    var group = [[ItemJson]]()
    weak var delegate: SelectedItemFromCollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.makeGradients()
        setupNavigationBar()
        setupCollectionView()
        tabBarController?.tabBar.isHidden = true
        let json = LocalJson()
        items = json.loadJson()

        let groupD = Dictionary(grouping: items!) { (item) -> String? in
            return item.group
        }
        let keys = groupD.keys
        keys.forEach { (key) in
            group.append(groupD[key]!)
        }
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
        vc.delegate = self
        show(vc, sender: self)
    }
}
extension AddNewExCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return group.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return group[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AddNewExCollectionViewCell
        cell.item = group[indexPath.section][indexPath.item]
        cell.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = group[indexPath.section][indexPath.item]
        delegate?.appendingItem(item: item)
        group[indexPath.section].remove(at: indexPath.item)
        collectionView.deleteItems(at: [indexPath])
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HEADER", for: indexPath) as! SectionHeader
        sectionHeader.nameLabel.text = " \(group[indexPath.section].first?.group ?? "") "
        return sectionHeader
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
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

extension AddNewExCollectionViewController: CustomExerciseDelegate {
    func customItem(item: ItemJson) {
        delegate?.appendingItem(item: item)
    }
}

extension AddNewExCollectionViewController {

    fileprivate func setupCollectionView() {
        let layer = UICollectionViewFlowLayout()
        layer.scrollDirection = .vertical
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layer)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        view.addSubview(collectionView!)
        collectionView?.backgroundColor = .clear
        collectionView?.register(AddNewExCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: "HEADER")
    }

    fileprivate func setupNavigationBar() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDoneButton))
        let addCustom = UIBarButtonItem(title: "Add Own Exercise", style: .plain, target: self, action: #selector(handleAddCustom))
        navigationItem.leftBarButtonItem = doneButton
        navigationItem.rightBarButtonItem = addCustom
//        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem?.tintColor = .textColor
        doneButton.tintColor = .textColor
        navigationController?.navigationBar.barTintColor = .gradientDarker
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.textColor]
    }
}



