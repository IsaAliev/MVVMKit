//
//  ViewDependecyInstallable.swift
//
//  Created by Isa Aliev on 18.09.2020.
//  Copyright © 2020. All rights reserved.
//

/**
    A protocol that must be adopted if a view wants to use data source binding
 
    Any cell inside list inherits higher-level view's manager
 */

public protocol CollectionItemsViewDependenciesContainable: AnyObject {
    var itemsDependencyManager: CollectionItemsViewModelDependencyManager? { get set }
}
