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
    let imageViewOfExersice = UIImageView()
    let viewTitle = UIView()
    let title = UILabel()
    lazy var infoButton = UIButton(type: .infoDark)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @objc func passingItem() {
       guard let item = item else { return }
        delegate?.pasingToController(itemFromFunc: item)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddNewExCollectionViewCell {

    fileprivate func setupInfoButton() {
        infoButton.tintColor = .white
        infoButton.addTarget(self, action: #selector(passingItem), for: .touchUpInside)
        infoButton.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 7, left: 0, bottom: 0, right: 7))
    }

    fileprivate func setupView() {
        layer.cornerRadius = 16
        layer.masksToBounds = true
        addSubview(imageViewOfExersice)
        setupImageViewOfExersice()
        addSubview(viewTitle)
        setupViewTitleAndTitle()
        addSubview(infoButton)
        setupInfoButton()
    }

    fileprivate func setupImageViewOfExersice() {
        imageViewOfExersice.contentMode = .scaleAspectFill
        imageViewOfExersice.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }

    fileprivate func setupViewTitleAndTitle() {
        viewTitle.backgroundColor = .black
        viewTitle.alpha = 0.8
        viewTitle.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        viewTitle.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1 / 6 ).isActive = true
        viewTitle.addSubview(title)
        title.anchor(top: viewTitle.topAnchor, leading: viewTitle.leadingAnchor, bottom: viewTitle.bottomAnchor, trailing: viewTitle.trailingAnchor, padding: .init(top: 0, left: 6, bottom: 0, right: 6))
        title.adjustsFontSizeToFitWidth = true
        title.textColor = UIColor.textColor
    }
}

