//
//  RxFlowCoordinator.swift
//
//  Created by Isa Aliev on 30/03/2020.
//  Copyright © 2020. All rights reserved.
//

import RxSwift
import Foundation
#if canImport(MVVMKit_Base)
import MVVMKit_Base
#endif

public protocol RxFlowCoordinator: AnyObject, ViewModelResponder {
    associatedtype CoordinationOutput
    
    var bag: DisposeBag { get }
    var id: UUID { get }
    var children: [UUID: Any] { get set }
    var output: BehaviorSubject<CoordinationOutput?> { get }
    
    func start()
}

private class AbstractFlowCoordinator<T>: RxFlowCoordinator {
    typealias CoordinationOutput = T
    
    var id: UUID {
        fatalError()
    }
    
    var children: [UUID : Any] {
        get {
            fatalError()
        }
        
        set {
            fatalError()
        }
    }
    
    var output: BehaviorSubject<T?> {
        fatalError()
    }
    
    var bag: DisposeBag {
        fatalError()
    }
    
    func setAsNextResponder(_ responder: ViewModelResponder) {
        next?.store(responder)
    }
    
    func start() {
        
    }
}

final private class FlowCoordinatorWrapper<C: RxFlowCoordinator, T>:
    AbstractFlowCoordinator<T>
where
    C.CoordinationOutput == T
{
    let coordinator: C
    
    override var id: UUID {
        coordinator.id
    }
    
    override var bag: DisposeBag {
        coordinator.bag
    }
    
    override var children: [UUID : Any] {
        get {
            coordinator.children
        }
        
        set {
            coordinator.children = newValue
        }
    }
    
    override var output: BehaviorSubject<T?> {
        coordinator.output
    }
    
    public init(_ coordinator: C) {
        self.coordinator = coordinator
    }
    
    override func setAsNextResponder(_ responder: ViewModelResponder) {
        coordinator.setAsNextResponder(responder)
    }
    
    override func start() {
        coordinator.start()
    }
}

final public class AnyRxFlowCoordinator<O>: RxFlowCoordinator {
    public typealias Output = O
    
    private let coordinator: AbstractFlowCoordinator<O>
    public var bag: DisposeBag { coordinator.bag }
    public var id: UUID { coordinator.id }
    public var output: BehaviorSubject<O?> { coordinator.output }
    public var children: [UUID : Any] {
        get {
            coordinator.children
        }
        
        set {
            coordinator.children = newValue
        }
    }
    
    public init<C: RxFlowCoordinator>(_ coordinator: C) where C.CoordinationOutput == O {
        self.coordinator = FlowCoordinatorWrapper(coordinator)
    }
    
    public func start() {
        coordinator.start()
    }
    
    public func setAsNextResponder(_ responder: ViewModelResponder) {
        coordinator.setAsNextResponder(responder)
    }
}

public extension RxFlowCoordinator {
    func store<O>(_ coordinator: AnyRxFlowCoordinator<O>) {
        children[coordinator.id] = coordinator
    }
    
    func release<O>(_ coordinator: AnyRxFlowCoordinator<O>) {
        children[coordinator.id] = nil
    }
    
    @discardableResult
    func coordinate<O>(to coordinator: AnyRxFlowCoordinator<O>) -> Observable<O?> {
        coordinator.setAsNextResponder(self)
        store(coordinator)
        coordinator.start()
        
        return coordinator.output
            .do(onCompleted: { [weak self, weak coordinator]  in
                guard let coordinator = coordinator else { return }
                
                self?.releaseCoordinator(coordinator)
            })
    }
    
    func finishWithOutput(_ output: CoordinationOutput?) {
        self.output.onNext(output)
        self.output.onCompleted()
    }
    
    func childWith(_ id: UUID) -> Any? {
        children[id]
    }
    
    func releaseCoordinator<O>(_ coordinator: AnyRxFlowCoordinator<O>) {
        children[coordinator.id] = nil
    }
    
    func release<T: RxFlowCoordinator>(_ type: T.Type) {
        children[idOfChild(of: type)] = nil
    }
    
    func idOfChild<T: RxFlowCoordinator>(of type: T.Type) -> UUID {
        children.compactMap({ $0.value as? T }).first?.id ?? .init()
    }
    
    func toAnyCoordinator() -> AnyRxFlowCoordinator<CoordinationOutput> {
        AnyRxFlowCoordinator(self)
    }
}
