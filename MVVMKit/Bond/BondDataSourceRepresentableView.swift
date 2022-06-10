//
//  BondDataSourceRepresentableView.swift
//  MVVMKit
//
//  Created by Isa Aliev on 11.04.2021.
//

import ReactiveKit
import UIKit
#if canImport(MVVMKit_Base)
import MVVMKit_Base
#endif

public protocol BondDataSourceRepresentableView: CollectionItemsViewDependenciesContainable {
    var dataProvider: SectionedListContaining! { get }
    var bag: DisposeBag { get }
}

public extension BondDataSourceRepresentableView {
    func itemModel(at indexPath: IndexPath) -> CollectionItemViewModel? {
        let collection = dataProvider.items.changeset.collection
        
        guard collection.sections.count > indexPath.section else { return nil }
        guard collection.sections[indexPath.section].items.count > indexPath.row else { return nil }
        
        return collection.item(at: indexPath)
    }
}

public extension BondDataSourceRepresentableView {
    func configureDataSource(
        for collectionView: UICollectionView,
        withCellProcessors cellProcessors: [CellProcessor] = [],
        andSupplementaryViewProcessors supplementariesProcessors: [SupplementaryViewProcessor] = [],
        configuration: ((CollectionBinder<SectionedArrayChangeset>) -> Void)? = nil
    ) {
        collectionView.dataSource = nil
        
        guard let manager = itemsDependencyManager else { return }
        
        manager.install(on: collectionView)
        
        let binder = CollectionBinder<SectionedArrayChangeset>(
            depsManager: manager,
            cellProcessors: cellProcessors,
            supplementaryViewProcessors: supplementariesProcessors
        )
        
        configuration?(binder)
        
        dataProvider.items.bind(
            to: collectionView,
            using: binder
        ).dispose(in: bag)
    }
    
    func configureDataSource(
        for tableView: UITableView,
        withCellProcessors cellProcessors: [CellProcessor] = [],
        configuration: ((TableBinder<SectionedArrayChangeset>) -> Void)? = nil
    ) {
        tableView.dataSource = nil
        
        guard let manager = itemsDependencyManager else { return }
        
        manager.install(on: tableView)
        
        let binder = TableBinder<SectionedArrayChangeset>(
            depsManager: manager,
            cellProcessors: cellProcessors
        )
        
        configuration?(binder)
        
        dataProvider.items.bind(
            to: tableView,
            using: binder
        ).dispose(in: bag)
    }
}
