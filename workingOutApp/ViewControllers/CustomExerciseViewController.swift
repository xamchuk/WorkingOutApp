//
//  CustomExerciseViewController.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 19/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

protocol CustomExerciseDelegate: AnyObject {
    func customItem(item: ItemJson)

}
class CustomExerciseViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let nameTextField = UITextField()
    let imagePicker = UIImagePickerController()
    let imageView = UIImageView()
    let saveButton = UIButton(type: .system)
    var item: ItemJson?
    weak var delegate: CustomExerciseDelegate?

    



    @objc func handleSave() {
        var name = ""
        if (nameTextField.text?.isEmpty)! {
            name = "NIIIIIILLLLL"
        } else {
            name = nameTextField.text!
        }
        item = ItemJson(name: "La")
        item?.name = name
        item?.imageLocalName = "test"
        item?.group = "LA LA LEND"
        delegate?.customItem(item: item!)
        dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.makeGradients()

        navigationController?.navigationBar.barTintColor = .gradientLighter
        imagePicker.delegate = self
        view.addSubview(imageView)
        setupImageView()
        view.addSubview(nameTextField)
        setupNameTextField()
        view.addSubview(saveButton)
        setupSaveButton()
    }
    
    @objc func loadImageButtonTapped(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let pickedImage = info[.originalImage]
        self.imageView.image = pickedImage as? UIImage
        self.imageView.contentMode = .scaleAspectFill
        dismiss(animated: true, completion: nil)

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

extension CustomExerciseViewController {

    fileprivate func setupImageView() {
        imageView.image = UIImage(named: "test")
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loadImageButtonTapped)))
        imageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 0))
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1).isActive = true
    }

    fileprivate func setupNameTextField() {
        nameTextField.delegate = self
        nameTextField.font = UIFont.boldSystemFont(ofSize: 30)
        nameTextField.textAlignment = .center
        nameTextField.placeholder = "Input the name"
        nameTextField.layer.borderColor = UIColor.black.cgColor
        nameTextField.layer.borderWidth = 2
        nameTextField.backgroundColor = .gray
        nameTextField.layer.cornerRadius = 20
        nameTextField.anchor(top: imageView.bottomAnchor, leading: imageView.leadingAnchor, bottom: nil, trailing: imageView.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 50))
    }

    fileprivate func setupSaveButton() {
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 32)
        saveButton.layer.borderColor = UIColor.linesColor.cgColor
        saveButton.layer.borderWidth = 5
        saveButton.layer.cornerRadius = 50
        saveButton.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        saveButton.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor , trailing: nil, padding: .init(top: 0, left: 0, bottom: 8, right: 0), size: CGSize(width: 100, height: 100))
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
