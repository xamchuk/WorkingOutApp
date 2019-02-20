//
//  Exercise+CoreData.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 19/02/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import CoreData

extension ExerciseViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        let index = indexPath ?? (newIndexPath ?? nil)
        guard let cellIndex = index else { return }

        switch type {
        case .insert:
            tableView.insertRows(at: [cellIndex], with: .automatic)
            refreshHeaderAndButtons()
        case .delete:
            tableView.deleteRows(at: [cellIndex], with: .automatic)
            refreshHeaderAndButtons()
        case .update:
            tableView.reloadRows(at: [cellIndex], with: .automatic)
        default:
            break
        }
    }
}
