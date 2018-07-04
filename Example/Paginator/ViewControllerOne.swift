//
//  ViewControllerOne.swift
//  ios-custom-paging
//
//  Created by Stefan A on 09/05/2018.
//  Copyright © 2018 Stefan A. All rights reserved.
//

import Foundation
import UIKit
import Paginator

class ViewControllerOne: UIViewController, Pageable {
    
    // MARK: - Paging implicit properties
    
    var pageTitle: String {
        return "vcOne"
    }
    
    func pagingViewDidShow() {
        textfield.becomeFirstResponder()
    }
    
    // MARK: - Views
    
    let textfield = UITextField()
    
    // MARK: - ViewFlow
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ViewControllerOne"
        view.addSubview(label)
        
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.backgroundColor = .white
        view.addSubview(textfield)
        
        textfield.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        textfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        textfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        textfield.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.backgroundColor = .cyan
    }
    
}
