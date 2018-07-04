//
//  PagingView.swift
//  ios-custom-paging
//
//  Created by Stefan A on 08/05/2018.
//  Copyright © 2018 Stefan A. All rights reserved.
//

import Foundation
import UIKit

public protocol PagingViewTheme {
    var font: UIFont { get }
    var textColor: UIColor { get }
    var selectedTextColor: UIColor { get }
    var indicatorColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var selectionBarViewHeight: CGFloat { get }
    var totalHeight: CGFloat { get }
}

public struct DefaultPagingViewTheme: PagingViewTheme {
    public var font: UIFont = UIFont.boldSystemFont(ofSize: 12)
    public var textColor: UIColor = .black
    public var selectedTextColor: UIColor = .gray
    public var indicatorColor: UIColor = .black
    public var backgroundColor: UIColor = .white
    public var selectionBarViewHeight: CGFloat = 2
    public var totalHeight: CGFloat = 44
    
    public init() {
        
    }
}

public protocol PagingViewDelegate: class {
    func pagingView(_ pagingView: PagingView, didSelectIndex selectedIndex: Int, animated: Bool, completion: (() -> Void)?)
}

open class PagingView: UIView {
    
    // MARK: - Delegate
    
    public weak var delegate: PagingViewDelegate?
    
    // MARK: - Properties
    
    var handlesViewControllers: Bool = false
    var selectedIndex: Int?
    
    // MARK: - Internal
    
    private var theme: PagingViewTheme
    
    // MARK: - Views
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let selectionView: UIView = {
        let selectionView = UIView()
        return selectionView
    }()
    
    private var buttons: [UIButton] {
        return titles.map {
            let index = titles.index(of: $0)
            let button = UIButton()
            button.titleLabel?.font = theme.font
            button.setTitleColor(index == selectedIndex ? theme.selectedTextColor : theme.textColor, for: .normal)
            button.setTitle($0, for: .normal)
            button.addTarget(self, action: #selector(triggerAction(_:)), for: .touchUpInside)
            return button
        }
    }
    
    // MARK: - Internals
    
    private var titles: [String]
    
    // MARK: - Init
    
    public init(titles: [String], theme: PagingViewTheme = DefaultPagingViewTheme()) {
        self.titles = titles
        self.theme = theme
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View flow
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        reloadConstraintsIfNeeded()
        setSelectedIndex(selectedIndex, animated: false)
    }
    
    // MARK: - UI
    
    private func setupUI() {
        addStackView()
        addTitleButtons()
        addSelectionView()
        setSelectedIndex(selectedIndex, animated: false)
        
        backgroundColor = theme.backgroundColor
    }
    
    private func addStackView() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutIfNeeded()
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    private func addTitleButtons() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        buttons.forEach { stackView.addArrangedSubview($0) }
    }
    
    private func addSelectionView() {
        addSubview(selectionView)
        selectionView.backgroundColor = theme.indicatorColor
        selectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            selectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            selectionView.heightAnchor.constraint(equalToConstant: theme.selectionBarViewHeight)
            ])
    }
    
    private func reloadConstraintsIfNeeded() {
        let width = bounds.width/CGFloat(titles.count)
        
        selectionView.removeConstraint(with: "width_select")
        self.removeConstraint(with: "leading_select")
        
        let leadingConstraint = selectionView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor)
        leadingConstraint.constant = width * CGFloat(selectedIndex ?? 0)
        leadingConstraint.identifier = "leading_select"
        leadingConstraint.isActive = true
        
        let widthConstraint = selectionView.widthAnchor.constraint(equalToConstant: width)
        widthConstraint.identifier = "width_select"
        widthConstraint.isActive = true
    }
    
    private func setTextColor(for button: UIButton?) {
        stackView.arrangedSubviews.forEach {
            guard let button = $0 as? UIButton else { return }
            button.setTitleColor(theme.textColor, for: .normal)
        }
        button?.setTitleColor(theme.selectedTextColor, for: .normal)
    }
    
    // MARK: - Animation
    
    private func setSelectionViewContentOffset(x: CGFloat, animated: Bool) {
        guard !handlesViewControllers else { return }
        guard animated else {
            selectionView.center.x = x
            return
        }
        
        UIView.animate(withDuration: 0.25) {
            self.selectionView.center.x = x
        }
    }
    
    // MARK: - Index
    
    func setSelectedIndex(_ index: Int?, animated: Bool) {
        guard
            let selectedIndex = index,
            selectedIndex != self.selectedIndex else { return }
        
        setTextColor(for: stackView.arrangedSubviews[selectedIndex] as? UIButton)
        delegate?.pagingView(self, didSelectIndex: selectedIndex, animated: animated) {
            self.selectedIndex = index
        }
    }
    
    // MARK: - Actions
    
    @objc private func triggerAction(_ sender: UIButton) {
        guard
            let title = sender.title(for: .normal),
            let index = titles.index(of: title) else { return }
        setSelectionViewContentOffset(x: sender.center.x, animated: true)
        setSelectedIndex(index, animated: true)
    }
    
}

extension UIView {
    
    func removeConstraint(with identifier: String) {
        constraints.filter { $0.identifier == identifier }.forEach { removeConstraint($0) }
    }
    
}
