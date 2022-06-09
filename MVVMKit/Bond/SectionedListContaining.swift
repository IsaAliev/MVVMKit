//
//  SectionedListContaining.swift
//  Daily
//
//  Created by Isa Aliev on 02.02.2021.
//

import ReactiveKit
import Bond
#if canImport(MVVMKit_Base)
import MVVMKit_Base
#endif

public typealias ReactiveSectionedArray = MutableObservableArray2D<Section.SectionMeta, CollectionItemViewModel>
public typealias SectionedArrayChangeset = TreeChangeset<Array2D<Section.SectionMeta, CollectionItemViewModel>>

public protocol SectionedListContaining {
    var items: ReactiveSectionedArray { get }
}

public extension SectionedListContaining {
    func setSections(_ sections: [Section]) {
        items.value = SectionedArrayChangeset(
            collection: .init(sectionsWithItems: sections.map({ ($0.meta, $0.items) })),
            diff: OrderedCollectionDiff()
        )
    }
}
