//
//  ViewController.swift
//  GPA Calculator
//
//  Created by Diya on 9/29/23.
//

// Importing the
// UIKit - Construct and manage a graphical, event-driven user interface for your iOS, iPadOS, or tvOS app.
import UIKit
// IOSDropDown -
import iOSDropDown
// CoreData - Persist or cache data on a single device, or sync data to multiple devices with CloudKit.
import CoreData

// The UIViewController class defines the shared behavior that’s common to all view controllers
class InputViewController: UIViewController {
    // connecting objects from the screen so they can be refered to and their input can be accessed in the code
    @IBOutlet weak var EnterCourseName: UITextField!
    @IBOutlet weak var SelectGrade: DropDown!
    @IBOutlet weak var SelectLevel: DropDown!
    @IBOutlet weak var InvalidCourse: UILabel!
    @IBOutlet weak var SelectSemester: DropDown!
    
    // cgl refers to the entity in which the data is being stored
    var cgl = CGL()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // refrence to the data from core data to be used in code
    
    override func viewDidLoad() {
        // overriding to have more than a blank screen
        // setting defaults when loading screen
        super.viewDidLoad()
        // the screen comes up
       
        // initialzing the drop down menus, giving options, and turning off the search option
        SelectLevel.optionArray = ["Standard", "Honors", "AP"]
        SelectLevel.isSearchEnable = false
        
        SelectGrade.optionArray = ["0-59", "60-69", "70-79", "80-89", "90-100"]
        SelectGrade.isSearchEnable = false
        
        SelectSemester.optionArray = ["Freshman 1st", "Freshman 2nd", "Sophmore 1st", "Sophmore 2nd", "Junior 1st", "Junior 2nd", "Senior 1st", "Senior 2nd"]
        SelectSemester.isSearchEnable = true
    }
    
    // giving instructions for when the Add Course button is clicked
    @IBAction func AddCourseClicked(_ sender: Any) {
        //values of the textfields when clicked
        // ?? = Nil-Coalescing Operator : check if it is nil. if nil, gives default value
         let courseName = EnterCourseName.text ?? ""
        let grade = SelectGrade.text ?? "0-59"
        let level = SelectLevel.text ?? "Standard"
        let semester = SelectSemester.text ?? "Freshman 1st"
        
        
        // .trimmingCharacters = getting rid of characters (whitespaces) and if there is nothing after that, do this
        // this statement is checking if there are characters entered in the course name text field and if there are no characters, the inputs won't be saved and an error message will pop up
        if (courseName.trimmingCharacters(in: .whitespaces) == "") {
            InvalidCourse.isHidden = false
        }
        
        // if there is an input other than spaces, the data is saved and proceeds
        if InvalidCourse.isHidden == true {
            let cglEntity = CGL(context: self.context)
            cglEntity.course = courseName
            cglEntity.semester = semester
         // saving the course name value in the atribute under CGL called course.
        //  making variables to store the numerical value of the grade and course level
            var convertedGrade = 0
            var convertedLevel = 0.0
            
            // converting the options into the values used to calculate GPA
            if grade == "0-59" {
                convertedGrade = 0
            } else if grade == "60-69" {
                convertedGrade = 1
            } else if grade == "70-79" {
                convertedGrade = 2
            } else if grade == "80-89" {
                convertedGrade = 3
            } else if grade == "90-100" {
                convertedGrade = 4
            }
          
            if level == "Standard" {
                convertedLevel = 0.0
            } else if level == "Honors" {
                convertedLevel = 0.5
            } else if level == "AP" {
                convertedLevel = 1.0
            }
            
            
            cglEntity.grade = grade 
            cglEntity.level = level
            cglEntity.convertedGrade = Int16(convertedGrade)
            cglEntity.convertedLevel = Float(convertedLevel)
            
            do {
                try self.context.save()
            } catch {
                //display error
            }
          
            EnterCourseName.text = nil
            SelectGrade.text = nil
            SelectLevel.text = nil
            SelectSemester.text = nil
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}

