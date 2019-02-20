//
//  Main+CoreData.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 19/02/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import CoreData

extension MainViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        let index = indexPath ?? (newIndexPath ?? nil)
        guard let cellIndex = index else {
            return
        }
        switch type {
        case .insert:
            collectionView?.insertItems(at: [cellIndex])
        case .delete:
            collectionView?.deleteItems(at: [cellIndex])
        case .update:
            collectionView?.reloadItems(at: [cellIndex])

        default:
            break
        }
    }
}
