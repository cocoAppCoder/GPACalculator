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
    @IBOutlet weak var mathCreditLabel: UILabel!
    @IBOutlet weak var englishCreditLabel: UILabel!
    @IBOutlet weak var socialStudiesCreditLabel: UILabel!
    @IBOutlet weak var scienceCreditLabel: UILabel!
    @IBOutlet weak var healthCreditLabel: UILabel!
    @IBOutlet weak var electivesCreditLabel: UILabel!
    @IBOutlet weak var worldLanguageLabel: UILabel!
    
    @IBOutlet weak var CourseTable: UITableView!
    
    //refrence to the data base to access the data saves
    let cglContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //data for the table
    var items : [CGL] = [] //collectioon of the cgl data
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
            mathCredit = Int(records.reduce(0) { $0 + ($1.value(forKey: "mathCredit") as? Int16 ?? 0)})
            englishCredit = Int(records.reduce(0) { $0 + ($1.value(forKey: "englishCredit") as? Int16 ?? 0)})
            socialStudiesCredit = Int(records.reduce(0) { $0 + ($1.value(forKey: "socialStudiesCredit") as? Int16 ?? 0)})
            scienceCredit  = Int(records.reduce(0) { $0 + ($1.value(forKey: "scienceCredit") as? Int16 ?? 0)})
            healthCredit = Int(records.reduce(0) { $0 + ($1.value(forKey: "healthCredit") as? Int16 ?? 0)})
            electiveCredit = Int(records.reduce(0) { $0 + ($1.value(forKey: "electiveCredit") as? Int16 ?? 0)})
            worldLanguageCredit = Int(records.reduce(0) { $0 + ($1.value(forKey: "worldLanguageCredit") as? Int16 ?? 0)})
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
        GPAresult.text = "GPA = \(String(format: "%.2f", self.weightedGPA))"
        mathCreditLabel.text = "Math = \(mathCredit)/4"
        englishCreditLabel.text = "English = \(englishCredit)/4"
        socialStudiesCreditLabel.text = "Social Studies = \(socialStudiesCredit)/4"
        scienceCreditLabel.text = "Science = \(scienceCredit)/3"
        healthCreditLabel.text = "Health = \(healthCredit)/1"
        electivesCreditLabel.text = "Elective = \(electiveCredit)/6"
        worldLanguageLabel.text = "World Language = \(worldLanguageCredit)/2"
    }
    

        
    @IBAction func WeightedSwitch(_ sender: UISwitch) {
        self.fetchCGL()
        if sender.isOn {
            GPAresult.text = "GPA = \(String(format: "%.2f", self.weightedGPA))"
        } else {
            GPAresult.text = "GPA = \(String(format: "%.2f", self.unweightedGPA))"
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Create swipe action
        let swipeDelete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
        
        // What DML to remove
            let cglToRemove = self.items[indexPath.row]
            
        //check and remove credits
            guard let cglToRemove = self.items[indexPath.row] as? CGL else {
                // Handle the case where cglToRemove is not of type YourCoreDataEntity
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
                
                return
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
                self.GPAresult.text = "GPA = \(String(format: "%.2f", self.weightedGPA))"
            } else {
                self.GPAresult.text = "GPA = \(String(format: "%.2f", self.unweightedGPA))"
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

