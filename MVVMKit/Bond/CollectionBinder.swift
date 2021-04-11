//
//  CollectionBinder.swift
//
//  Created by Isa Aliev on 28/10/2019.
//  Copyright © 2019. All rights reserved.
//

import Bond
import UIKit

public protocol CellProcessor {
    func processCell(_ cell: UIView, at path: IndexPath)
}

public protocol SupplementaryViewProcessor {
    func processSupplementaryView(_ view: UICollectionReusableView, at path: IndexPath)
}

public class CollectionBinder<ChangeSet: SectionedDataSourceChangeset>:
    CollectionViewBinderDataSource<ChangeSet>
where ChangeSet.Collection == Array2D<CollectionItemViewModel, CollectionItemViewModel>
{
    private let cellProcessors: [CellProcessor]
    private let supplementaryViewProcessors: [SupplementaryViewProcessor]
    private let depsManager: CollectionItemsViewModelDependencyManager
    
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
    
    public override func collectionView(
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
        
        if var dependecyInstallableView = cell as? CollectionItemsViewDependenciesContainable,
           dependecyInstallableView.itemsDependencyManager == nil {
            dependecyInstallableView.itemsDependencyManager = depsManager
        }
        
        cell.typeErasedViewModel = model
        cellProcessors.forEach({ $0.processCell(cell, at: indexPath) })
        
        return cell
    }
    
    @objc (collectionView:viewForSupplementaryElementOfKind:atIndexPath:)
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        
        guard let headerModel = changeset?.collection.sections[indexPath.section].metadata else {
            return UICollectionReusableView()
        }
        
        let identifier = depsManager.reuseIdentifier(for: headerModel)
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: identifier,
            for: indexPath
        )
        
        (view as? ViewModelTypeErasedViewRepresentable)?.typeErasedViewModel = headerModel
        supplementaryViewProcessors.forEach({ $0.processSupplementaryView(view, at: indexPath) })
        
        return view
    }
}
