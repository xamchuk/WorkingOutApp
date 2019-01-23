//
//  AddNewExCollectionViewCell.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 07/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

protocol PassingItemFromCellToController: AnyObject {
    func pasingToController(itemFromFunc: ItemJson)
}

class AddNewExCollectionViewCell: UICollectionViewCell {

    var item: ItemJson? {
        didSet {
            imageViewOfExersice.downloaded(from: item?.imageName ?? "", completion: nil)
            title.text = item?.name
        }
    }
    weak var delegate: PassingItemFromCellToController?

    let imageViewOfExersice: UIImageView = {
        let imageEx = UIImageView()
        imageEx.contentMode = .scaleAspectFill
        return imageEx
    }()
    let title = UILabel()
    lazy var infoButton: UIButton = {
        var button = UIButton(type: .infoDark)
        button.tintColor = .white
        button.addTarget(self, action: #selector(passingItem), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    fileprivate func setupView() {
        let viewContainer = UIView()
        viewContainer.layer.cornerRadius = 16
        viewContainer.layer.masksToBounds = true
        addSubview(viewContainer)
        viewContainer.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)


        viewContainer.addSubview(imageViewOfExersice)
        imageViewOfExersice.anchor(top: viewContainer.topAnchor, leading: viewContainer.leadingAnchor, bottom: viewContainer.bottomAnchor, trailing: viewContainer.trailingAnchor)

        let viewTitle = UIView()
        viewTitle.backgroundColor = .black
        viewTitle.alpha = 0.8
        viewContainer.addSubview(viewTitle)
        viewTitle.anchor(top: nil, leading: viewContainer.leadingAnchor, bottom: viewContainer.bottomAnchor, trailing: viewContainer.trailingAnchor)
        viewTitle.heightAnchor.constraint(equalTo: viewContainer.heightAnchor, multiplier: 1 / 6 ).isActive = true


        viewTitle.addSubview(title)
        title.anchor(top: viewTitle.topAnchor, leading: viewTitle.leadingAnchor, bottom: viewTitle.bottomAnchor, trailing: viewTitle.trailingAnchor, padding: .init(top: 0, left: 6, bottom: 0, right: 6))
        title.adjustsFontSizeToFitWidth = true
        title.textColor = UIColor.textColor


        viewContainer.addSubview(infoButton)
        infoButton.anchor(top: viewContainer.topAnchor, leading: nil, bottom: nil, trailing: viewContainer.trailingAnchor, padding: .init(top: 7, left: 0, bottom: 0, right: 7))
    }

    @objc func passingItem() {
       guard let item = item else { return }
        delegate?.pasingToController(itemFromFunc: item)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

