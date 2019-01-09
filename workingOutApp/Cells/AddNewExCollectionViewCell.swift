//
//  AddNewExCollectionViewCell.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 07/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

protocol PassingItemFromCellToController: AnyObject {
    func pasingToController(itemFromFunc: Item)
}

class AddNewExCollectionViewCell: UICollectionViewCell {

    var item: Item? {
        didSet {
            imageViewOfExersice.downloaded(from: item?.imageName ?? "")
        }
    }
    weak var delegate: PassingItemFromCellToController?

    lazy var infoButton: UIButton = {
        var button = UIButton(type: .infoLight)
        button.tintColor = .white
        button.addTarget(self, action: #selector(passingItem), for: .touchUpInside)
        return button
    }()

    lazy var imageViewOfExersice: UIImageView = {
        let imageEx = UIImageView()
        imageEx.contentMode = .scaleAspectFill
        imageEx.layer.cornerRadius = 16
        imageEx.backgroundColor = .white
        imageEx.layer.borderColor = UIColor.blue.cgColor
        imageEx.layer.borderWidth = 2
        imageEx.layer.masksToBounds = true
        return imageEx
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    fileprivate func setupView() {
        let viewContainer = UIView()
        addSubview(viewContainer)
        viewContainer.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        viewContainer.addSubview(imageViewOfExersice)
        imageViewOfExersice.anchor(top: viewContainer.topAnchor, leading: viewContainer.leadingAnchor, bottom: viewContainer.bottomAnchor, trailing: viewContainer.trailingAnchor, padding: .init(top: 2, left: 2, bottom: 2, right: 2))
        viewContainer.addSubview(infoButton)
        infoButton.anchor(top: nil, leading: nil, bottom: viewContainer.bottomAnchor, trailing: viewContainer.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 7, right: 7))
    }

    @objc func passingItem() {
       guard let item = item else { return }
        delegate?.pasingToController(itemFromFunc: item)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

