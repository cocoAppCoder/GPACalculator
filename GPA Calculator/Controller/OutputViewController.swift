//
//  OutputViewController.swift
//  GPA Calculator
//
//  Created by Diya on 1/13/24.
//

import Foundation
import UIKit
import CoreData
import iOSDropDown
class CGLcell: UITableViewCell {
    
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var semesterLabel: UILabel!
    
}

//Implemented UITableViewDelegate protocol to work with table rows
//Implemented UITableViewDataSource protocol to work with the table data 
class OutputViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet weak var WeightedSwitch: UISwitch!
    @IBOutlet weak var GPAresult: UILabel!
    @IBOutlet weak var CreditCount: DropDown!
    @IBOutlet weak var mathCreditLabel: UILabel!
    @IBOutlet weak var englishCreditLabel: UILabel!
    @IBOutlet weak var socialStudiesCreditLabel: UILabel!
    @IBOutlet weak var scienceCreditLabel: UILabel!
    @IBOutlet weak var healthCreditLabel: UILabel!
    @IBOutlet weak var electivesCreditLabel: UILabel!
    @IBOutlet weak var worldLanguageLabel: UILabel!
    @IBOutlet weak var courseHistoryLabel: UILabel!
    @IBOutlet weak var CourseTable: UITableView!
    
    //reference to the data base to access the data saves
    let cglContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //data definition for the table
    var items : [CGL] = [] //collection of the cgl data
    var cgl = CGL()
    var unweightedGPA = 0.0
    var weightedGPA = 0.0
    var mathCredit = 0
    var englishCredit = 0
    var socialStudiesCredit = 0
    var scienceCredit = 0
    var healthCredit = 0
    var electiveCredit = 0
    var worldLanguageCredit = 0
    
    //get saved course information from CoreData
    func fetchCGL() {
        
        do {
            // getting information and assigning it to variables/constants for convinence
            let request = CGL.fetchRequest()
            let records = try! cglContext.fetch(request)
            // XCode sums internally all the values in convertedGrade column
            let sumGrade = records.reduce(0) { $0 + ($1.value(forKey: "convertedGrade") as? Int16 ?? 0)}
            // XCode sums internally all the values in convertedLevel column
            let sumLevel = records.reduce(0) { $0 + ($1.value(forKey: "convertedLevel") as? Float ?? 0)}
            self.items = try cglContext.fetch(request)
            //setting gpa to a default
            if items.count == 0 {
                unweightedGPA = 0.0
                weightedGPA = 0.0
            } else {
                //setting up gpa (with math)
                unweightedGPA = Double(sumGrade) / Double(items.count)
                weightedGPA = (Double(sumGrade) + Double(sumLevel)) / Double(items.count)
            }
            //getting the total credits
            mathCredit = Int(records.reduce(0) { $0 + ($1.value(forKey: "mathCredit") as? Int16 ?? 0)})
            englishCredit = Int(records.reduce(0) { $0 + ($1.value(forKey: "englishCredit") as? Int16 ?? 0)})
            socialStudiesCredit = Int(records.reduce(0) { $0 + ($1.value(forKey: "socialStudiesCredit") as? Int16 ?? 0)})
            scienceCredit  = Int(records.reduce(0) { $0 + ($1.value(forKey: "scienceCredit") as? Int16 ?? 0)})
            healthCredit = Int(records.reduce(0) { $0 + ($1.value(forKey: "healthCredit") as? Int16 ?? 0)})
            electiveCredit = Int(records.reduce(0) { $0 + ($1.value(forKey: "electiveCredit") as? Int16 ?? 0)})
            worldLanguageCredit = Int(records.reduce(0) { $0 + ($1.value(forKey: "worldLanguageCredit") as? Int16 ?? 0)})
            //updating to match data
            DispatchQueue.main.async {
                self.CourseTable.reloadData()
            }
        }
        catch {
                
            }
        }
    
    //loading course history
    override func viewDidLoad() {
        super.viewDidLoad()
        courseHistoryLabel.layer.cornerRadius = 20
        courseHistoryLabel.clipsToBounds = true
        //setting up table view
        CourseTable.layer.cornerRadius = 20
        CourseTable.clipsToBounds = true
        CourseTable.dataSource = self
        CourseTable.delegate = self
        
        // get items from core data & showing it on screen
        fetchCGL()
        GPAresult.text = "GPA = \(String(format: "%.3f", self.weightedGPA))"
        CreditCount.isSearchEnable = false
        CreditCount.optionArray =
        ["Math = \(mathCredit)/4",
         "English = \(englishCredit)/4",
         "Social Studies = \(socialStudiesCredit)/4",
         "Science = \(scienceCredit)/3",
         "Health = \(healthCredit)/1",
         "Elective = \(electiveCredit)/6",
         "World Language = \(worldLanguageCredit)/2"]
    }
    

    //Switch that calculates weighted/unweighted GPA
    @IBAction func WeightedSwitch(_ sender: UISwitch) {
        self.fetchCGL()
        if sender.isOn {
            GPAresult.text = "GPA = \(String(format: "%.3f", self.weightedGPA))"
        } else {
            GPAresult.text = "GPA = \(String(format: "%.3f", self.unweightedGPA))"
        }
    }
    
    
    //Delete action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Create swipe action
        let swipeDelete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
        
        // What DML to remove
            let cglToRemove = self.items[indexPath.row]
            
        //check and remove credits
    
        if cglToRemove.mathCredit > 0 {
            self.mathCredit -= 1
        } else if cglToRemove.englishCredit > 0 {
            self.englishCredit -= 1
        } else if cglToRemove.socialStudiesCredit > 0 {
            self.socialStudiesCredit -= 1
        } else if cglToRemove.scienceCredit > 0 {
            self.scienceCredit -= 1
        } else if cglToRemove.healthCredit > 0 {
            self.healthCredit -= 1
        } else if cglToRemove.worldLanguageCredit > 0 {
            self.worldLanguageCredit -= 1
            self.electiveCredit -= 1
        } else if cglToRemove.electiveCredit > 0 {
            self.electiveCredit -= 1
        }
        
        // Remove the DML
            self.cglContext.delete(cglToRemove)
            
            self.viewDidLoad()
            
        // Save the data
            do {
                try self.cglContext.save()
            } catch {
                
            }
        // Re-fetch the Data
            self.fetchCGL()
            
            if self.WeightedSwitch.isOn {
                self.GPAresult.text = "GPA = \(String(format: "%.3f", self.weightedGPA))"
            } else {
                self.GPAresult.text = "GPA = \(String(format: "%.3f", self.unweightedGPA))"
            }
           
        }
        // Return swipe actions
        return UISwipeActionsConfiguration(actions: [swipeDelete])
    }
    
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return items.count
   }
    
    
    //Evalulate grade based on score
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CGLcell", for: indexPath) as! CGLcell
        print("Dequeued cell with identifier: \(cell.reuseIdentifier ?? "nil")")

        //l
        cell.courseLabel.text = items[indexPath.row].course
        
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
        var level = "Stand"
        if items[indexPath.row].level == "Standard" {
            level = "Stand"
        } else if items[indexPath.row].level == "Honors" {
            level = "Honor"
        } else {
            level = "AP/DE"
        }
        cell.levelLabel.text = level
        let convertedLevel = items[indexPath.row].level ?? "0.0"
        
        var semester = "Fresh 1"
        if items[indexPath.row].semester == "Freshman 1st"{
            semester = "Fresh 1"
        } else if items[indexPath.row].semester == "Freshman 2nd"{
            semester = "Fresh 2"
        } else if items[indexPath.row].semester == "Sophmore 1st"{
            semester = "Soph 1"
        } else if items[indexPath.row].semester == "Sophmore 2nd"{
            semester = "Soph 2"
        } else if items[indexPath.row].semester == "Junior 1st"{
            semester = "Jun 1"
        } else if items[indexPath.row].semester == "Junior 2nd"{
            semester = "Jun 2"
        } else if items[indexPath.row].semester == "Senior 1st"{
            semester = "Sen 1"
        } else {
            semester = "Sen 2"
        }
        cell.semesterLabel.text = semester
        
        return cell
    }
    
    
    }

