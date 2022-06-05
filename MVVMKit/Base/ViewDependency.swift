//
//  ViewDependecy.swift
//
//  Created by Isa Aliev on 18.09.2020.
//  Copyright © 2020. All rights reserved.
//

/**
 Describes dependency between view model and it's ui representation
 
 Instances of this struct are used to make registrations on UITableView/UICollectionView
 */

public struct ViewDependency {
    
    /**
        The name of .nib file of a view
     */
    public var nibName: String?
    
    /**
     Reuse identifier that is used to register a class
     */
    public var identifier: String
    
    /**
     A view class type to be registered
     */
    public var classType: AnyClass
    
    /**
     A view kind. For example, UICollectionView.elementKindSectionHeader
     */
    public var kind: String?
    
    /**
     Explicitly set view model's name. May be useful if view-viewModel naming convention is not respected
     */
    public var modelName: String?
    
    internal var isCell: Bool { kind == nil }
    
    public init(
        _ classType: AnyClass,
        identifier: String,
        nibName: String? = nil,
        viewKind: String? = nil,
        modelName: String? = nil
    ) {
        self.classType = classType
        self.identifier = identifier
        self.nibName = nibName
        self.kind = viewKind
        self.modelName = modelName
    }
}
