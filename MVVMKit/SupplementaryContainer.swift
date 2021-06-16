//
//  SupplementaryContainer.swift
//  MVVMKit
//
//  Created by Isa Aliev on 03.05.2021.
//

import SnapKit
import UIKit

open class SupplementaryContainer<T: UIView & ViewRepresentable>:
    UICollectionReusableView,
    ViewRepresentable,
    BoundingWidthAdoptable
{
    private var widthConstraint: Constraint?
    public lazy var content: T = {
        T(frame: .zero)
    }()
    
    public var typeErasedViewModel: ViewModel? {
        set { content.model = (newValue as! T.ViewModelType) }
        get { content.model }
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
    
    private func setupViews() {
        addSubview(content)
        
        setupContentConstraints()
        
        widthConstraint?.deactivate()
    }
    
	open func setupContentConstraints() {
		content.snp.makeConstraints { make in
			make.edges.equalToSuperview()
			widthConstraint = make.width.equalTo(0.0).constraint
		}
	}
	
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        (content as? ReusableView)?.prepareForReuse()
    }
}
