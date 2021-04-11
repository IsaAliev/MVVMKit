//
//  BlockActionCommand.swift
//
//  Created by Aliev Isa on 08/11/2019.
//  Copyright © 2019. All rights reserved.
//

import ReactiveKit

public class BlockActionCommand<T>: Command {
    typealias Error = Never
    public typealias Element = T
    
    private var block: (T) -> ()
    public var currentValue: T?
    
    public init(_ block: @escaping (T) -> ()) {
        self.block = block
    }
    
    public func execute(with element: T) {
        currentValue = element
        
        block(element)
    }
}
