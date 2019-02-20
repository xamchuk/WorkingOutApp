//
//  AddNewExCollectionViewController.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 07/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

protocol SelectedItemFromCollectionView: class {
    func appendingItem(item: Exercise)
}

class AddNewExCollectionViewController: UIViewController {

    private let reuseIdentifier = "Cell"
    var collectionView: UICollectionView?
    var items: [Exercise]?
    var group = [[Exercise]]()
    weak var delegate: SelectedItemFromCollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.setBackgroudView()
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

extension AddNewExCollectionViewController: AddNewExCollectionViewDelegate {
    func addNewExCellDidAdd(exercise: Exercise) {
        let infoViewController = InfoViewController()
        infoViewController.item = exercise
        show(infoViewController, sender: nil)
    }
}

extension AddNewExCollectionViewController: CustomExerciseDelegate {
    func customItem(item: Exercise) {
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
         navigationItem.leftBarButtonItem = doneButton
        let addCustom = UIBarButtonItem(title: "Add Own Exercise", style: .plain, target: self, action: #selector(handleAddCustom))
        navigationItem.rightBarButtonItem = addCustom
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.tintColor = .white

    }
}



