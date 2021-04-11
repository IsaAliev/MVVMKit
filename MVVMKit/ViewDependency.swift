//
//  ViewDependecy.swift
//
//  Created by Isa Aliev on 18.09.2020.
//  Copyright © 2020. All rights reserved.
//

public struct ViewDependency: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
    
    var nibName: String
    public var identifier: String
    var classType: AnyClass
    var withNib = true
    var isCell = true
    var kind = ""
    public var modelName = ""
    
    public init(stringLiteral value: String) {
        classType = swiftClassFromString(value)!
        identifier = value
        nibName = value
        withNib = false
    }
    
    public init(_ className: String, viewKind: String) {
        isCell = false
        kind = viewKind
        identifier = className
        classType = swiftClassFromString(className)!
        self.identifier = className
        nibName = ""
    }
    
    public init(_ className: String, viewKind: String, for identifier: String) {
        isCell = false
        kind = viewKind
        classType = swiftClassFromString(className)!
        self.identifier = identifier
        nibName = ""
    }
    
    public init(_ id: String, withNib: Bool = true) {
        classType = swiftClassFromString(id)!
        identifier = id
        nibName = id
        self.withNib = withNib
    }
    
    public init(_ className: String, identifier: String) {
        self.init(identifier)
        classType = swiftClassFromString(className)!
    }
    
    public init(_ className: String, identifier: String, nibName: String) {
        classType = swiftClassFromString(className)!
        self.identifier = identifier
        self.nibName = nibName
    }
    
    public init(_ classType: AnyClass, identifier: String) {
        self.classType = classType
        self.identifier = identifier
        self.nibName = ""
        self.withNib = false
    }
    
    public init(_ cellClassName: String, modelName: String) {
        self.modelName = modelName
        self.classType = swiftClassFromString(cellClassName)!
        identifier = cellClassName
        nibName = cellClassName
        withNib = false
    }
}
