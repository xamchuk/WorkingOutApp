//
//  CustomDropButton.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 24/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

protocol DropDownProtocol {
    func dropDownPressed(string : String)
}

class DropDownBtn: UIButton, DropDownProtocol {

    func dropDownPressed(string: String) {
        self.setTitle(string, for: .normal)
        self.dismissDropDown()
    }

    var dropView = DropDownView()

    var height = NSLayoutConstraint()


    override init(frame: CGRect) {
        super.init(frame: frame)
        dropView = DropDownView()
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
    }

    func setup(cornerRadius: CGFloat, backgroundColor: UIColor) {
        dropView.layer.cornerRadius = cornerRadius
        dropView.layer.masksToBounds = true
        dropView.backgroundColor = backgroundColor

        superview?.addSubview(dropView)
        superview?.bringSubviewToFront(dropView)
        dropView.topAnchor.constraint(equalTo: bottomAnchor, constant: 4).isActive = true
        dropView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }

    var isOpen = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {

            isOpen = true

            NSLayoutConstraint.deactivate([self.height])

            if dropView.tableView.contentSize.height > 260 {
                height.constant = 260
            } else {
                height.constant = dropView.tableView.contentSize.height
            }


            NSLayoutConstraint.activate([height])

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)

        } else {
            isOpen = false

            NSLayoutConstraint.deactivate([height])
            height.constant = 0
            NSLayoutConstraint.activate([self.height])
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.0, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.center.y -= self.dropView.frame.height / 2
                self.dropView.layoutIfNeeded()
            }, completion: nil)

        }
    }

    func dismissDropDown() {
        isOpen = false
        NSLayoutConstraint.deactivate([height])
        height.constant = 0
        NSLayoutConstraint.activate([height])
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.0, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
        }, completion: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DropDownView: UIView, UITableViewDelegate, UITableViewDataSource  {

    var dropDownOptions = [String]()

    var tableView = UITableView()

    var delegate : DropDownProtocol!

    override init(frame: CGRect) {
        super.init(frame: frame)

       tableView.backgroundColor = .clear

        tableView.delegate = self
        tableView.dataSource = self

        tableView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(tableView)

        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        cell.imageView?.image = UIImage(named: dropDownOptions[indexPath.row]) ?? UIImage(named: "test")
        cell.imageView?.layer.masksToBounds = true
        cell.imageView?.layer.cornerRadius = cell.frame.height / 4
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.textLabel?.textColor = UIColor.gradientLighter
        cell.backgroundColor = .clear
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.dropDownPressed(string: dropDownOptions[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

}
