//
//  TaskViewModel.swift
//  Assignment3
//
//  Created by Jignesh on 10/06/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class TaskViewModel {
    
    var tasks = BehaviorSubject(value: [SectionModel(model: "", items: [Task]())])
    var taskList: [Task] = []
    
    func fetchTasks() {
        guard let data = JSONDataManager.load("test", with: [Task].self) else { return }
        taskList = data
        let secondSection = SectionModel(model: "My Tasks", items: taskList)
        self.tasks.on(.next([secondSection]))
    }
    
//    func fetchTasks() {
//        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
//        let task = URLSession.shared.dataTask(with: url!) { (data,response, error) in
//            guard let data = data else {
//                return
//            }
//            do {
//                let responseData = try JSONDecoder().decode([Task].self, from: data)
//                //let sectionUser = SectionModel(model: "First", items: [Task(title: "teststststsst", isFinished: false)])
//                let secondSection = SectionModel(model: "Second", items: responseData)
//                self.tasks.on(.next([secondSection]))
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//        task.resume()
//    }
    
    func addTask(task: Task) {
        guard var sections = try? tasks.value() else { return }
        var currentSection = sections[0]
        currentSection.items.append(task)
        sections[0] = currentSection
        self.tasks.onNext(sections)
        taskList.append(task)
        JSONDataManager.save(taskList, with: "test")
    }
     
    func editTask(title:String,indexPath:IndexPath) {
        guard var sections = try? tasks.value() else { return }
        var currentSection = sections[indexPath.section]
        currentSection.items[indexPath.row].title = title
        sections[indexPath.section] = currentSection
        self.tasks.onNext(sections)
        //var selectedTask = currentSection.items[indexPath.row]
        //selectedTask.title = title
        taskList[indexPath.row].title = title
        JSONDataManager.save(taskList, with: "test")
    }
    
    func editTaskFinished(indexPath: IndexPath) {
        guard var sections = try? tasks.value() else { return }
        var currentSection = sections[indexPath.section]
        currentSection.items[indexPath.row].isFinished = true
        sections[indexPath.section] = currentSection
        self.tasks.onNext(sections)
        taskList[indexPath.row].isFinished = true
        JSONDataManager.save(taskList, with: "test")
    }
    
    func deleteTask(indexPath: IndexPath) {
        guard var sections = try? tasks.value() else { return }
        var currentSection = sections[indexPath.section]
        //let selectedEvent = currentSection.items[indexPath.row]
        currentSection.items.remove(at: indexPath.row)
        sections[indexPath.section] = currentSection
        self.tasks.onNext(sections)
        taskList.remove(at: indexPath.row)
        JSONDataManager.save(taskList, with: "test")
    }
}
