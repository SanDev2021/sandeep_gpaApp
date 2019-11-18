//
// SememesterViewController.swift
//  Sandeep_c0766628_gpaApp
//
//  Created by Owner on 2019-11-17.
//  Copyright © 2019 SandeepAppDev. All rights reserved.
//

extension Constants {
    static let semesterCellIdentifier = "semesterCellIdentifier"
}

protocol SemesterViewControllerDelegate: class {
    func didChangeSemesterData(student: Student)
}

import UIKit

class SemesterViewController: UITableViewController {
    
    /// Variables
    var student: Student?
    
    weak var delegate: SemesterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Semesters"
    }
    
}

///for table view data source and delegate methods
extension SemesterViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return student?.semester.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.semesterCellIdentifier, for: indexPath)
        
        cell.textLabel?.text = student?.semester[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        guard let coursesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CoursesViewController") as? CoursesViewController else {
            return
        }
        
        coursesVC.semester = student?.semester[indexPath.row]
        coursesVC.delegate = self
        self.navigationController?.pushViewController(coursesVC, animated: true)
    }
}

///  Courses View Controller Delegate methods
extension SemesterViewController: CoursesViewControllerDelegate
{
    func saveStudentGPA(semester: Semester?)
    {
        for i in 0..<student!.semester.count
        {
            if student!.semester[i].name == semester?.name
            {
                student?.semester[i] = semester!
                self.delegate?.didChangeSemesterData(student: student!)
                return
            }
        }
    }
}
