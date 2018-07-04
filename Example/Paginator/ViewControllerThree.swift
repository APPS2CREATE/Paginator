//
//  ViewControllerThree.swift
//  ios-custom-paging
//
//  Created by Stefan A on 09/05/2018.
//  Copyright © 2018 Stefan A. All rights reserved.
//

import Foundation
import UIKit
import Paginator

class ViewControllerThree: UIViewController, Pageable {
    
    // MARK: - Paging implicit properties
    
    var pageTitle: String {
        return "vcThree"
    }
    
    func pagingViewDidShow() {
        print(pageTitle)
    }
    
    // MARK: - ViewFlow
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ViewControllerThree"
        view.addSubview(label)
        
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.backgroundColor = .purple
    }
    
}
