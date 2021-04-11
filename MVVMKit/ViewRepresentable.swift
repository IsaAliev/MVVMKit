//
//  ViewRepresentable.swift
//
//  Created by Isa Aliev on 17/09/2020.
//  Copyright © 2020. All rights reserved.
//

public protocol ViewRepresentable: ViewModelTypeErasedViewRepresentable {
    associatedtype ViewModelType: ViewModel
    
    var model: ViewModelType! { get set }
    
    func bindWithModel()
}

public protocol ViewModelTypeErasedViewRepresentable: class {
    var typeErasedViewModel: ViewModel? { get set }
}

public extension ViewRepresentable {
    var typeErasedViewModel: ViewModel? {
        get {
            model
        }
        
        set {
            model = (newValue as! Self.ViewModelType)
        }
    }
}

public extension ViewRepresentable {
    func setupViewModel() {
        model?.setup()
        bindWithModel()
    }
}
