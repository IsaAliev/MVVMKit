//
//  ContainerTableCell.swift
//  Daily
//
//  Created by Isa Aliev on 11.04.2021.
//

import SnapKit
import UIKit

public class ContainerTableCell<T: UIView & ViewRepresentable>:
    UITableViewCell,
    ViewRepresentable,
    BoundingWidthAdoptable,
    CollectionItemsViewDependenciesContainable
{
    private var widthConstraint: Constraint?
    public lazy var content: T = {
        T(frame: .zero)
    }()
    
    public var typeErasedViewModel: ViewModel? {
        set { content.model = (newValue as! T.ViewModelType) }
        get { content.model }
    }
    
    public var itemsDependencyManager: CollectionItemsViewModelDependencyManager? {
        get { content.subviewAdopting(CollectionItemsViewDependenciesContainable.self)?.itemsDependencyManager }
        set { content.subviewAdopting(CollectionItemsViewDependenciesContainable.self)?.itemsDependencyManager = newValue }
    }
    
    public var model: NotAModel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
        contentView.addSubview(content)
        
        content.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            widthConstraint = make.width.equalTo(0.0).constraint
        }
        
        widthConstraint?.deactivate()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        (content as? ReusableView)?.prepareForReuse()
    }
}

extension ContainerTableCell: ContentConstraintsConfigurable {
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
