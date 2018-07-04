//
//  PagingViewController.swift
//  ios-custom-paging
//
//  Created by Stefan A on 09/05/2018.
//  Copyright © 2018 Stefan A. All rights reserved.
//

import Foundation
import UIKit

public protocol Pageable {
    var pageTitle: String { get }
    func pagingViewDidShow()
}

extension Pageable {
    func pagingViewDidShow() { }
}

public class PagingViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var pagingView: PagingView = {
        let view = PagingView(titles: viewControllers.map {$0.pageTitle}, theme: theme)
        view.handlesViewControllers = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.zPosition = 1
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()
    
    // MARK: - Internals
    
    private let viewControllers: [Pageable & UIViewController]
    private var stackViewWidthConstraint = NSLayoutConstraint()
    private var theme: PagingViewTheme
    private let initialIndex: Int
    
    // MARK: - Init
    
    public init(viewControllers: [Pageable & UIViewController], theme: PagingViewTheme = DefaultPagingViewTheme(), initialIndex: Int = 0) {
        self.viewControllers = viewControllers
        self.theme = theme
        
        if initialIndex >= viewControllers.count {
            self.initialIndex = viewControllers.endIndex
        } else {
            self.initialIndex = initialIndex
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View flow
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI
    
    private func setupUI() {
        addPagingView()
        addScrollView()
        addStackView()
        setupControllers()
        
        pagingView.setSelectedIndex(initialIndex, animated: false)
    }
    
    private func addPagingView() {
        view.addSubview(pagingView)
        pagingView.delegate = self
        
        NSLayoutConstraint.activate([
            pagingView.topAnchor.constraint(equalTo: view.topAnchor),
            pagingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pagingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pagingView.heightAnchor.constraint(equalToConstant: theme.totalHeight)
            ])
    }
    
    private func addScrollView() {
        view.addSubview(scrollView)
        scrollView.delegate = self
        
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.topAnchor.constraint(equalTo: pagingView.bottomAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    private func addStackView() {
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
            ])
        
        stackViewWidthConstraint = stackView.widthAnchor.constraint(equalToConstant: view.bounds.width * CGFloat(viewControllers.count))
        stackViewWidthConstraint.isActive = true
    }
    
    // MARK: - Setup
    
    private func setupControllers() {
        viewControllers.forEach {
            guard let arrangedView = $0.view else { return }
            self.addChildViewController($0)
            $0.willMove(toParentViewController: self)
            
            stackView.addArrangedSubview(arrangedView)
            arrangedView.translatesAutoresizingMaskIntoConstraints = false
            
            $0.didMove(toParentViewController: self)
        }
    }
    
    // MARK: - Transition
    
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        self.stackViewWidthConstraint.constant = self.view.bounds.width * CGFloat(viewControllers.count)
        coordinator.animate(alongsideTransition: { _ in
            self.stackViewWidthConstraint.constant = self.view.bounds.width * CGFloat(self.viewControllers.count)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // MARK: - Show / Hide
    
    private func showViewController(at index: Int) {
        if pagingView.selectedIndex != index {
            self.viewControllers[index].pagingViewDidShow()
        }
    }
    
    private func hideViewController(for selectedIndex: Int) {
        if let index = pagingView.selectedIndex, index != selectedIndex {
            self.viewControllers[index].view.endEditing(true)
        }
    }
    
}

// MARK: - Scrollview delegate

extension PagingViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        let selectionWidth = view.bounds.width/CGFloat(viewControllers.count)
        pagingView.selectionView.center.x = (selectionWidth * page) + (selectionWidth/2)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard let selectedIndex = pagingView.selectedIndex else { return }
        viewControllers[selectedIndex].view.endEditing(true)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pagingView.setSelectedIndex(page, animated: false)
    }
}

// MARK: - Paging view delegate

extension PagingViewController: PagingViewDelegate {
    public func pagingView(_ pagingView: PagingView, didSelectIndex selectedIndex: Int, animated: Bool, completion: (() -> Void)?) {
        let x = CGFloat(selectedIndex) * view.bounds.width
        let offset = CGPoint(x: x, y: 0)
        let delay = animated ? 0.25 : 0
        
        hideViewController(for: selectedIndex)
        
        executeAction(animated, delay: delay, action: {
            self.scrollView.setContentOffset(offset, animated: false)
            self.view.layoutIfNeeded()
        }) {
            self.showViewController(at: selectedIndex)
            completion?()
        }
    }
    
}

// MARK: - UIViewController + Animate

extension UIViewController {
    public func executeAction(_ animated: Bool, delay: Double = 0.0, action: @escaping (() -> Void), completion: (() -> Void)?) {
        if animated {
            UIView.animate(withDuration: 0.25, delay: delay, options: .curveEaseInOut, animations: {
                action()
            }, completion: { _ in
                completion?()
            })
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                action()
            }
            completion?()
        }
    }
}
