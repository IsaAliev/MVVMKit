//
//  ViewModelResponder.swift
//  Calendar
//
//  Created by Isa Aliev on 30/03/2020.
//  Copyright © 2020 IA. All rights reserved.
//

import Foundation

public protocol ViewModelResponder: AnyObject {
    var next: ViewModelResponder? { get set }
    
    func setAsNextResponder(_ responder: ViewModelResponder)
}

fileprivate struct AssociatedKey {
    static var kNext = "kNext"
}

public extension ViewModelResponder {
    var next: ViewModelResponder? {
        get {
            objc_getAssociatedObject(self, &AssociatedKey.kNext) as? ViewModelResponder
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
            
            parent = parent?.next
        }
        
        return nil
    }
}
