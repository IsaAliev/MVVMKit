//
//  BaseFlowCoordinator.swift
//
//  Created by Isa Aliev on 13.06.2020.
//  Copyright © 2020. All rights reserved.
//

import RxSwift
import Foundation
#if canImport(MVVMKit_Base)
import MVVMKit_Base
#endif

open class BaseFlowCoordinator<O>: FlowCoordinator {
    public typealias CoordinationOutput = O
    
    public let bag = DisposeBag()
    public let id = UUID()
    public var children = [UUID : any FlowCoordinator]()
    public let output = PublishSubject<O?>()
    
    public init() { }
    
    open func start() {
        
    }
}
