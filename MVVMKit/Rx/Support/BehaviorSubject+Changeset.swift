//
//  File.swift
//  
//
//  Created by Isa Aliev on 09.06.2022.
//

import RxSwift
import RxCocoa
import Foundation

extension BehaviorSubject: ChangesetContainerProtocol, MutableChangesetContainerProtocol where Element: ChangesetProtocol {
    public typealias Changeset = Element
    
    public var changeset: Changeset {
        get {
            try! value()
        }
        set {
            on(.next(newValue))
        }
    }
    
    public func batchUpdate(_ update: (BehaviorSubject<Element>) -> Void) {
        let lock = NSRecursiveLock(name: "Property.CollectionChangeset.batchUpdate")
        
        guard let val = try? value() else { return }
        
        lock.lock()
        let proxy = BehaviorSubject(value: val) // use proxy to collect changes
        var patche: [Changeset.Operation] = []
        let disposable = proxy.skip(1).subscribe(onNext: { event in
            patche.append(contentsOf: event.patch)
        })
        update(proxy)
        disposable.dispose()
        
        guard let val = try? proxy.value() else { lock.unlock(); return }
        
        on(.next(Changeset(collection: val.collection, patch: patche)))
        
        lock.unlock()
    }
}

public extension BehaviorSubject where Element: ChangesetProtocol {

    convenience init(_ collection: Element.Collection) {
        self.init(value: Element(collection: collection, patch: []))
    }
}
