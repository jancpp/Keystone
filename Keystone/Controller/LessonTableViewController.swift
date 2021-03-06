//
//  LessonTableViewController.swift
//  Keystone
//
//  Created by Jan Polzer on 7/30/18.
//  Copyright © 2018 Apps KC. All rights reserved.
//

import UIKit
import CoreData

class LessonTableViewController: UITableViewController {
    
    // MARK: - IBAction
    
    @IBAction func addStudentAction(_ sender: UIBarButtonItem) {
        present(alertController(actionType: "add"), animated: true, completion: nil)
    }
    
    
    // MARK: - Public properties
    
    var moc: NSManagedObjectContext? {
        didSet {
            if let moc = moc {
                lessonService = LessonService(moc: moc)
            }
        }
    }
    
    
    // MARK: - Private properties
    
    private var studentList = [Student]()
    private var lessonService: LessonService?
    private var studentToUpdate: Student?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadStudents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueLesson" {
            let destination = segue.destination as! LessonDetailTableViewController
            destination.moc = moc
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath)
        
        cell.textLabel?.text = studentList[indexPath.row].name
        cell.detailTextLabel?.text = studentList[indexPath.row].lesson?.type
        
        return cell
    }
    
    
    // MARK: - TableView delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        studentToUpdate = studentList[indexPath.row]
        present(alertController(actionType: "update"), animated: true, completion: nil)
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            lessonService?.delete(student: studentList[indexPath.row])
            studentList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        tableView.reloadData()
    }
    
    
    // MARK: - Private functions
    
    private func alertController(actionType: String) -> UIAlertController {
        let alertController = UIAlertController(title: "Keystone Park Lesson", message: "Student Info", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField { [weak self] (textField: UITextField) in
            textField.placeholder = "Name"
            textField.text = self?.studentToUpdate == nil ? "" : self?.studentToUpdate?.name
        }
        
        alertController.addTextField { [weak self] (textField: UITextField) in
            textField.placeholder = "Lesson Type: Ski | Snowboard"
            textField.text = self?.studentToUpdate == nil ? "" : self?.studentToUpdate?.lesson?.type
        }
        
        let defaultAction = UIAlertAction(title: actionType.uppercased(), style: UIAlertAction.Style.default) { [weak self] (action: UIAlertAction) in
            guard let studentName = alertController.textFields?[0].text, let lesson = alertController.textFields?[1].text else { return }
            
            if actionType.caseInsensitiveCompare("add") == .orderedSame {
                if let lessonType = LessonType(rawValue: lesson.lowercased()) {
                    self?.lessonService?.addStudent(name: studentName, for: lessonType, completion: { (success, students) in
                        if success {
                            self?.studentList = students
                        }
                    })
                }
            }
            else {
                guard let name = alertController.textFields?.first?.text, !name.isEmpty,
                    let studentToUpdate = self?.studentToUpdate,
                    let lessonType = alertController.textFields?[1].text
                    else {
                        return
                }
                
                self?.lessonService?.update(currentStudent: studentToUpdate, withName: name, forLesson: lessonType)
                self?.studentToUpdate = nil
            }
            
            DispatchQueue.main.async {
                self?.loadStudents()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) { [weak self] (action) in
            self?.studentToUpdate = nil
        }
        
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    private func loadStudents() {
        if let students = lessonService?.getAllStudents() {
            studentList = students
            tableView.reloadData()
        }
    }
}
