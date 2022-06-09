//
//  File.swift
//  
//
//  Created by Isa Aliev on 09.06.2022.
//

import UIKit

public protocol CellProcessor {
    func processCell(_ cell: UIView, at path: IndexPath)
}

public protocol SupplementaryViewProcessor {
    func processSupplementaryView(_ view: UICollectionReusableView, at path: IndexPath)
}
