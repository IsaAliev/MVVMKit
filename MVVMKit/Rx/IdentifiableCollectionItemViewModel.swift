//
//  IdentifiableCollectionItemViewModel.swift
//
//  Created by Isa Aliev on 04.12.2020.
//  Copyright © 2020. All rights reserved.
//

import RxDataSources
#if canImport(MVVMKit_Base)
import MVVMKit_Base
#endif

class IdentifiableCollectionItemViewModel: CollectionItemViewModel, IdentifiableType, Equatable {
    var equalityMeasures: [AnyHashable] { [identity] }
    
    static func == (
        lhs: IdentifiableCollectionItemViewModel,
        rhs: IdentifiableCollectionItemViewModel
    ) -> Bool {
        var lHasher = Hasher()
        var rHasher = Hasher()
        
        lhs.equalityMeasures.forEach({ lHasher.combine($0) })
        rhs.equalityMeasures.forEach({ rHasher.combine($0) })
        
        return lHasher.finalize() == rHasher.finalize()
    }
    
    var identity: String { "" }
}
