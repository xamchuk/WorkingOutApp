//
//  CustomExerciseViewController.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 19/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

class CustomExerciseViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let nameTextField = UITextField()
    let imagePicker = UIImagePickerController()
    let imageView = UIImageView()



    



//    @objc func handleSave() {
//        let exer = Item(entity: Item.entity(), insertInto: context)
//        exer.name = nameTextField?.text ?? "NIIIIIILLLLL"
//        exer.imageName = "test"
//        exer.imageData = imageView.image!.pngData() as NSData?
//        exercises.append(exer)
//        appDelegate.saveContext()
//
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.makeGradients()

        navigationController?.navigationBar.barTintColor = .gradientLighter
        imagePicker.delegate = self
        view.addSubview(imageView)
        setupImageView()
        view.addSubview(nameTextField)
        setupNameTextField()
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
}
