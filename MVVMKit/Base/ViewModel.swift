//
//  ViewModel.swift
//
//  Created by Isa Aliev on 17/09/2020.
//  Copyright © 2020. All rights reserved.
//

public protocol ViewModel: ViewModelResponder {
    func setup()
}

public extension ViewModel {
    func setup() {}
	
    func setAsNextResponder(_ responder: ViewModelResponder) {
        next?.store(responder)
	}
}
