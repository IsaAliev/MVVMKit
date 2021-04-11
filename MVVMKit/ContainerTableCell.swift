//
//  ContainerTableCell.swift
//  Daily
//
//  Created by Isa Aliev on 11.04.2021.
//

import SnapKit
import UIKit

class ContainerTableCell<T: UIView & ViewRepresentable>:
    UITableViewCell,
    ViewRepresentable,
    BoundingWidthAdoptable
{
    private var widthConstraint: Constraint?
    private lazy var content: T = {
        T(frame: .zero)
    }()
    
    var typeErasedViewModel: ViewModel? {
        set { content.model = (newValue as! T.ViewModelType) }
        get { content.model }
    }
    
    var model: NotAModel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindWithModel() { }
    
    func adoptBoundingWidth(_ width: CGFloat) {
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
}

extension ContainerTableCell: ContentConstraintsConfigurable {
    func makeContentPinToEdges() {
        content.snp.remakeConstraints { make in make.edges.equalToSuperview() }
    }
    
    func makeContentCenterByY() {
        content.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func makeConstraints(_ configurator: (ConstraintMaker) -> Void) {
        contentView.snp.remakeConstraints(configurator)
    }
}
