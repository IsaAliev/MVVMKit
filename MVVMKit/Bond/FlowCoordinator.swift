//
//  FlowCoordinator.swift
//
//  Created by Isa Aliev on 30/03/2020.
//  Copyright © 2020. All rights reserved.
//

import ReactiveKit
import Bond
import Foundation
#if canImport(MVVMKit_Base)
import MVVMKit_Base
#endif

public protocol FlowCoordinator: ViewModelResponder {
    associatedtype CoordinationOutput
    
    var bag: DisposeBag { get }
    var id: UUID { get }
    var children: [UUID: any FlowCoordinator] { get set }
    var output: Observable<CoordinationOutput?> { get }
    
    func start()
}

public extension FlowCoordinator {
    func store(_ coordinator: any FlowCoordinator) {
        children[coordinator.id] = coordinator
    }
    
    func release(_ coordinator: any FlowCoordinator) {
        children[coordinator.id] = nil
    }
    
    @discardableResult
    func coordinate<F: FlowCoordinator, O>(to coordinator: F) -> SafeSignal<O?> where F.CoordinationOutput == O {
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
    
    func childWith(_ id: UUID) -> (any FlowCoordinator)? {
        children[id]
    }
    
    func releaseCoordinator(_ coordinator: any FlowCoordinator) {
        children[coordinator.id] = nil
    }
    
    func release<T: FlowCoordinator>(_ type: T.Type) {
        guard let id = idOfChild(of: type) else { return }
        
        children[id] = nil
    }
    
    func idOfChild<T: FlowCoordinator>(of type: T.Type) -> UUID? {
        children.compactMap({ $0.value as? T }).first?.id
    }
}
