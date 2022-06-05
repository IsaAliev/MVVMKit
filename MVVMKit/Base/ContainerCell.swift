//
//  ContainerCell.swift
//  Daily
//
//  Created by Isa Aliev on 11.04.2021.
//

import SnapKit
import UIKit

/**
 Container that is used inside UICollectionView. Must be provided with content view's type and content insets provider type
 */

open class ContainerCell<T: UIView & ViewRepresentable, I: ContentInsetsProvider>:
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
        get { to(CollectionItemsViewDependenciesContainable.self)?.itemsDependencyManager }
        set { to(CollectionItemsViewDependenciesContainable.self)?.itemsDependencyManager = newValue }
    }
    
    open var typeErasedViewModel: ViewModel? {
        set { content.model = (newValue as! T.ViewModelType) }
        get { content.model }
    }
	
	open override var isFirstResponder: Bool {
		content.isFirstResponder
	}
    
    open override var canBecomeFirstResponder: Bool {
        content.canBecomeFirstResponder
    }
    
    open override var canResignFirstResponder: Bool {
        content.canResignFirstResponder
    }
    
	public override var isHighlighted: Bool {
		didSet { to(CellStatesHandling.self)?.isHighlighted = isHighlighted }
	}
	
	public override var isSelected: Bool {
		didSet { to(CellStatesHandling.self)?.isSelected = isSelected }
	}
	
    public var model: NotAModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
	required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func bindWithModel() { }
    
    public func adoptBoundingWidth(_ width: CGFloat) {
        widthConstraint?.update(offset: width)
        widthConstraint?.activate()
    }
	
	open override func becomeFirstResponder() -> Bool {
		content.becomeFirstResponder()
	}
    
    open override func resignFirstResponder() -> Bool {
        content.resignFirstResponder()
    }
    
    private func setupViews() {
        contentView.addSubview(content)
        
		setupContentConstraints { w in
			self.widthConstraint = w
		}
        
        widthConstraint?.deactivate()
        
        to(EmbeddableView.self)?.didEmbedTo(self)
    }
	
	open func setupContentConstraints(_ usingWidthConstraint: (Constraint) -> Void) {
		content.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(I.insets)
			let cons = make.width.equalTo(0.0).constraint
			usingWidthConstraint(cons)
		}
	}
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
		to(ReusableView.self)?.prepareForReuse()
    }
	
	open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
		super.apply(layoutAttributes)
		
		to(AttributesApplyable.self)?.apply(layoutAttributes)
	}
    
    private func to<P>(_ type: P.Type) -> P? {
        content.subviewAdopting(type)
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
        content.snp.remakeConstraints(configurator)
    }
}
