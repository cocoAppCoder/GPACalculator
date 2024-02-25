//
//  OutputViewController.swift
//  GPA Calculator
//
//  Created by Diya on 1/13/24.
//

import Foundation
import UIKit
import CoreData

class CGLcell: UITableViewCell {
    
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var semesterLabel: UILabel!
    
}

class OutputViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet weak var WeightedSwitch: UISwitch!
    @IBOutlet weak var GPAresult: UILabel!
    @IBOutlet weak var CourseTable: UITableView!
    
    //refrence to the data base to access the data saves
    let cglContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //data for the table
    var items : [CGL] = [] //collectioon of the cgl data
    var cgl = CGL()
    var unweightedGPA = 0.0
    var weightedGPA = 0.0
    
    
    func fetchCGL() {
        
        do {
            
            let request = CGL.fetchRequest()
            let records = try! cglContext.fetch(request)
            // XCode sums internally all the values in convertedGrade column
            let sumGrade = records.reduce(0) { $0 + ($1.value(forKey: "convertedGrade") as? Int16 ?? 0)}
            // XCode sums internally all the values in convertedLevel column
            let sumLevel = records.reduce(0) { $0 + ($1.value(forKey: "convertedLevel") as? Float ?? 0)}
            self.items = try cglContext.fetch(request)
            
            if items.count == 0 {
                unweightedGPA = 0.0
                weightedGPA = 0.0
            } else {
                unweightedGPA = Double(sumGrade) / Double(items.count)
                weightedGPA = (Double(sumGrade) + Double(sumLevel)) / Double(items.count)
            }
            
            DispatchQueue.main.async {
                self.CourseTable.reloadData()
            }
        }
        catch {
                
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CourseTable.dataSource = self
        CourseTable.delegate = self
        
        // get items from core data
        fetchCGL()
        
        GPAresult.text = "GPA = \(weightedGPA)"
    }
    

        
    @IBAction func WeightedSwitch(_ sender: UISwitch) {
        self.fetchCGL()
        if sender.isOn {
            GPAresult.text = "GPA = \(weightedGPA)"
        } else {
            GPAresult.text = "GPA = \(unweightedGPA)"
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Create swipe action
        let swipeDelete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
        
        // What DML to remove
            let cglToRemove = self.items[indexPath.row]
        
        // Remove the DML
            self.cglContext.delete(cglToRemove)
            
        // Save the data
            do {
                try self.cglContext.save()
            } catch {
                
            }
        // Re-fetch the Data
            self.fetchCGL()
            
            if self.WeightedSwitch.isOn {
                self.GPAresult.text = "GPA = \(self.weightedGPA)"
            } else {
                self.GPAresult.text = "GPA = \(self.unweightedGPA)"
            }
           
        }
        // Return swipe actions
        return UISwipeActionsConfiguration(actions: [swipeDelete])
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CGLcell", for: indexPath) as! CGLcell
        print("Dequeued cell with identifier: \(cell.reuseIdentifier ?? "nil")")

      
            cell.courseLabel.text = items[indexPath.row].course
        cell.semesterLabel.text = items[indexPath.row].semester
         var grade = "F"
        if items[indexPath.row].grade == "0-59" {
            grade = "F"
        } else if items[indexPath.row].grade == "60-69" {
            grade = "D"
        } else if items[indexPath.row].grade == "70-79" {
            grade = "C"
        } else if items[indexPath.row].grade == "80-89" {
            grade = "B"
        } else {
            grade = "A"
        }
        cell.gradeLabel.text = grade
            
        cell.levelLabel.text = items[indexPath.row].level
        let level = items[indexPath.row].level ?? "0.0"
        cell.levelLabel.text = level
        
        
        return cell
    }
    
    
    }

