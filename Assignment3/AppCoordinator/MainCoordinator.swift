//
//  MainCoordinator.swift
//  Assignment3
//
//  Created by Jignesh on 10/06/22.
//

import UIKit

class MainCoordinator : Coordinator {
    
    var navigationController: UINavigationController
    
    init(with _navigationController: UINavigationController) {
        navigationController = _navigationController
    }
    
    func configureRootViewController() {
        let taskListVC = TaskListViewController()
        taskListVC.mainCoordinator = self
        self.navigationController.pushViewController(taskListVC, animated: false)
    }
    
    func dismissVC() {
        self.navigationController.dismiss(animated: true, completion: nil)
    }
}
