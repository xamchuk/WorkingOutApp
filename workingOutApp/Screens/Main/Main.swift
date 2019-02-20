//
//  CollectionViewController.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 01/02/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//
import Firebase
import CoreData
import UIKit

class
ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    var fetchedWorkouts: NSFetchedResultsController<Workouts>!
    let cellId = "Cell"
    let footerId = "Footer"
    var footerView = UICollectionReusableView()
    var coreDataStack: CoreDataStack!
    var collectionView: UICollectionView?
    var firstTextField: UITextField?
    var okAction: UIAlertAction?
    var itemAtIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.setBackgroudView()
        setupNavigationController()
        setupFetchRC()
        setupBasicData()
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchedWorkouts.delegate = self
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedWorkouts.delegate = nil
    }

    func setupFetchRC() {
        let request = Workouts.fetchRequest() as NSFetchRequest<Workouts>
        let sort = NSSortDescriptor(key: #keyPath(Workouts.index), ascending: true)
        request.sortDescriptors = [sort]
        do {
            fetchedWorkouts = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDataStack.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            try fetchedWorkouts.performFetch()
            fetchedWorkouts.delegate = self
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    func setupBasicData() {
        let name = "Trial"

        guard let objs = fetchedWorkouts.fetchedObjects else { return }
        var isHere = false

        for i in objs {
            if i.name == name {
                isHere = true
            }
        }
        if !isHere {
            let workout = Workouts(entity: Workouts.entity(), insertInto: self.coreDataStack.viewContext)
            workout.name = name
            workout.imageName = UIImage(named: "screen-1")?.pngData()! as NSData?
            workout.index = 0
            let exercise = Item(entity: Item.entity(), insertInto: self.coreDataStack.viewContext)
            exercise.name = "Barbell Bench Press"
            exercise.group = "Chest"
            exercise.owner = workout
            exercise.index = 0
            coreDataStack.saveContext()
        }
    }

    func presentSelectedItem(workout: Workouts, newWorkout: Bool) {
        let vc = ExerciseViewController()
        vc.coreDataStack = coreDataStack
        vc.workout = workout
        vc.setupFetchRC()
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true) {
            if newWorkout {
                vc.handleAddButton()
            }
        }
    }
    @objc func handleLogOutButton() {
        try! Auth.auth().signOut()
        self.dismiss(animated: false, completion: nil)
    }

    @objc func handleDeleteAction(longPressGesture : UILongPressGestureRecognizer) {
        let point = longPressGesture.location(in: self.collectionView)
        itemAtIndexPath = self.collectionView?.indexPathForItem(at: point)
        guard let indexPath = itemAtIndexPath else { return }
        let alertActionCell = UIAlertController(title: "Action Exercises Cell", message: "Choose an action for the selected list", preferredStyle: .actionSheet)
        let changeImage = UIAlertAction(title: "Change image", style: .destructive) { (action) in
            self.loadImageButtonTapped()
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            let obj = self.fetchedWorkouts.object(at: indexPath)
            self.coreDataStack.viewContext.delete(obj)
            self.coreDataStack.saveContext()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertActionCell.addAction(changeImage)
        alertActionCell.addAction(deleteAction)
        alertActionCell.addAction(cancelAction)
        alertActionCell.view.tintColor = .black
        self.present(alertActionCell, animated: true, completion: nil)
    }

    @objc func loadImageButtonTapped() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[.originalImage]
        guard let indexPath = itemAtIndexPath else { return }
        let obj = fetchedWorkouts.object(at: indexPath)
        obj.imageName = (pickedImage as! UIImage).pngData()! as NSData
        dismiss(animated: true, completion: nil)
    }

    @objc func handeleAddButton() {
        let title = "Write name of Workout"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Workout 1"
        })
        firstTextField = alert.textFields![0] as UITextField
        firstTextField?.delegate = self
        okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            action in
            let workout = Workouts(entity: Workouts.entity(), insertInto: self.coreDataStack.viewContext)
            workout.name = self.firstTextField?.text
            let lastWorkout = self.fetchedWorkouts.fetchedObjects?.last
            workout.index = (lastWorkout?.index ?? 0) + 1
            self.coreDataStack.saveContext()
            self.presentSelectedItem(workout: workout, newWorkout: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        guard let okAction = okAction else { return }
        okAction.isEnabled = false
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

extension MainViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == firstTextField {
            okAction?.isEnabled = string.isEmpty ? false : true
        }
        return true
    }
}
