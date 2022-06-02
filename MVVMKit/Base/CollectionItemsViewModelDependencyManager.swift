//
//  CollectionItemsViewModelDependencyManager.swift
//
//  Created by Isa Aliev on 26.09.2020.
//  Copyright © 2020. All rights reserved.
//

import Foundation
import UIKit

/**
 A protocol that is adopted to provide binder with proper reuse identifier for a particular view model
 */

public protocol CollectionItemsViewModelDependencyManager {
    /**
        Dependencies that will be installed on UICollectionView/UITableView
     */
    var dependencies: [ViewDependency] { get }
    
    /**
        Default implementation of reuseIdentifier(for:) uses this method providing it with a view model's type's name to resolve reuse identifier for it
        
        Default implementation returns fullTypeName without "Model" suffix adopting View-ViewModel name convention, where View's class name is used as reuse identifier
     */
    func mapModelTypeNameToIdentifier(_ fullTypeName: String) -> String
    
    /**
        This method is directly used by binder to resolve reuse identifier for a view model
     */
    func reuseIdentifier(for model: CollectionItemViewModel) -> String
    
    /**
        Default implementation of mapModelTypeNameToIdentifier(:) uses this method in case there is no "Model" suffix in view model's type's name
     */
    func resolveIdentifier(forModelTypeUsingUnusualNaming fullTypeName: String) -> String
}

public extension CollectionItemsViewModelDependencyManager {
    func reuseIdentifier(for model: CollectionItemViewModel) -> String {
        let typeName = String(describing: type(of: model))
        
        return mapModelTypeNameToIdentifier(typeName)
    }
    
    func mapModelTypeNameToIdentifier(_ fullTypeName: String) -> String {
        guard fullTypeName.hasSuffix("Model"),
            let typeName = fullTypeName.split(separator: ".").last else {
                return resolveIdentifier(forModelTypeUsingUnusualNaming: fullTypeName)
        }
        
        let modelTailTrimmedName = String(typeName).dropLast(5)
        
        return String(modelTailTrimmedName)
    }
}

public extension CollectionItemsViewModelDependencyManager {
    /**
        Installs dependencies for view dependency manager on table view
     */
    func install(on tableView: UITableView) {
        dependencies.forEach({
            guard $0.isCell else {
                tableView.register($0.classType, forHeaderFooterViewReuseIdentifier: $0.identifier)
                return
            }
            
            tableView.register(
                $0.classType,
                forCellReuseIdentifier: $0.identifier
            )
            
            if $0.withNib {
                tableView.register(
                    UINib(nibName: $0.nibName, bundle: nil),
                    forCellReuseIdentifier: $0.identifier
                )
            }
        })
    }
    
    /**
        Installs dependencies for view dependency manager on collection view
     */
    func install(on collectionView: UICollectionView) {
        dependencies.forEach({
            guard $0.isCell else {
                collectionView.register(
                    $0.classType,
                    forSupplementaryViewOfKind: $0.kind,
                    withReuseIdentifier: $0.identifier
                )
                
                return
            }
            
            collectionView.register(
                $0.classType,
                forCellWithReuseIdentifier: $0.identifier
            )
            
            if $0.withNib {
                collectionView.register(
                    UINib(nibName: $0.nibName, bundle: nil),
                    forCellWithReuseIdentifier: $0.identifier
                )
            }
        })
    }
}

