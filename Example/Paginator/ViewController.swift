//
//  ViewController.swift
//  ios-custom-paging
//
//  Created by Stefan A on 08/05/2018.
//  Copyright © 2018 Stefan A. All rights reserved.
//

import UIKit
import Paginator

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .green
        button.setTitle("perform action", for: .normal)
        view.addSubview(button)
        
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        button.addTarget(self, action: #selector(performAction), for: .touchUpInside)
    }
    
    @objc private func performAction() {
        // Uncomment the line below to only test the paging view
//         exampleAddingOnlyThePagingView()
        
        // Uncomment the line below to test the pagingController
        exampleAddingThePagingViewController()
    }
    
    func exampleAddingOnlyThePagingView() {
        let pagingView = PagingView(titles: ["Red", "Gray", "Blue"])
        pagingView.delegate = self
        pagingView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(pagingView)
        
        pagingView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        pagingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pagingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pagingView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func exampleAddingThePagingViewController() {
        let controller1 = ViewControllerOne()
        let controller2 = ViewControllerTwo()
        let controller3 = ViewControllerThree()
        
        let controller = PagingViewController(viewControllers: [controller1, controller2, controller3], initialIndex: 0)
        self.present(controller, animated: true, completion: nil)
    }

}

// MARK: - PagingView Delegate

extension ViewController: PagingViewDelegate {
    func pagingView(_ pagingView: PagingView, didSelectIndex selectedIndex: Int, animated: Bool, completion: (() -> Void)?) {
        switch selectedIndex {
        case 0: view.backgroundColor = .red
        case 1: view.backgroundColor = .lightGray
        default: view.backgroundColor = .blue
        }
        completion?()
    }

}
