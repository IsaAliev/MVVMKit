//
//  SectionedListContaining.swift
//  Daily
//
//  Created by Isa Aliev on 02.02.2021.
//

import ReactiveKit
import Bond

public typealias ReactiveSectionedArray = MutableObservableArray2D<CollectionItemViewModel, CollectionItemViewModel>
public typealias SectionedArrayChangeset = TreeChangeset<Array2D<CollectionItemViewModel, CollectionItemViewModel>>

public struct Section {
    public let metadata: CollectionItemViewModel
    public var items = [CollectionItemViewModel]()
    
    public init(
        metadata: CollectionItemViewModel,
        items: [CollectionItemViewModel] = [CollectionItemViewModel]()
    ) {
        self.metadata = metadata
        self.items = items
    }
    
    public init(_ metadata: CollectionItemViewModel) {
        self.metadata = metadata
    }
}

public protocol SectionedListContaining {
    var items: ReactiveSectionedArray { get }
}

public extension SectionedListContaining {
    func setSections(_ sections: [Section]) {
        items.value = SectionedArrayChangeset(
            collection: .init(sectionsWithItems: sections.map({ ($0.metadata, $0.items) })),
            diff: OrderedCollectionDiff()
        )
    }
}
