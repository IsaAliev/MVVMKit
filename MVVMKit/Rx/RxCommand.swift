//
//  Command.swift
//
//  Created by Isa Aliev on 25.09.2020.
//  Copyright © 2020. All rights reserved.
//

import RxSwift

public protocol RxCommand: class, ObserverType {
    func execute(with element: Element)
}

public extension RxCommand where Element: Any {
    func on(_ event: Event<Element>) {
        guard case let .next(value) = event else {
            return
        }
        
        execute(with: value)
    }
}
