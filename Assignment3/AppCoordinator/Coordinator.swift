//
//  Coordinator.swift
//  Assignment3
//
//  Created by Jignesh on 10/06/22.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    
    func configureRootViewController()
}
