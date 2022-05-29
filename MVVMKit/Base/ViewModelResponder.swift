//
//  ViewModelResponder.swift
//  Calendar
//
//  Created by Isa Aliev on 30/03/2020.
//  Copyright © 2020 IA. All rights reserved.
//

import Foundation

public protocol ViewModelResponder {
    var next: Storage<ViewModelResponder>? { get set }
    
    func setAsNextResponder(_ responder: ViewModelResponder)
}

fileprivate struct AssociatedKey {
    static var kNext = "kNext"
}

public extension ViewModelResponder {
    var next: Storage<ViewModelResponder>? {
        get {
            objc_getAssociatedObject(self, &AssociatedKey.kNext) as? Storage<ViewModelResponder>
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKey.kNext, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
	
	func createVM<T: ViewModel>(_ creation: () -> T) -> T {
		let vm = creation()
		vm.setAsNextResponder(self)
		
		return vm
	}
}

public extension ViewModelResponder {
    func first<T>(of type: T.Type) -> T? {
        var parent = next
        
        while true {
            if parent == nil {
                break
            }
            
            if let target = parent as? T {
                return target
            }
            
            parent = (parent?.obj as? ViewModelResponder)?.next
        }
        
        return nil
    }
}

public class Storage<T> {
    private(set) var obj: T
    
    public init(_ obj: T) {
        self.obj = obj
    }
    
    public func store(_ obj: T) {
        self.obj = obj
    }
}
