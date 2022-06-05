//
//  ViewModel.swift
//
//  Created by Isa Aliev on 17/09/2020.
//  Copyright © 2020. All rights reserved.
//

/**
 A procotol that is adopted by any view model
 */

public protocol ViewModel {
    func setup()
}

public extension ViewModel {
    func setup() {}
}

public class NotAModel: ViewModel { }
