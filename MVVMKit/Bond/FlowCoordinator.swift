//
//  FlowCoordinator.swift
//
//  Created by Isa Aliev on 30/03/2020.
//  Copyright © 2020. All rights reserved.
//

import ReactiveKit
import Bond
import Foundation
import MVVMKit_Base

public protocol FlowCoordinator: ViewModelResponder {
    associatedtype CoordinationOutput
    
    var bag: DisposeBag { get }
    var id: UUID { get }
    var children: [UUID: Any] { get set }
    var output: Observable<CoordinationOutput?> { get }
    
    func start()
}

private class AbstractFlowCoordinator<T>: FlowCoordinator {
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
    
    var output: Observable<T?> {
        fatalError()
    }
    
    var bag: DisposeBag {
        fatalError()
    }
    
    func setAsNextResponder(_ responder: ViewModelResponder) {
        next = responder
    }
    
    func start() {
        
    }
}

final private class FlowCoordinatorWrapper<C: FlowCoordinator, T>:
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
    
    override var output: Observable<T?> {
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

final public class AnyFlowCoordinator<O>: FlowCoordinator {
    public typealias Output = O
    
    private let coordinator: AbstractFlowCoordinator<O>
    public var bag: DisposeBag { coordinator.bag }
    public var id: UUID { coordinator.id }
    public var output: Observable<O?> { coordinator.output }
    public var children: [UUID : Any] {
        get {
            coordinator.children
        }
        
        set {
            coordinator.children = newValue
        }
    }
    
    public init<C: FlowCoordinator>(_ coordinator: C) where C.CoordinationOutput == O {
        self.coordinator = FlowCoordinatorWrapper(coordinator)
    }
    
    public func start() {
        coordinator.start()
    }
    
    public func setAsNextResponder(_ responder: ViewModelResponder) {
        coordinator.setAsNextResponder(responder)
    }
}

public extension FlowCoordinator {
    func store<O>(_ coordinator: AnyFlowCoordinator<O>) {
        children[coordinator.id] = coordinator
    }
    
    func release<O>(_ coordinator: AnyFlowCoordinator<O>) {
        children[coordinator.id] = nil
    }
    
    @discardableResult
    func coordinate<O>(to coordinator: AnyFlowCoordinator<O>) -> SafeSignal<O?> {
        coordinator.setAsNextResponder(self)
        store(coordinator)
        coordinator.start()
        
        return coordinator.output
            .handleEvents(receiveCompletion: { [weak self, weak coordinator] _ in
                guard let coordinator = coordinator else { return }
                
                self?.releaseCoordinator(coordinator)
            })
    }
    
    func finishWithOutput(_ output: CoordinationOutput?) {
        self.output.send(output)
        self.output.send(completion: .finished)
    }
    
    func childWith(_ id: UUID) -> Any? {
        children[id]
    }
    
    func releaseCoordinator<O>(_ coordinator: AnyFlowCoordinator<O>) {
        children[coordinator.id] = nil
    }
    
    func release<T: FlowCoordinator>(_ type: T.Type) {
        children[idOfChild(of: type)] = nil
    }
    
    func idOfChild<T: FlowCoordinator>(of type: T.Type) -> UUID {
        children.compactMap({ $0.value as? T }).first?.id ?? .init()
    }
    
    func toAnyCoordinator() -> AnyFlowCoordinator<CoordinationOutput> {
        AnyFlowCoordinator(self)
    }
}
