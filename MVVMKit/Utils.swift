//
//  Utils.swift
//
//  Created by Isa Aliev on 26.09.2020.
//  Copyright © 2020. All rights reserved.
//

import Foundation

public let executableName = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String

public func swiftClassFromString(_ className: String) -> AnyClass? {
    let moduleName = executableName.replacingOccurrences(of: " ", with: "_")
    
    return NSClassFromString(moduleName + "." + className)
}

public func stringFromSwiftType(_ swiftType: Any) -> String {
    return String(describing: type(of: swiftType)).components(separatedBy: ".").last!
}

public func weakify<T: AnyObject>(_ target: T, _ f: @escaping (T) -> () -> Void) -> (() -> Void) {
    return { [weak target] in
        guard let target = target else { return }
        
        f(target)()
    }
}

public func weakify<T: AnyObject, A>(_ target: T, _ f: @escaping (T) -> (A) -> Void) -> ((A) -> Void) {
    return { [weak target] a in
        guard let target = target else { return }
        
        f(target)(a)
    }
}
