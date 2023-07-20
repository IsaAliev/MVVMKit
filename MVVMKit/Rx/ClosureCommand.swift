//
//  ClosureCommand.swift
//
//  Created by Isa Aliev on 25.09.2020.
//  Copyright © 2020. All rights reserved.
//

import RxSwift

public class ClosureCommand<T>: RxCommand {
    public typealias Element = T
    
    private var closure: (T) -> Void
    
    public var currentValue: T?
    
    public init(_ closure: @escaping (T) -> Void) {
        self.closure = closure
    }
    
    public func execute(with element: T) {
        currentValue = element
        
        closure(element)
    }
}
