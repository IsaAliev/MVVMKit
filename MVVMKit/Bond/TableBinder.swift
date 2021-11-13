//
//  TableBinder.swift
//
//  Created by Isa Aliev on 06/06/2019
//  Copyright © 2018. All rights reserved.
//

import Bond
import UIKit
import MVVMKit_Base

public class TableBinder<ChangeSet: SectionedDataSourceChangeset>:
    TableViewBinderDataSource<ChangeSet>
where
    ChangeSet.Collection == Array2D<CollectionItemViewModel, CollectionItemViewModel>
{
    private let depsManager: CollectionItemsViewModelDependencyManager
    private let cellProcessors: [CellProcessor]
    
    public init(
        depsManager: CollectionItemsViewModelDependencyManager,
        cellProcessors: [CellProcessor] = [],
        rowReloadAnimation: UITableView.RowAnimation = .fade,
        rowDeletionAnimation: UITableView.RowAnimation = .fade,
        rowInsertionAnimation: UITableView.RowAnimation = .fade
    ) {
        self.depsManager = depsManager
        self.cellProcessors = cellProcessors
        
        super.init()
        
        self.rowReloadAnimation = rowReloadAnimation
        self.rowDeletionAnimation = rowDeletionAnimation
        self.rowInsertionAnimation = rowInsertionAnimation
    }
    
    public override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let changeset = changeset else { return .init() }
        
        let model = changeset.collection.item(at: indexPath)
        let identifier = depsManager.reuseIdentifier(for: model)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            as! ViewModelTypeErasedViewRepresentable & UITableViewCell
        
        if var dependecyInstallableView = cell as? CollectionItemsViewDependenciesContainable,
           dependecyInstallableView.itemsDependencyManager == nil {
            dependecyInstallableView.itemsDependencyManager = depsManager
        }
        
        cell.typeErasedViewModel = model
        
        cellProcessors.forEach({ $0.processCell(cell, at: indexPath) })
        
        return cell
    }
}
