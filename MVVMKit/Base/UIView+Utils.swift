//
//  File.swift
//  
//
//  Created by Isa Aliev on 04.06.2022.
//

import UIKit

public extension UIView {
    func subviewAdopting<P>(_ type: P.Type) -> P? {
        if self as? P != nil { return self as? P }
        
        for subview in subviews {
            if let v = subview.subviewAdopting(type) {
                return v
            }
        }
        
        return nil
    }
}
