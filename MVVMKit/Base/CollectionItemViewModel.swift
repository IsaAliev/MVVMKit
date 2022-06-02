//
//  CollectionItemViewModel.swift
//
//  Created by Isa Aliev on 17/09/2020.
//  Copyright © 2020. All rights reserved.
//

/**
 Protocol that is adopted by a view model to be used in UICollectionView/UITableView data bindings
 */
public protocol CollectionItemViewModel: ViewModel {
    
    /**
     Identifier that can be used by client application to identify view model
     
     Default implementation returns nil
     */
    var identityIdentifier: Any? { get }
}

public extension CollectionItemViewModel {
    var identityIdentifier: Any? { nil }
}
