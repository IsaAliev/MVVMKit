//
//  ContainerTableCell.swift
//  Daily
//
//  Created by Isa Aliev on 11.04.2021.
//

import SnapKit
import UIKit

/**
 Container that is used inside UITableView. Must be provided with content view's type and content insets provider type
 */

open class ContainerTableCell<T: UIView & ViewRepresentable, I: ContentInsetsProvider>:
    UITableViewCell,
    ViewRepresentable,
    CollectionItemsViewDependenciesContainable
{
    public lazy var content: T = {
        T(frame: .zero)
    }()
    
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
    
    public var typeErasedViewModel: ViewModel? {
        set { content.model = (newValue as! T.ViewModelType) }
        get { content.model }
    }
    
    public var itemsDependencyManager: CollectionItemsViewModelDependencyManager? {
        get { to(CollectionItemsViewDependenciesContainable.self)?.itemsDependencyManager }
        set { to(CollectionItemsViewDependenciesContainable.self)?.itemsDependencyManager = newValue }
    }
    
    public var model: NotAModel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func bindWithModel() { }
    
    open func setupViews() {
        contentView.addSubview(content)
        
        content.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(I.insets)
        }
        
        to(EmbeddableView.self)?.didEmbedTo(self)
    }
    
    public override func becomeFirstResponder() -> Bool {
        content.becomeFirstResponder()
    }
    
    public override func resignFirstResponder() -> Bool {
        content.resignFirstResponder()
    }
    
    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        to(CellStatesHandling.self)?.setSelected(selected, animated: animated)
    }

    open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

        to(CellStatesHandling.self)?.setHighlighted(highlighted, animated: animated)
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        to(ReusableView.self)?.prepareForReuse()
    }
    
    private func to<P>(_ type: P.Type) -> P? {
        content.subviewAdopting(type)
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
        content.snp.remakeConstraints(configurator)
    }
}
