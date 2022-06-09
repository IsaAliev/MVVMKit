//
//  File.swift
//  
//
//  Created by Isa Aliev on 09.06.2022.
//

import RxSwift
import RxCocoa
#if canImport(MVVMKit_Base)
import MVVMKit_Base
#endif

public typealias RxMutableObservableArray2D<SectionMetadata, Item> = BehaviorSubject<TreeChangeset<Array2D<SectionMetadata, Item>>>

public typealias ReactiveSectionedArray = RxMutableObservableArray2D<Section.SectionMeta, CollectionItemViewModel>
public typealias SectionedArrayDriver = Driver<TreeChangeset<Array2D<Section.SectionMeta, CollectionItemViewModel>>>
public typealias SectionedArrayChangeset = TreeChangeset<Array2D<Section.SectionMeta, CollectionItemViewModel>>

public protocol RxSectionedListContaining {
    var items: ReactiveSectionedArray { get }
}

public extension RxSectionedListContaining {
    var itemsDriver: SectionedArrayDriver {
        items.asDriver(onErrorJustReturn: .init(collection: .init(), diff: .init()))
    }
}

public extension RxSectionedListContaining {
    func setSections(_ sections: [Section]) {
        items.on(.next(
            SectionedArrayChangeset(
                collection: .init(sectionsWithItems: sections.map({ ($0.meta, $0.items) })),
                diff: OrderedCollectionDiff()
            )
        ))
    }
}
