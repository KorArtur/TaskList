//
//  ViewController.swift
//  TaskList
//
//  Created by Alexey Efimov on 28.03.2024.
//

import UIKit

final class TaskListViewController: UITableViewController {
    
    private var taskList: [ToDoTask] = []
    private let cellID = "task"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        fetchData()
    }
    
    private func fetchData() {
        taskList = StorageManager.shared.fetchTasks()
    }
    
    @objc private func addNewTask() {
        showAlert(withTitle: "New Task", addMessage: "What do you want to do?", task: nil)
    }
    
    private func showAlert(withTitle title: String, addMessage message: String, task: ToDoTask? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "New Task"
            if let task = task {
                textField.text = task.title
            }
        }
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            guard let inputText = alert.textFields?.first?.text, !inputText.isEmpty else { return }
            
            if let task = task {
                self?.updateTask(task, withTitle: inputText)
            } else {
                self?.save(inputText)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    
    private func save(_ taskName: String) {
        StorageManager.shared.addTask(title: taskName)
        reloadData()
    }
    
    private func updateTask(_ task: ToDoTask, withTitle title: String) {
        StorageManager.shared.updateTask(task, withTitle: title)
        reloadData()
    }
    
    private func reloadData() {
        fetchData()
        tableView.reloadData()
    }
}

extension TaskListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        cell.textLabel?.text = task.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = taskList[indexPath.row]
            StorageManager.shared.deleteTask(task)
            reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTask = taskList[indexPath.row]
        showAlert(withTitle: "Edit Task", addMessage: "Edit your task", task: selectedTask)
    }
}

private extension TaskListViewController {
    
    func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .milkBlue
        navBarAppearance.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        )
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        navigationController?.navigationBar.tintColor = .white
    }
}
