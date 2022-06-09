//
//  File.swift
//  
//
//  Created by Isa Aliev on 09.06.2022.
//

import Foundation

public struct Section {
    public struct SectionMeta {
        public let header: CollectionItemViewModel?
        public let footer: CollectionItemViewModel?
        
        public init(
            header: CollectionItemViewModel? = nil,
            footer: CollectionItemViewModel? = nil
        ) {
            self.header = header
            self.footer = footer
        }
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
