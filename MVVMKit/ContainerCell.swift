//
//  ContainerCell.swift
//  Daily
//
//  Created by Isa Aliev on 11.04.2021.
//

import SnapKit
import UIKit

public protocol BoundingWidthAdoptable {
    func adoptBoundingWidth(_ width: CGFloat)
}

public protocol CellStatesHandling: class {
	var isHighlighted: Bool { get set }
	var isSelected: Bool { get set }
	var selectedBackgroundView: UIView? { get }
}

public extension CellStatesHandling {
	var selectedBackgroundView: UIView? { nil }
}

public protocol ContentConstraintsConfigurable {
    func makeContentPinToEdges()
    func makeContentCenterByY()
    func makeConstraints(_ configurator: (ConstraintMaker) -> Void)
}

public protocol ReusableView {
    func prepareForReuse()
}

public class NotAModel: ViewModel { }

public class ContainerCell<T: UIView & ViewRepresentable>:
    UICollectionViewCell,
    ViewRepresentable,
    BoundingWidthAdoptable,
    CollectionItemsViewDependenciesContainable
{
    private var widthConstraint: Constraint?
    public lazy var content: T = {
        T(frame: .zero)
    }()
    
    public var itemsDependencyManager: CollectionItemsViewModelDependencyManager? {
        get { content.subviewAdopting(CollectionItemsViewDependenciesContainable.self)?.itemsDependencyManager }
        set { content.subviewAdopting(CollectionItemsViewDependenciesContainable.self)?.itemsDependencyManager = newValue }
    }
    
    public var typeErasedViewModel: ViewModel? {
        set { content.model = (newValue as! T.ViewModelType) }
        get { content.model }
    }
    
	public override var isHighlighted: Bool {
		didSet {
			content.subviewAdopting(CellStatesHandling.self)?.isHighlighted = isHighlighted
		}
	}
	
	public override var isSelected: Bool {
		didSet { content.subviewAdopting(CellStatesHandling.self)?.isSelected = isSelected }
	}
	
    public var model: NotAModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func bindWithModel() { }
    
    public func adoptBoundingWidth(_ width: CGFloat) {
        widthConstraint?.update(offset: width)
        widthConstraint?.activate()
    }
    
    private func setupViews() {
		selectedBackgroundView = content.subviewAdopting(CellStatesHandling.self)?.selectedBackgroundView
        contentView.addSubview(content)
        
        content.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            widthConstraint = make.width.equalTo(0.0).constraint
        }
        
        widthConstraint?.deactivate()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
		content.subviewAdopting(ReusableView.self)?.prepareForReuse()
    }
}

extension UIView {
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

extension ContainerCell: ContentConstraintsConfigurable {
    public func makeContentPinToEdges() {
        content.snp.remakeConstraints { make in make.edges.equalToSuperview() }
    }
    
    public func makeContentCenterByY() {
        content.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    public func makeConstraints(_ configurator: (ConstraintMaker) -> Void) {
        contentView.snp.remakeConstraints(configurator)
    }
}
