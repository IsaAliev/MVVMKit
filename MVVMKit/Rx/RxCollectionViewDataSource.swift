//
//  RxCollectionViewDataSource.swift
//  
//
//  Created by Isa Aliev on 09.06.2022.
//

import RxCocoa
import RxSwift
import Foundation
import UIKit
#if canImport(MVVMKit_Base)
import MVVMKit_Base
#endif


public class RxCollectionViewDataSource<E: SectionedDataSourceChangeset>:
    NSObject,
    UICollectionViewDataSource,
    RxCollectionViewDataSourceType where E.Collection == Array2D<Section.SectionMeta, CollectionItemViewModel>
{
    
    public typealias Element = E
    
    private weak var collectionView: UICollectionView?
    private var changeset: Element?
    
    private let cellProcessors: [CellProcessor]
    private let supplementaryViewProcessors: [SupplementaryViewProcessor]
    private let depsManager: CollectionItemsViewModelDependencyManager
    public var moveItemFromTo: ((UICollectionView, IndexPath, IndexPath) -> Void)?
    public var canMoveItemAt: ((UICollectionView, IndexPath) -> Bool)?
    public var isMuted: Bool = false
    
    public init(
        depsManager: CollectionItemsViewModelDependencyManager,
        cellProcessors: [CellProcessor] = [],
        supplementaryViewProcessors: [SupplementaryViewProcessor] = []
    ) {
        self.depsManager = depsManager
        self.cellProcessors = cellProcessors
        self.supplementaryViewProcessors = supplementaryViewProcessors
        
        super.init()
    }
        
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let changeset = changeset else { return .init() }
        
        let model = changeset.collection.item(at: indexPath)
        let identifier = depsManager.reuseIdentifier(for: model)
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: identifier,
            for: indexPath
        ) as! ViewModelTypeErasedViewRepresentable & UICollectionViewCell
        
        if let dependecyInstallableView = cell as? CollectionItemsViewDependenciesContainable,
           dependecyInstallableView.itemsDependencyManager == nil {
            dependecyInstallableView.itemsDependencyManager = depsManager
        }
        
        cell.typeErasedViewModel = model
        cellProcessors.forEach({ $0.processCell(cell, at: indexPath) })
        
        return cell
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        var model: CollectionItemViewModel?
        
        if kind == UICollectionView.elementKindSectionFooter {
            model = changeset?.collection.sections[indexPath.section].metadata.footer
        } else if kind == UICollectionView.elementKindSectionHeader {
            model = changeset?.collection.sections[indexPath.section].metadata.header
        }
        
        guard let headerModel = model else {
            return UICollectionReusableView()
        }
        
        let identifier = depsManager.reuseIdentifier(for: headerModel)
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: identifier,
            for: indexPath
        )
        
        if let dependecyInstallableView = view as? CollectionItemsViewDependenciesContainable,
           dependecyInstallableView.itemsDependencyManager == nil {
            dependecyInstallableView.itemsDependencyManager = depsManager
        }
        
        (view as? ViewModelTypeErasedViewRepresentable)?.typeErasedViewModel = headerModel
        supplementaryViewProcessors.forEach({ $0.processSupplementaryView(view, at: indexPath) })
        
        return view
    }
    
    open func collectionView(
        _ collectionView: UICollectionView,
        canMoveItemAt indexPath: IndexPath
    ) -> Bool {
        canMoveItemAt?(collectionView, indexPath) ?? false
    }
    
    open func collectionView(
        _ collectionView: UICollectionView,
        moveItemAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    ) {
        moveItemFromTo?(collectionView, sourceIndexPath, destinationIndexPath)
    }
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return changeset?.collection.numberOfSections ?? 0
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return changeset?.collection.numberOfItems(inSection: section) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, observedEvent: Event<E>) {
        self.collectionView = collectionView
        
        switch observedEvent {
        case let .next(change):
            
            let diff = change.diff.asOrderedCollectionDiff.map { $0.asSectionDataIndexPath }
            
            if diff.isEmpty || diff.count == 1 {
                self.changeset = change
                applyChangeset(change)
            } else {
                applyChangeset(change)
            }
            
            break
        default: break
        }
    }
    
    open func applyChangeset(_ changeset: E) {
        guard !isMuted else { return }
        
        guard let collectionView = collectionView else { return }
        let diff = changeset.diff.asOrderedCollectionDiff.map { $0.asSectionDataIndexPath }
        if diff.isEmpty {
            collectionView.reloadData()
        } else if diff.count == 1 {
            applyChangesetDiff(diff)
        } else {
            collectionView.performBatchUpdates({ [weak self] in
                self?.changeset = changeset
                self?.applyChangesetDiff(diff)
            }, completion: nil)
        }
        ensureCollectionViewSyncsWithTheDataSource()
    }

    open func applyChangesetDiff(_ diff: OrderedCollectionDiff<IndexPath>) {
        guard let collectionView = collectionView else { return }
        let insertedSections = diff.inserts.filter { $0.count == 1 }.map { $0[0] }
        if !insertedSections.isEmpty {
            collectionView.insertSections(IndexSet(insertedSections))
        }
        let insertedItems = diff.inserts.filter { $0.count == 2 }
        if !insertedItems.isEmpty {
            collectionView.insertItems(at: insertedItems)
        }
        let deletedSections = diff.deletes.filter { $0.count == 1 }.map { $0[0] }
        if !deletedSections.isEmpty {
            collectionView.deleteSections(IndexSet(deletedSections))
        }
        let deletedItems = diff.deletes.filter { $0.count == 2 }
        if !deletedItems.isEmpty {
            collectionView.deleteItems(at: deletedItems)
        }
        let updatedItems = diff.updates.filter { $0.count == 2 }
        if !updatedItems.isEmpty {
            collectionView.reloadItems(at: updatedItems)
        }
        let updatedSections = diff.updates.filter { $0.count == 1 }.map { $0[0] }
        if !updatedSections.isEmpty {
            collectionView.reloadSections(IndexSet(updatedSections))
        }
        for move in diff.moves {
            if move.from.count == 2 && move.to.count == 2 {
                collectionView.moveItem(at: move.from, to: move.to)
            } else if move.from.count == 1 && move.to.count == 1 {
                collectionView.moveSection(move.from[0], toSection: move.to[0])
            }
        }
    }

    private func ensureCollectionViewSyncsWithTheDataSource() {
        _ = collectionView?.numberOfSections
    }
}
