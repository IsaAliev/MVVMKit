//
//  StrictCollectionItemsDependencyManager.swift
//
//  Created by Isa Aliev on 28.09.2020.
//  Copyright © 2020. All rights reserved.
//

import UIKit

/**
 Concrete implementation of CollectionItemsViewModelDependencyManager that assumes that view-viewModel convention is respected or modelName property of ViewDependency is set for unusual naming.
 */

public struct StrictCollectionItemsDependencyManager: CollectionItemsViewModelDependencyManager {
    public let dependencies: [ViewDependency]
    
    public init(_ dependencies: [ViewDependency]) {
        self.dependencies = dependencies
    }
    
    public func resolveIdentifier(forModelTypeUsingUnusualNaming fullTypeName: String) -> String {
        dependencies.filter({ $0.modelName == fullTypeName }).first?.identifier ?? ""
    }
}

