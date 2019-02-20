//
//  Exercise+UITableView.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 19/02/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

extension ExerciseViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let obj = fetchedRC else { return 0 }
        return obj.fetchedObjects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ExerciseCell
        cell.selectionStyle = .none
        if fetchedRC != nil {
            cell.item = fetchedRC.object(at: indexPath)
        }
        cell.backgroundColor = .clear
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let exercise = fetchedRC.object(at: indexPath)
            coreDataStack.viewContext.delete(exercise)
            coreDataStack.saveContext()
        }
    }
    
}

extension ExerciseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsViewController()
        vc.coreDataStack = coreDataStack
        vc.exercise = fetchedRC.object(at: indexPath)
        show(vc, sender: nil)
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .none
        } else {
            return .delete
        }
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        fetchedRC.delegate = nil
        var objects = fetchedRC.fetchedObjects!
        let object = objects[sourceIndexPath.row]
        objects.remove(at: sourceIndexPath.row)
        objects.insert(object, at: destinationIndexPath.row)
        for (index, object) in objects.enumerated() {
            object.index = Int16(index)
        }
        self.coreDataStack.saveContext()
        fetchedRC.delegate = self
    }
}
