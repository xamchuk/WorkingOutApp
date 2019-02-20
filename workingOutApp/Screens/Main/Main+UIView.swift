//
//  Main+UIView.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 19/02/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//
import UIKit

extension MainViewController {

    func setupNavigationController() {
        let logoutButton = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(handleLogOutButton))
        logoutButton.tintColor = .white
        navigationItem.rightBarButtonItem = logoutButton
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.title = "\(userName ?? "")"

    }

     func setupCollectionView() {
        let layer = UICollectionViewFlowLayout()
        layer.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layer)
        view.addSubview(collectionView!)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(UICollectionViewCell.self, forSupplementaryViewOfKind:  UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
        collectionView?.backgroundColor = .clear
        collectionView?.isPagingEnabled = true
        collectionView?.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
    }

    func setupFooterView() {
        let addButton = UIButton(type: .system)
        addButton.backgroundColor = UIColor.rgb(r: 0, g: 0, b: 0, a: 0.2)
        addButton.layer.cornerRadius = footerView.frame.height / 4
        addButton.setTitle("✚", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        let style = UIFont.TextStyle.largeTitle
        addButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: style)
        addButton.titleLabel?.adjustsFontSizeToFitWidth = true
        addButton.addTarget(self, action: #selector(handeleAddButton), for: .touchUpInside)
        footerView.addSubview(addButton)
        addButton.anchor(top: footerView.topAnchor, leading: footerView.leadingAnchor, bottom: footerView.bottomAnchor, trailing: footerView.trailingAnchor, padding: .init(top: 0, left: 4, bottom: 0, right: 4))
    }
}

