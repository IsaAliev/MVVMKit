//
//  RxDataSourceRepresentableView.swift
//
//  Created by Isa Aliev on 28.09.2020.
//  Copyright © 2020. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import MVVMKit_Base

class EmptyViewModel: IdentifiableCollectionItemViewModel {
    private let explicitId: String?
    override var identity: String { explicitId ?? "null" }
    
    init(id: String? = nil) { explicitId = id }
}

protocol RxDataSourceProvider {
    var collectionData: BehaviorSubject<[SectionData]> { get }
}

protocol RxAnimatableDataSourceProvider {
    var collectionData: BehaviorSubject<[AnimatableSectionData]> { get }
}

protocol RxDataSourceRepresentableView: CollectionItemsViewDependenciesContainable {
    var dataProvider: RxDataSourceProvider! { get }
    var disposeBag: DisposeBag { get }
}

protocol RxAnimatableDataSourceRepresentableView: CollectionItemsViewDependenciesContainable {
    var dataProvider: RxAnimatableDataSourceProvider! { get }
    var disposeBag: DisposeBag { get }
}

extension RxDataSourceRepresentableView {
    func itemModel(at indexPath: IndexPath) -> CollectionItemViewModel? {
        guard let data = try? dataProvider.collectionData.value() else {
            return nil
        }
        
        return data[indexPath.section].items[indexPath.row]
    }
}

extension RxAnimatableDataSourceRepresentableView {
    func configureCollectionDataSource(
        for collectionView: UICollectionView,
        withPreReturnHandler preReturnHandler: PreReturnHandler<AnimatableSectionData>? = nil
    ) {
        collectionView.dataSource = nil
        
        guard let manager = itemsDependencyManager else {
            return
        }
        
        manager.install(on: collectionView)
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionData>
            .default(with: manager, preReturnHandler: preReturnHandler)
        
        dataProvider.collectionData.bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension RxDataSourceRepresentableView {
    func configureCollectionDataSource(
        for collectionView: UICollectionView,
        withPreReturnHandler preReturnHandler: PreReturnHandler<SectionData>? = nil
    ) {
        collectionView.dataSource = nil
        
        guard let manager = itemsDependencyManager else {
            return
        }
        
        manager.install(on: collectionView)
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionData>
            .default(with: manager, preReturnHandler: preReturnHandler)
        
        dataProvider.collectionData.bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension RxDataSourceRepresentableView where Self: UICollectionViewController {
    func configureCollectionDataSource(
        withPreReturnHandler preReturnHandler: PreReturnHandler<SectionData>? = nil
    ) {
        collectionView.dataSource = nil
        
        guard let manager = itemsDependencyManager else {
            return
        }
        
        manager.install(on: collectionView)
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionData>
            .default(with: manager, preReturnHandler: preReturnHandler)
        
        dataProvider.collectionData.bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension RxDataSourceRepresentableView where Self: UITableViewController {
    func configureCollectionDataSource() {
        tableView.dataSource = nil
        
        guard let manager = itemsDependencyManager else {
            return
        }
        
        manager.install(on: tableView)
        let dataSource = RxTableViewSectionedReloadDataSource<SectionData>.default(with: manager)
        
        dataProvider.collectionData
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

