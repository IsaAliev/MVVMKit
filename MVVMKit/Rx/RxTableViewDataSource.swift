//
//  RxTableViewDataSource.swift
//  
//
//  Created by Isa Aliev on 09.06.2022.
//

import UIKit
import RxCocoa
import RxSwift
#if canImport(MVVMKit_Base)
import MVVMKit_Base
#endif

public class RxTableViewDataSource<E: SectionedDataSourceChangeset>:
    NSObject,
    UITableViewDataSource,
    RxTableViewDataSourceType where E.Collection == Array2D<Section.SectionMeta, CollectionItemViewModel>
{
    public typealias Element = E
    
    private var changeset: Element?
    private weak var tableView: UITableView?
    
    private let depsManager: CollectionItemsViewModelDependencyManager
    private let cellProcessors: [CellProcessor]
    private let rowReloadAnimation: UITableView.RowAnimation
    private let rowDeletionAnimation: UITableView.RowAnimation
    private let rowInsertionAnimation: UITableView.RowAnimation
    
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
        self.rowReloadAnimation = rowReloadAnimation
        self.rowDeletionAnimation = rowDeletionAnimation
        self.rowInsertionAnimation = rowInsertionAnimation
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        changeset?.collection.numberOfItems(inSection: section) ?? .zero
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        changeset?.collection.numberOfSections ?? .zero
    }
    
    public func tableView(
        _ tableView: UITableView,
        canMoveRowAt indexPath: IndexPath
    ) -> Bool {
        canMoveItemAt?(tableView, indexPath) ?? false
    }
    
    public func tableView(
        _ tableView: UITableView,
        moveRowAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    ) {
        moveItemFromTo?(tableView, sourceIndexPath, destinationIndexPath)
    }
    
    public func tableView(_ tableView: UITableView, observedEvent: Event<Element>) {
        self.tableView = tableView
        
        switch observedEvent {
        case let .next(change):
            self.changeset = change
            applyChangeset(change)
            break
        default: break
        }
    }
    
    open func applyChangeset(_ changeset: E) {
        guard let tableView = tableView else { return }
        let diff = changeset.diff.asOrderedCollectionDiff.map { $0.asSectionDataIndexPath }
        if diff.isEmpty {
            tableView.reloadData()
        } else if diff.count == 1 {
            applyChangesetDiff(diff)
        } else {
            tableView.performBatchUpdates {
                applyChangesetDiff(diff)
            }
        }
        
        _ = tableView.numberOfSections
    }
    
    private func applyChangesetDiff(_ diff: OrderedCollectionDiff<IndexPath>) {
        guard let tableView = tableView else {
            return
        }
        
        let insertedSections = diff.inserts.filter { $0.count == 1 }.map { $0[0] }
        if !insertedSections.isEmpty {
            tableView.insertSections(IndexSet(insertedSections), with: rowInsertionAnimation)
        }
        let insertedItems = diff.inserts.filter { $0.count == 2 }
        if !insertedItems.isEmpty {
            tableView.insertRows(at: insertedItems, with: rowInsertionAnimation)
        }
        let deletedSections = diff.deletes.filter { $0.count == 1 }.map { $0[0] }
        if !deletedSections.isEmpty {
            tableView.deleteSections(IndexSet(deletedSections), with: rowDeletionAnimation)
        }
        let deletedItems = diff.deletes.filter { $0.count == 2 }
        if !deletedItems.isEmpty {
            tableView.deleteRows(at: deletedItems, with: rowDeletionAnimation)
        }
        let updatedItems = diff.updates.filter { $0.count == 2 }
        if !updatedItems.isEmpty {
            tableView.reloadRows(at: updatedItems, with: rowReloadAnimation)
        }
        let updatedSections = diff.updates.filter { $0.count == 1 }.map { $0[0] }
        if !updatedSections.isEmpty {
            tableView.reloadSections(IndexSet(updatedSections), with: rowReloadAnimation)
        }
        for move in diff.moves {
            if move.from.count == 2 && move.to.count == 2 {
                tableView.moveRow(at: move.from, to: move.to)
            } else if move.from.count == 1 && move.to.count == 1 {
                tableView.moveSection(move.from[0], toSection: move.to[0])
            }
        }
    }
}
