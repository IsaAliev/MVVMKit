//
//  CollectionItemViewModel.swift
//
//  Created by Isa Aliev on 17/09/2020.
//  Copyright © 2020. All rights reserved.
//

public protocol CollectionItemViewModel: ViewModel {
    var identityIdentifier: Any? { get }
}

public extension CollectionItemViewModel {
    var identityIdentifier: Any? { nil }
}
