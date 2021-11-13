//
//  Observable+Utils.swift
//  MVVMKit
//
//  Created by Isa Aliev on 24.01.2021.
//

import ReactiveKit
import Foundation

public extension SignalProtocol {
    func nextOnMain(_ observer: @escaping (Element) -> Void) -> Disposable {
        receive(on: DispatchQueue.main).observeNext(with: observer)
    }
}
