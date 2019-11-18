//
//  CoursesViewController.swift
//  Sandeep_c0766628_gpaApp
//
//  Created by Owner on 2019-11-17.
//  Copyright © 2019 SandeepAppDev. All rights reserved.

import UIKit
import AVFoundation
enum Grade: Double {
    case APlus = 4.0
    case A = 3.7
    case AMinus = 3.5
    case BPlus = 3.2
    case B = 3.0
    case BMinus = 2.7
    case CPlus = 2.3
    case C = 2.0
    case CMinus = 1.7
    case D = 1.0
    case F = 0.0
}
/// Struct course to save course details
struct Course
{
    var name: String
    var credit: Double
    var gpa: Double
}
protocol CoursesViewControllerDelegate: class {
    func saveStudentGPA(semester: Semester?)
}
class CoursesViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textFieldMAD3004: UITextField!
    @IBOutlet weak var textFieldMAD2303: UITextField!
    @IBOutlet weak var textFieldMAD3463: UITextField!
    @IBOutlet weak var textFieldMAD3115: UITextField!
    @IBOutlet weak var textFieldMAD3125: UITextField!
    var currentTextField = UITextField()
    var semester: Semester?
    var arrayCourse: [Course] = []
    //label to display counted GPA
    @IBOutlet weak var labelTotalGPA: UILabel!
    weak var delegate: CoursesViewControllerDelegate?
    //play clap if got 2.8
    var player = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Keyboard appears / disappears at appropriate times
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //keyboard will show after clicking
    @objc func keyboardWillShow(notification:NSNotification){
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    /// Method to show text field validation error messages
    private func showTextFieldValidationAlertMessage(title: String = "", message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    /// Method for empty text fields
    private func validateTextField() -> Bool {
        if let textFieldMAD3004 = self.textFieldMAD3004.text, textFieldMAD3004.isEmpty {
            self.showTextFieldValidationAlertMessage(message: "MAD 3004 text field is empty.")
            return false
        } else if let textFieldMAD2303 = self.textFieldMAD2303.text, textFieldMAD2303.isEmpty {
            self.showTextFieldValidationAlertMessage(message: "MAD 2303 text field is empty.")
            return false
        } else if let textFieldMAD3463 = self.textFieldMAD3463.text, textFieldMAD3463.isEmpty {
            self.showTextFieldValidationAlertMessage(message: "MAD 3463 text field is empty.")
            return false
        } else if let textFieldMAD3115 = self.textFieldMAD3115.text, textFieldMAD3115.isEmpty {
            self.showTextFieldValidationAlertMessage(message: "MAD 3115 text field is empty.")
            return false
        } else if let textFieldMAD3125 = self.textFieldMAD3125.text, textFieldMAD3125.isEmpty {
            self.showTextFieldValidationAlertMessage(message: "MAD 3125 text field is empty.")
            return false
        }
        return true
    }
/// Action method on clicking calculate button
   @IBAction func methodClickedCalculate(_ sender: Any) {
        if validateTextField() {
            self.calculateTotalGPA()
        }}
/// Method to calculate GPA
    func calculateTotalGPA()
    {
        if let mad3004Marks = Double(self.textFieldMAD3004.text!),
            let course = self.getCourse(courseName: "MAD 3004", credit: 4, mark: mad3004Marks)
        {
            arrayCourse.append(course)
        }
        if let mad2303Marks = Double(self.textFieldMAD2303.text!),
            let course = self.getCourse(courseName: "MAD 2303", credit: 3, mark: mad2303Marks)
        {
            arrayCourse.append(course)
        }
        if let mad34634Marks = Double(self.textFieldMAD3463.text!),
            let course = self.getCourse(courseName: "MAD 3463", credit: 3, mark: mad34634Marks)
        {
            arrayCourse.append(course)
        }
        if let mad3115Marks = Double(self.textFieldMAD3115.text!),
            let course = self.getCourse(courseName: "MAD 3115", credit: 5, mark: mad3115Marks)
        {
            arrayCourse.append(course)
        }
        if let mad3125Marks = Double(self.textFieldMAD3125.text!),
            let course = self.getCourse(courseName: "MAD 3125", credit: 5, mark: mad3125Marks)
        {
            arrayCourse.append(course)
        }
        
        if arrayCourse.count == 5 {
            var totalCredits = 0.0
            var totalGPA = 0.0
            
            for i in 0..<arrayCourse.count {
                totalCredits = arrayCourse[i].credit
                totalGPA = arrayCourse[i].gpa
            }
        //formula to cALCULATE FINal GPa
            let finalGPA = totalGPA / totalCredits
            
            if finalGPA > 2.8 {
                self.playAudio()
            }
        semester?.studentGPA = finalGPA
            self.labelTotalGPA.text = String(format: "%.2f", finalGPA)
self.delegate?.saveStudentGPA(semester: semester!)
        }
    }
    /// Method to create course object with proper data
func getCourse(courseName: String, credit: Double, mark: Double) -> Course? {
        switch mark {
        case 94...100:
            let course = Course(name: courseName, credit: credit, gpa: (credit * Grade.APlus.rawValue))
            return course
        case 87...93:
            let course = Course(name: courseName, credit: credit, gpa: (credit * Grade.A.rawValue))
            return course
        case 80...86:
            let course = Course(name: courseName, credit: credit, gpa: (credit * Grade.AMinus.rawValue))
            return course
        case 77...79:
            let course = Course(name: courseName, credit: credit, gpa: (credit * Grade.BPlus.rawValue))
            return course
        case 73...76:
            let course = Course(name: courseName, credit: credit, gpa: (credit * Grade.B.rawValue))
            return course
        case 70...72:
            let course = Course(name: courseName, credit: credit, gpa: (credit * Grade.BMinus.rawValue))
            return course
        case 67...69:
            let course = Course(name: courseName, credit: credit, gpa: (credit * Grade.CPlus.rawValue))
            return course
        case 63...66:
            let course = Course(name: courseName, credit: credit, gpa: (credit * Grade.C.rawValue))
            return course
        case 60...62:
            let course = Course(name: courseName, credit: credit, gpa: (credit * Grade.CMinus.rawValue))
            return course
        case 50...59:
            let course = Course(name: courseName, credit: credit, gpa: (credit * Grade.D.rawValue))
            return course
        case 0...49:
            let course = Course(name: courseName, credit: credit, gpa: (credit * Grade.F.rawValue))
            return course
        default:
            return nil
        }}
    /// Function to play audio file
    func playAudio()
    {
        let path = Bundle.main.path(forResource: "Win", ofType : "wav")!
        let url = URL(fileURLWithPath : path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.play()
        } catch {
            print ("There is an issue with this code!")
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        player.stop()
    }
    }
/// Extension of Save Student View Controller for text field delegate methods
extension CoursesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
    }
}
