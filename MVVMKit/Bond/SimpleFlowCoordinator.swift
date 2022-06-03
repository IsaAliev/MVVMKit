//
//  SimpleFlowCoordinator.swift
//
//  Created by Isa Aliev on 13.06.2020.
//  Copyright © 2020. All rights reserved.
//

import ReactiveKit
import Bond
import Foundation
#if canImport(MVVMKit_Base)
import MVVMKit_Base
#endif

open class SimpleFlowCoordinator<O>: FlowCoordinator {
    public typealias CoordinationOutput = O
    
    public let bag = DisposeBag()
    public let id = UUID()
    public var children = [UUID : Any]()
    public let output = Observable<O?>(nil)
    
    public init() { }
    
    open func start() {
        
    }
}
