//
//  Utilities.swift
//  Yelp
//
//  Created by Gokul Sai Katragadda on 10/28/21.
//

import Foundation
import UIKit

class ViewController<T: UIView>: UIViewController {
    
    lazy var rootView = T()
    
    override func loadView() {
        view = rootView
    }
}
