//
//  RxDataSourceRepresentableView.swift
//
//  Created by Isa Aliev on 28.09.2020.
//  Copyright © 2020. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
#if canImport(MVVMKit_Base)
import MVVMKit_Base
#endif

class EmptyViewModel: IdentifiableCollectionItemViewModel {
    private let explicitId: String?
    override var identity: String { explicitId ?? "null" }
    
    init(id: String? = nil) { explicitId = id }
}

public protocol RxDataSourceRepresentableView: CollectionItemsViewDependenciesContainable {
    var dataProvider: RxSectionedListContaining! { get }
    var disposeBag: DisposeBag { get }
}

public extension RxDataSourceRepresentableView {
    func itemModel(at indexPath: IndexPath) -> CollectionItemViewModel {
        return dataProvider.items.collection.item(at: indexPath)
    }
}

extension RxDataSourceRepresentableView {
    public func configureDataSource(
        for tableView: UITableView,
        withCellProcessors cellProcessors: [CellProcessor] = [],
        rowReloadAnimation: UITableView.RowAnimation = .fade,
        rowDeletionAnimation: UITableView.RowAnimation = .fade,
        rowInsertionAnimation: UITableView.RowAnimation = .fade
    ) {
        tableView.dataSource = nil
        
        guard let manager = itemsDependencyManager else { return }
        
        manager.install(on: tableView)
        
        dataProvider.itemsDriver
            .drive(
                tableView.rx.items(
                    dataSource: RxTableViewDataSource(
                        depsManager: manager,
                        cellProcessors: cellProcessors,
                        rowReloadAnimation: rowReloadAnimation,
                        rowDeletionAnimation: rowDeletionAnimation,
                        rowInsertionAnimation: rowInsertionAnimation
                    )
                )
            )
            .disposed(by: disposeBag)
    }
    
    public func configureDataSource(
        for collectionView: UICollectionView,
        withCellProcessors cellProcessors: [CellProcessor] = [],
        andSupplementaryViewProcessors supplementariesProcessors: [SupplementaryViewProcessor] = [],
        configuration: ((RxCollectionViewDataSource<SectionedArrayChangeset>) -> Void)? = nil
    ) {
        collectionView.dataSource = nil
        
        guard let manager = itemsDependencyManager else { return }
        
        manager.install(on: collectionView)
        
        let dataSource = RxCollectionViewDataSource<SectionedArrayChangeset>(
            depsManager: manager,
            cellProcessors: cellProcessors,
            supplementaryViewProcessors: supplementariesProcessors
        )
        
        configuration?(dataSource)
        
        dataProvider.itemsDriver.drive(collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
}
