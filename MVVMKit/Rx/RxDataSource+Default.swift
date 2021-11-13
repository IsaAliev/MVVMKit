//
//  RxDataSource+Default.swift
//
//  Created by Isa Aliev on 17.09.2020.
//  Copyright © 2020. All rights reserved.
//

import RxDataSources
import UIKit
import MVVMKit_Base

typealias SectionData = SectionModel<CollectionItemViewModel, CollectionItemViewModel>
typealias AnimatableSectionData = AnimatableSectionModel<IdentifiableCollectionItemViewModel, IdentifiableCollectionItemViewModel>

typealias DefaultAnimatedDataSource = RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionData>
typealias PreReturnHandler<T: SectionModelType> = (
    CollectionViewSectionedDataSource<T>,
    IndexPath,
    UIView
    ) -> Void

extension RxCollectionViewSectionedAnimatedDataSource {
    static func `default`(
        with manager: CollectionItemsViewModelDependencyManager,
        preReturnHandler: PreReturnHandler<AnimatableSectionData>? = nil
    ) -> DefaultAnimatedDataSource {
        
        DefaultAnimatedDataSource (configureCell: {
            (dataSource, collectionView, indexPath, item) -> UICollectionViewCell in
            let identifier = manager.reuseIdentifier(for: item)
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: identifier,
                for: indexPath
            ) as! ViewModelTypeErasedViewRepresentable & UICollectionViewCell
            
            if let dependecyInstallableView = cell as? CollectionItemsViewDependenciesContainable,
               dependecyInstallableView.itemsDependencyManager == nil {
                dependecyInstallableView.itemsDependencyManager = manager
            }
            
            cell.typeErasedViewModel = item
            
            preReturnHandler?(dataSource, indexPath, cell)
            
            return cell
        }, configureSupplementaryView: {
            dataSource, collectionView, kind, indexPath -> UICollectionReusableView in
            let sectionModel = dataSource.sectionModels[indexPath.row].model
            let identifier = manager.reuseIdentifier(for: sectionModel)
            let view = collectionView
                .dequeueReusableSupplementaryView(ofKind: kind,
                                                  withReuseIdentifier: identifier,
                                                  for: indexPath)
            
            (view as? ViewModelTypeErasedViewRepresentable)?.typeErasedViewModel = sectionModel
            
            preReturnHandler?(dataSource, indexPath, view)
            
            return view
        })
    }
}

extension RxCollectionViewSectionedReloadDataSource {
    static func `default`(
        with manager: CollectionItemsViewModelDependencyManager,
        preReturnHandler: PreReturnHandler<SectionData>? = nil
    ) -> RxCollectionViewSectionedReloadDataSource<SectionData> {
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionData>(
            configureCell: { dataSource, collectionView, indexPath, item in
                let identifier = manager.reuseIdentifier(for: item)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ViewModelTypeErasedViewRepresentable & UICollectionViewCell
                
                if let dependecyInstallableView = cell as? CollectionItemsViewDependenciesContainable,
                    dependecyInstallableView.itemsDependencyManager == nil {
                    dependecyInstallableView.itemsDependencyManager = manager
                }
                
                cell.typeErasedViewModel = item
                
                preReturnHandler?(dataSource, indexPath, cell)
                
                return cell
        })
        
        dataSource.configureSupplementaryView = { dataSource, collectionView, kind, indexPath in
            let sectionModel = dataSource.sectionModels[indexPath.section].model
            let identifier = manager.reuseIdentifier(for: sectionModel)
            let view = collectionView
                .dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                  withReuseIdentifier: identifier,
                                                  for: indexPath)
            
            (view as? ViewModelTypeErasedViewRepresentable)?.typeErasedViewModel = sectionModel
            
            preReturnHandler?(dataSource, indexPath, view)
            
            return view
        }
        
        return dataSource
    }
}

extension RxTableViewSectionedReloadDataSource {
    static func `default`(with manager: CollectionItemsViewModelDependencyManager) -> RxTableViewSectionedReloadDataSource<SectionData> {
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionData>(configureCell: { (_, tableView, indexPath, item) -> UITableViewCell in
            let identifier = manager.reuseIdentifier(for: item)
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ViewModelTypeErasedViewRepresentable & UITableViewCell
            cell.typeErasedViewModel = item
            
            return cell
        })
        
        return dataSource
    }
}
