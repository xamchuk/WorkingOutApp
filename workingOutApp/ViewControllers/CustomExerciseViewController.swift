//
//  CustomExerciseViewController.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 19/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit
import Photos

protocol CustomExerciseDelegate: AnyObject {
    func customItem(item: ItemJson)
}

class CustomExerciseViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imageView = UIImageView()
    let imagePicker = UIImagePickerController()
    let fontStyle = UIFont.TextStyle.body
    let backgroundColor = UIColor.linesColor
    let cornerRadius: CGFloat = 6
    let nameTextField = UITextField()
    var groupButton = DropDownBtn()
    let saveButton = UIButton(type: .system)
    
    var item: ItemJson?
    weak var delegate: CustomExerciseDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .gradientLighter
        navigationItem.title = "Create your own exercise"
        view.makeGradients()
        imagePicker.delegate = self
        view.addSubview(imageView)
        setupImageView()
        view.addSubview(nameTextField)
        setupNameTextField()
        view.addSubview(groupButton)
        setupDropButton()
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

    @objc func handleSave() {
        if (nameTextField.text?.isEmpty)! || groupButton.title(for: .normal) == "Muscle Groups"  {
            var message = ""
            if  groupButton.title(for: .normal) == "Muscle Groups" {
                message = "Please, choice your muscle's group"
            }
            if (nameTextField.text?.isEmpty)! {
                message = "Please, type name of exercise"
            }
            let title = "Ups, something wrong"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            item = ItemJson(name: "")
            item?.name = nameTextField.text!
            item?.imageData = imageView.image?.pngData()
            item?.group = groupButton.title(for: .normal)
            delegate?.customItem(item: item!)
            dismiss(animated: true)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.text = textField.text?.capitalizingFirstLetter()
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.text = nameTextField.text?.capitalizingFirstLetter()
        self.view.endEditing(true)
    }
}

extension CustomExerciseViewController {

    fileprivate func setupImageView() {
        imageView.backgroundColor = UIColor.gradientLighter
        imageView.image = UIImage(named: "test")
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loadImageButtonTapped)))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2 / 3),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1)])
}

    fileprivate func setupNameTextField() {
        nameTextField.delegate = self
        nameTextField.font = UIFont.preferredFont(forTextStyle: fontStyle)
        nameTextField.textAlignment = .center
        nameTextField.adjustsFontSizeToFitWidth = true
        nameTextField.placeholder = "Input the name"
        nameTextField.backgroundColor = backgroundColor
        nameTextField.layer.cornerRadius = cornerRadius
        nameTextField.anchor(top: imageView.bottomAnchor, leading: imageView.leadingAnchor, bottom: nil, trailing: imageView.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 25))
    }
    
    fileprivate func setupDropButton() {
        groupButton.setTitle("Muscle Groups", for: .normal)
        groupButton.translatesAutoresizingMaskIntoConstraints = false
        groupButton.layer.cornerRadius = cornerRadius
        groupButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: fontStyle)
        groupButton.backgroundColor = backgroundColor
        NSLayoutConstraint.activate([
            groupButton.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            groupButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            groupButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8),
            groupButton.heightAnchor.constraint(equalTo: nameTextField.heightAnchor)])
        groupButton.dropView.dropDownOptions = ["Quadriceps", "Hamstrings", "Calves", "Chest", "Back", "Shoulders", "Triceps", "Biceps", "Forearms", "Trapezius", "Abs", "Obliques"]
        groupButton.setup(cornerRadius: groupButton.layer.cornerRadius, backgroundColor: backgroundColor)
    }

    fileprivate func setupSaveButton() {
        saveButton.setTitle("Create", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 32)
        saveButton.setTitleColor(.gradientLighter, for: .normal)
        saveButton.backgroundColor = .linesColor
        saveButton.layer.cornerRadius = cornerRadius
        saveButton.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        saveButton.anchor(top: nil, leading: groupButton.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor , trailing: groupButton.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 16, right: 0))
        saveButton.heightAnchor.constraint(equalTo: groupButton.heightAnchor, multiplier: 2).isActive = true
    }
}
