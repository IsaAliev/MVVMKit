//
//  Command.swift
//
//  Created by Aliev Isa on 05/11/2019.
//  Copyright © 2019. All rights reserved.
//

import ReactiveKit

public protocol Command: AnyObject, BindableProtocol {
    func execute(with element: Element)
}

public extension Command where Element: Any {
    func bind(signal: Signal<Element, Never>) -> Disposable {
        return signal.observeNext { [weak self] e in
            self?.execute(with: (e))
        }
    }
}
