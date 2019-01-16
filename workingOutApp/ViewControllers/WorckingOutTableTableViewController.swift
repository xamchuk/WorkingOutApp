//
//  WorckingOutTableTableViewController.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 03/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit
import Photos

protocol PassDataFromTableControllerToTabBar: AnyObject {
    func passingProgram(program: [Item])
}

class WorckingOutTableTableViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var exercises: [Item] = []  {
        didSet {
            delegate?.passingProgram(program: exercises)
            if exercises.count > 0 {
                tableLabel.isHidden = true
                navigationItem.title = "\(exercises.count) exercises for today"
            } else {
                navigationItem.title = "Lets's start with ADD"
                tableLabel.isHidden = false
            }
        }
    }

    var items: [ItemJ] = []
    let cellId = "cellId"
    let tableView = UITableView()
    var cells: [WorkingOutProgrammCell]?
    let tableLabel: UILabel = {
        let label = UILabel()
        label.text = "Add new exercises"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    var createView: UIView?
    var nameTextField: UITextField?
    let imagePicker = UIImagePickerController()
    var imageView = UIImageView()
    weak var delegate: PassDataFromTableControllerToTabBar?

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            exercises = try context.fetch(Item.fetchRequest())
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        view.backgroundColor = .white
        setupTableView()
        imagePicker.delegate = self
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handeleAddButton))
        let createButton = UIBarButtonItem(image: UIImage(named: "create"), style: .plain, target: self, action: #selector(handeleCreateButton))
        navigationItem.setRightBarButtonItems([createButton, addButton], animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //createView?.removeFromSuperview()
    }

    fileprivate func setupTableView() {
        view.addSubview(tableView)
        view.addSubview(tableLabel)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .gray
        tableLabel.centerInSuperview()
        tableView.dataSource = self
        tableView.register(WorkingOutProgrammCell.self, forCellReuseIdentifier: cellId)
    }

    @objc func handeleAddButton() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let addNewExCollectionViewController = AddNewExCollectionViewController(collectionViewLayout: layout)
        addNewExCollectionViewController.delegate = self
        show(addNewExCollectionViewController, sender: true)
    }

    @objc func handeleCreateButton() {
        navigationItem.rightBarButtonItems?[0].isEnabled = false
        createView = UIView()
        guard let createView = createView else { return }
        view.addSubview(createView)
        createView.backgroundColor = .gray
        createView.layer.borderColor = UIColor.black.cgColor
        createView.layer.borderWidth = 2
        createView.layer.cornerRadius = 40
        createView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 8, left: 8, bottom: 8, right: 8))

        let nameTextField: UITextField = {
            let textfield = UITextField()
            textfield.font = UIFont.boldSystemFont(ofSize: 30)
            textfield.textAlignment = .center
            textfield.placeholder = "Input the name"
            textfield.layer.borderColor = UIColor.black.cgColor
            textfield.layer.borderWidth = 2
            textfield.backgroundColor = .gray
            textfield.layer.cornerRadius = 20
            return textfield
        }()
        self.nameTextField = nameTextField
        let saveButton = UIButton(type: .roundedRect)
        let cancelButton = UIButton(type: .roundedRect)
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.addArrangedSubview(cancelButton)
            stackView.addArrangedSubview(saveButton)
            stackView.distribution = .fillEqually
            stackView.spacing = 8
            return stackView
        }()
        createView.addSubview(imageView)
        imageView.anchor(top: createView.topAnchor, leading: createView.leadingAnchor, bottom: nil, trailing: createView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 0))
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1).isActive = true
        imageView.image = UIImage(named: "test")
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loadImageButtonTapped)))
        createView.addSubview(nameTextField)

        nameTextField.anchor(top: imageView.bottomAnchor, leading: imageView.leadingAnchor, bottom: nil, trailing: imageView.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 50))
        nameTextField.delegate = self
        createButton(button: saveButton, title: "Save", action: #selector(handleSave))
        createButton(button: cancelButton, title: "Cancel", action: #selector(handleCancel))
        view.addSubview(stackView)
        stackView.anchor(top: nil, leading: imageView.leadingAnchor, bottom: createView.bottomAnchor, trailing: imageView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 8, right: 0), size: CGSize(width: 0, height: 50))

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

    func createButton(button: UIButton, title: String, action: Selector) {
        button.backgroundColor = .gray
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
    }

    @objc func handleCancel() {
        createView?.removeFromSuperview()
        navigationItem.rightBarButtonItems?[0].isEnabled = true
    }

    @objc func handleSave() {
        let exer = Item(entity: Item.entity(), insertInto: context)
        exer.name = nameTextField?.text ?? "NIIIIIILLLLL"
        exer.imageName = "test"
        exer.imageData = imageView.image!.pngData() as NSData?
        exer.amount = 0
        exer.rounds = 0
        exer.weight = 0
        exercises.append(exer)
        appDelegate.saveContext()
        tableView.reloadData()
        createView?.removeFromSuperview()
        navigationItem.rightBarButtonItems?[0].isEnabled = true
    }
}

extension WorckingOutTableTableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WorkingOutProgrammCell
        cell.delegate = self
        cell.item = exercises[indexPath.row]
        cells?.append(cell)
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(exercises[indexPath.row])
            exercises.remove(at: indexPath.row)
            appDelegate.saveContext()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}


extension WorckingOutTableTableViewController : DidSetSecondsFromCellToTableController {
    func passingSeconds(seconds: Double, item: Item) {
        for i in exercises {
            if i.name == item.name {
                guard let index = exercises.index(of: i) else { return }
                exercises[index] = item
                break
            }
        }
    }
}

extension WorckingOutTableTableViewController: SelectedItemFromCollectionView {
    func appendingItem(item: ItemJ) {
        let exer = Item(entity: Item.entity(), insertInto: context)
        exer.name = item.name
        exer.imageName = item.imageName
        exer.amount = Int16(item.amount)
        exer.rounds = Int16(item.rounds)
        exer.weight = item.weight ?? 0.00
        exer.descriptions = item.description
        exer.videoString = item.videoString
        exer.group = item.group
        exercises.append(exer)
        appDelegate.saveContext()
        tableView.reloadData()
    }
}

