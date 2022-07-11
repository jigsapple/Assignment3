//
//  TaskListViewController.swift
//  Assignment3
//
//  Created by Jignesh on 10/06/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class TaskListViewController: UIViewController {

    private var viewModel = TaskViewModel()
    
    private var bag = DisposeBag()
    
    var mainCoordinator: MainCoordinator?
    
    lazy var tableView : UITableView = {
        let tblView = UITableView(frame: self.view.frame, style: .insetGrouped)
        tblView.translatesAutoresizingMaskIntoConstraints = false
        tblView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserTableViewCell")
        return tblView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Tasks"
        self.navigationItem.hidesBackButton = true
        let add = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(onTapAdd))
        self.navigationItem.rightBarButtonItem = add
        self.view.addSubview(tableView)
        
        viewModel.fetchTasks()
        bindTableView()
    }
    
    @objc func onTapAdd() {
        let testTask = Task(title: "taskno - \(Int(arc4random_uniform(2000)))", isFinished: false)
        self.viewModel.addTask(task: testTask)
    }
    
    func bindTableView() {
        tableView.rx.setDelegate(self).disposed(by: bag)

        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,Task>> { _, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
            if item.isFinished ?? false {
                cell.textLabel?.attributedText = item.title?.strikeThrough()
            } else {
                cell.textLabel?.attributedText = NSAttributedString(string: item.title ?? "")
            }
            return cell
        } titleForHeaderInSection: { dataSorce, sectionIndex in
            return dataSorce[sectionIndex].model
        }

        self.viewModel.tasks.bind(to: self.tableView.rx.items(dataSource: dataSource)).disposed(by: bag)
        
        tableView.rx.itemDeleted.subscribe(onNext:{ [weak self] indexPath in
            guard let self = self else { return }
            self.viewModel.deleteTask(indexPath: indexPath)
        }).disposed(by: bag)
        
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            let alert = UIAlertController(title: "Edit Task", message: "", preferredStyle: .alert)
            alert.addTextField { texfield in
                texfield.placeholder = "Enter Title"
            }
            alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { action in
                let textField = alert.textFields![0] as UITextField
                guard let newTitle = textField.text else { return }
                self.viewModel.editTask(title: newTitle, indexPath: indexPath)
            }))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }).disposed(by: bag)
    }
}

extension TaskListViewController : UITableViewDelegate { }
