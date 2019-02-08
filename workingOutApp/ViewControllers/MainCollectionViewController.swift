//
//  CollectionViewController.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 01/02/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit
import CoreData

class MainCollectionViewController: UIViewController {


    private var fetchedWorkouts: NSFetchedResultsController<Workouts>!
    private let cellId = "Cell"
    var coreDataStack: CoreDataStack!
    var collectionView: UICollectionView?
    var posionOfItemIndexPath = IndexPath(item: 0, section: 0)
    override func viewDidLoad() {
        view.makeGradients()
        refreshCoreData()
        setupNavigationController()
        setupCollectionView()
        super.viewDidLoad()
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleDeleteAction))
        view.addGestureRecognizer(gesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshCoreData()
        collectionView?.reloadData()
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        posionOfItemIndexPath = IndexPath(item: Int(x / view.frame.width), section: 0)
        refreshNavTitle()
    }

    @objc func handleDeleteAction(longPressGesture : UILongPressGestureRecognizer) {
        let point = longPressGesture.location(in: self.collectionView)
        let indexP = self.collectionView?.indexPathForItem(at: point)
        guard let indexPath = indexP else { return }
        let alertActionCell = UIAlertController(title: "Action Exercises Cell", message: "Choose an action for the selected list", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            let obj = self.fetchedWorkouts.object(at: self.posionOfItemIndexPath)
            self.coreDataStack.viewContext.delete(obj)
            self.coreDataStack.saveContext()
            self.refreshCoreData()
            self.collectionView!.deleteItems(at: [self.posionOfItemIndexPath])
            if self.posionOfItemIndexPath.item == (self.fetchedWorkouts.fetchedObjects?.count)! {
                self.posionOfItemIndexPath.item = indexPath.item - 1
            } else if self.posionOfItemIndexPath.item != 0 {
                self.posionOfItemIndexPath.item = indexPath.item
            }
            self.refreshNavTitle()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertActionCell.addAction(deleteAction)
        alertActionCell.addAction(cancelAction)
        alertActionCell.view.tintColor = .black
        self.present(alertActionCell, animated: true, completion: nil)
    }

    func refreshCoreData() {
        let request = Workouts.fetchRequest() as NSFetchRequest<Workouts>
        let query = ""
        if !query.isEmpty {
            request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", query)
        }
        let sort = NSSortDescriptor(key: #keyPath(Workouts.name), ascending: true)
        request.sortDescriptors = [sort]
        do {
            fetchedWorkouts = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDataStack.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            try fetchedWorkouts.performFetch()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    func refreshNavTitle() {
        if fetchedWorkouts.fetchedObjects?.count == 0 {
            navigationItem.title = "Create your own program"
        } else {
            navigationItem.title = fetchedWorkouts.object(at: posionOfItemIndexPath).name
        }
    }

    @objc func handeleAddButton() {
        let workout = Workouts(entity: Workouts.entity(), insertInto: coreDataStack.viewContext)
        let title = "Write name of Workout"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Workout 1"
        })
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            let firstTextField = alert.textFields![0] as UITextField
            workout.name = firstTextField.text
            self.coreDataStack.saveContext()
            self.refreshCoreData()
            self.collectionView?.reloadData()
            guard let objs = self.fetchedWorkouts.fetchedObjects else { return }
            let indexPath = IndexPath(item: objs.count - 1, section: 0)
            self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.posionOfItemIndexPath.item = objs.count - 1
            self.refreshNavTitle()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    @objc func handleStartButtonAction() {
        let workout = fetchedWorkouts.object(at: posionOfItemIndexPath)
        let timerVC = TimerVCtrial() //TimerViewController()
        timerVC.workout = workout
        timerVC.coreDataStack = coreDataStack
        present(timerVC, animated: true, completion: nil)
    }
}
extension MainCollectionViewController {

    fileprivate func setupCollectionView() {
        let layer = UICollectionViewFlowLayout()
        layer.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layer)
        view.addSubview(collectionView!)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(ExerciseCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = .clear
        collectionView?.isPagingEnabled = true
        collectionView?.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
    }

    fileprivate func setupNavigationController() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handeleAddButton))
        navigationItem.setRightBarButton(addButton, animated: true)
        navigationItem.rightBarButtonItem?.tintColor = .textColor
        let backItem = UIBarButtonItem()
        backItem.tintColor = .textColor
        navigationItem.backBarButtonItem = backItem
        navigationController?.navigationBar.barTintColor = .gradientDarker
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.textColor]
        refreshNavTitle()
    }
}

extension MainCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedWorkouts.fetchedObjects?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ExerciseCollectionViewCell
        cell.delegateCell = self
        cell.coreDataStack = coreDataStack
        cell.workout = fetchedWorkouts.object(at: indexPath)
        cell.refreshCoreData()
        cell.startButton.addTarget(self, action: #selector(handleStartButtonAction), for: .touchUpInside)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension MainCollectionViewController: ExerciseCellDelegate {
    func passingAddNewExerciseAction(vc: UIViewController) {
        let navController = UINavigationController(rootViewController: vc)
        present(navController, animated: true, completion: nil)
    }

    func passingViewControllerForSelectedCell(exercise: Item) {
        let vc = DetailsViewController()
        vc.coreDataStack = coreDataStack
        vc.exercise = exercise
        show(vc, sender: self)
    }
}
