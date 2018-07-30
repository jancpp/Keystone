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
    
    let student = ["Jan", "Jakub", "Michaela"]

    @IBAction func addStudentAction(_ sender: UIBarButtonItem) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return student.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath)

        cell.textLabel?.text = student[indexPath.row]

        return cell
    }
    


}
