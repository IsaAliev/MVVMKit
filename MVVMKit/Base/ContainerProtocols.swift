//
//  File.swift
//  
//
//  Created by Isa Aliev on 04.06.2022.
//

import UIKit
import SnapKit

/**
 A protocol that describes a view that can be embedded into another view
 */

public protocol EmbeddableView: UIView {
    /**
        Container will call this when it adds the view as its subview
     */
    func didEmbedTo(_ parent: UIView)
}

/**
 A protocol that describes a view that can be reused
 */

public protocol ReusableView {
    /**
     Container cell calls this method in its prepareForReuse implementation
     */
    func prepareForReuse()
}

/**
 A protocol that describes a view that can adopt width constraints
 */

public protocol BoundingWidthAdoptable {
    func adoptBoundingWidth(_ width: CGFloat)
}

/**
 A protocol that describes a view that is embedded in either UICollectionView or other UICollectionReusableView and wants to apply UICollectionViewLayoutAttributes layout attributes
 */

public protocol AttributesApplyable {
    func apply(_ layoutAttributes: UICollectionViewLayoutAttributes)
}

/**
 A protocol that describes a view that is embedded in either UITableViewCell or UICollectionViewCell and wants to handle its container states
 */

public protocol CellStatesHandling: AnyObject {
    var isHighlighted: Bool { get set }
    var isSelected: Bool { get set }
    
    func setSelected(_ selected: Bool, animated: Bool)
    func setHighlighted(_ highlighted: Bool, animated: Bool)
}

public extension CellStatesHandling {
    func setSelected(_ selected: Bool, animated: Bool) { }
    func setHighlighted(_ highlighted: Bool, animated: Bool) { }
}

/**
 A protocol that describes a view which layout can be configured outside it
 */

public protocol ContentConstraintsConfigurable {
    func makeContentPinToEdges()
    func makeContentCenterByY()
    func makeConstraints(_ configurator: (ConstraintMaker) -> Void)
}

/**
 A protocol that must be adopted by the type that can provide insets that is used when content view is embedded inside container
 */

public protocol ContentInsetsProvider {
    static var insets: UIEdgeInsets { get }
}
