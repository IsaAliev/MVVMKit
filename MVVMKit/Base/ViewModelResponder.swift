//
//  ViewModelResponder.swift
//  Calendar
//
//  Created by Isa Aliev on 30/03/2020.
//  Copyright © 2020 IA. All rights reserved.
//

import Foundation

/**
 A protocol that is adopted by ViewModel or Coordinator if there is a need to create responder chain
 */

public protocol ViewModelResponder: AnyObject {
    var next: ViewModelResponder? { get set }
    
    func setAsNextResponder(_ responder: ViewModelResponder)
}

fileprivate struct AssociatedKey {
    static var kNext = "kNext"
}

class WeakObjectContainer<A: AnyObject>: NSObject {
    weak var obj: A?
}

public extension ViewModelResponder {
    var next: ViewModelResponder? {
        get {
            (objc_getAssociatedObject(self, &AssociatedKey.kNext) as? WeakObjectContainer<Self>)?.obj
        }
        
        set {
            let c = WeakObjectContainer<Self>()
            c.obj = newValue as? Self
            
            objc_setAssociatedObject(self, &AssociatedKey.kNext, c, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
	
    /**
     Creates a ViewModel and sets caller to be its next responder
     */
	func createVM<T: ViewModelResponder>(_ creation: () -> T) -> T {
		let vm = creation()
		vm.setAsNextResponder(self)
		
		return vm
	}
    
    func setAsNextResponder(_ responder: ViewModelResponder) {
        next = responder
    }
}

public extension ViewModelResponder {
    /**
        Finds first responder in chain that conforms to type
     */
    func first<T>(of type: T.Type) -> T? {
        var parent = next
        
        while true {
            if parent == nil {
                break
            }
            
            if let target = parent as? T {
                return target
            }
            
            parent = parent?.next
        }
        
        return nil
    }
}
