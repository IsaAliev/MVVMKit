//
//  SectionedListContaining.swift
//  Daily
//
//  Created by Isa Aliev on 02.02.2021.
//

import ReactiveKit
import Bond
import MVVMKit_Base

public typealias ReactiveSectionedArray = MutableObservableArray2D<Section.SectionMeta, CollectionItemViewModel>
public typealias SectionedArrayChangeset = TreeChangeset<Array2D<Section.SectionMeta, CollectionItemViewModel>>

public struct Section {
	public struct SectionMeta {
		public let header: CollectionItemViewModel?
		public let footer: CollectionItemViewModel?
	}
	
	public let meta: SectionMeta
    public let metadata: CollectionItemViewModel?
    public var items = [CollectionItemViewModel]()
    
    public init(
        metadata: CollectionItemViewModel,
        items: [CollectionItemViewModel] = [CollectionItemViewModel](),
		footer: CollectionItemViewModel? = nil
    ) {
        self.metadata = metadata
        self.items = items
		self.meta = .init(header: metadata, footer: nil)
    }
    
    public init(_ meta: SectionMeta, items: [CollectionItemViewModel] = [CollectionItemViewModel]()) {
        self.meta = meta
		self.items = items
		self.metadata = meta.header
    }
}

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
