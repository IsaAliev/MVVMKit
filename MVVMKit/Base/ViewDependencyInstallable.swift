//
//  ViewDependecyInstallable.swift
//
//  Created by Isa Aliev on 18.09.2020.
//  Copyright © 2020. All rights reserved.
//

public protocol CollectionItemsViewDependenciesContainable: AnyObject {
    var itemsDependencyManager: CollectionItemsViewModelDependencyManager? { get set }
}
