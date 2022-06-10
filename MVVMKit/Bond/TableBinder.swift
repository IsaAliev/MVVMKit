//
//  TableBinder.swift
//
//  Created by Isa Aliev on 06/06/2019
//  Copyright © 2018. All rights reserved.
//

import Bond
import UIKit
#if canImport(MVVMKit_Base)
import MVVMKit_Base
#endif

public class TableBinder<ChangeSet: SectionedDataSourceChangeset>:
    TableViewBinderDataSource<ChangeSet>
where
	ChangeSet.Collection == Array2D<Section.SectionMeta, CollectionItemViewModel>
{
    private let depsManager: CollectionItemsViewModelDependencyManager
    private let cellProcessors: [CellProcessor]
    
    public var moveItemFromTo: ((UITableView, IndexPath, IndexPath) -> Void)?
    public var canMoveItemAt: ((UITableView, IndexPath) -> Bool)?
    
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
        
        if let dependecyInstallableView = cell as? CollectionItemsViewDependenciesContainable,
           dependecyInstallableView.itemsDependencyManager == nil {
            dependecyInstallableView.itemsDependencyManager = depsManager
        }
        
        cell.typeErasedViewModel = model
        
        cellProcessors.forEach({ $0.processCell(cell, at: indexPath) })
        
        return cell
    }
    
    @objc(tableView:canMoveRowAtIndexPath:)
    public func tableView(
        _ tableView: UITableView,
        canMoveRowAt indexPath: IndexPath
    ) -> Bool {
        canMoveItemAt?(tableView, indexPath) ?? false
    }
    
    @objc(tableView:moveRowAtIndexPath:toIndexPath:)
    public func tableView(
        _ tableView: UITableView,
        moveRowAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    ) {
        moveItemFromTo?(tableView, sourceIndexPath, destinationIndexPath)
    }
}
