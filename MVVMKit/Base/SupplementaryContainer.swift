//
//  SupplementaryContainer.swift
//  MVVMKit
//
//  Created by Isa Aliev on 03.05.2021.
//

import SnapKit
import UIKit

/**
 Container that is used inside UICollectionView for supplementary views. Must be provided with content view's type and content insets provider type
 */

open class SupplementaryContainer<T: UIView & ViewRepresentable, I: ContentInsetsProvider>:
    UICollectionReusableView,
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
    
    public var typeErasedViewModel: ViewModel? {
        set { content.model = (newValue as! T.ViewModelType) }
        get { content.model }
    }
    
    public var model: NotAModel!
    
    open override var canBecomeFirstResponder: Bool {
        content.canBecomeFirstResponder
    }
    
    open override var isFirstResponder: Bool {
        content.isFirstResponder
    }
    
    open override var canResignFirstResponder: Bool {
        content.canResignFirstResponder
    }
    
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
    
    private func setupViews() {
        addSubview(content)
        
        setupContentConstraints { w in
			self.widthConstraint = w
		}
        
        widthConstraint?.deactivate()
    }
	
	open override func becomeFirstResponder() -> Bool {
		content.becomeFirstResponder()
	}
    
    open override func resignFirstResponder() -> Bool {
        content.resignFirstResponder()
    }
    
	open func setupContentConstraints(_ usingWidthConstraint: (Constraint) -> Void) {
		content.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(I.insets)
			let cons = make.width.equalTo(0.0).constraint
			usingWidthConstraint(cons)
		}
	}
    
    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        to(AttributesApplyable.self)?.apply(layoutAttributes)
    }
	
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        to(ReusableView.self)?.prepareForReuse()
    }
    
    private func to<P>(_ type: P.Type) -> P? {
        content.subviewAdopting(type)
    }
}
