//
//  QAController.swift
//  GPA Calculator
//
//  Created by Diya on 3/18/24.
//

import Foundation
import UIKit
import CoreData


class QAController:UIViewController{
    @IBOutlet weak var QAtextField: UITextField!
    @IBOutlet weak var AnswerLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        AnswerLabel.layer.cornerRadius = 20
        AnswerLabel.clipsToBounds = true
    }
    
    var questionBank = [
        "grade ranges":"These grade ranges help the program determine your GPA. Each range represents a different point. The table below shows the relationship  between grade ranges and points.",
        "rigor":"The course level determines whether there will be a little more points added to the GPA. For Academic, no extra points are given. For Honors, .5 points are given. Finally, AP courses get a whole extra point. This only applies to the weighted GPA though. ",
        "level":"The course level determines whether there will be a little more points added to the GPA. For Academic, no extra points are given. For Honors, .5 points are given. Finally, AP courses get a whole extra point. This only applies to the weighted GPA though. ",
        "levels":"The course rigor determines whether there will be a little more points added to the GPA. For Academic, no extra points are given. For Honors, .5 points are given. Finally, AP courses get a whole extra point. This only applies to the weighted GPA though. ",
        "calculated":"GPA is calculated using course grades and course rigor. Each grade range equates to an amount of points. 90-100 is 4, 80-89 is 3, 70-79 is 2, 60-69 is 1, and 0-59 is 0. The rigor is only accounted for with weighted GPA. It adds points. Ask about rigor for more information",
        "calculate":"To calculated GPA, the program uses course grades and course rigor. Each grade range equates to an amount of points. 90-100 is 4, 80-89 is 3, 70-79 is 2, 60-69 is 1, and 0-59 is 0. The rigor is only accounted for with weighted GPA. It adds points. Ask about rigor for more information",
        "weighted":"Weighted GPA includes class rigor into the GPA. Courses that are honors, Advanced Placement (AP), or Duel Enrolment (DE) courses will havea higher point than an academic or standard level course. This results in a higher GPA for these weighted courses compared to non-weighted ones.",
        "unweighted":"Unweighted GPA doesn't include class rigor into the GPA. All courses are valued the same and the rigor doesn't impacct the final GPA at all. This results in a lower GPA compared to weighted ones.",
        "world language":"World Langauge Credit is not manditory, but is sought after be the majority of colleges. UNC requires 2 foreign language credits, which is what the wake county system reccomends.",
        "credits":"Each course earns 1 credit. If a student in an AP class scores well on the AP exam, that credit will count towards their college credits along with high school credits. Also, if a student took high school level courses prior to high school, that credit will be added to the high school credits. A student needs 22 credits total to graduate"
    ]
    @IBAction func AskButtonPressed(_ sender: Any) {
        let broken_up_words = QAtextField.text?.split(separator: " ")
        for word in broken_up_words! {
            for question in questionBank.keys{
                if question.contains(word){
                    AnswerLabel.text = questionBank[question]
                    return
                } else {
                       AnswerLabel.text = "I don't understand your question. Enter another question"
                   
                }
            }
        }
        
    }
}
