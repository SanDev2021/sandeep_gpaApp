//
//  RegestraionViewController.swift
//  Sandeep_c0766628_gpaApp
//
//  Created by Owner on 2019-11-14.
//  Copyright © 2019 SandeepAppDev. All rights reserved.
//


import UIKit

/// Global Constants for the project
enum Constants {
    static let tableViewCellIdentifier = "studentCellIdentifier"
}

/// struct Student for saving student details
struct Student {
    var firstName: String
    var lastName: String
    var studentID: String
    var semester: [Semester]
}

/// struct Semester for saving semester details
struct Semester {
    var name: String
    var studentGPA: Double
}

/// StudentsListViewController to show list of Students
class StudentsNamesListViewController: UITableViewController {
    
    /// Array of student struct to save all student details
    var arrayStudents = [Student]()
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredStudents: [Student] = []
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Students"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredStudents = arrayStudents.filter { (student: Student) -> Bool in
            return student.firstName.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
    /// Method to be called while preparing to navigate to Save Student View Controller
    /// - Parameters:
    ///   - segue: segue used to navigate to Save Student View Controller
    ///   - sender: Any
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let saveStudentVC = segue.destination as? SaveStudentViewController else {
            return
        }
        
        saveStudentVC.delegate = self
    }
}

/// Extension of StudentsListViewController for table view data source and delegate methods
extension StudentsListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredStudents.count
        }
        return arrayStudents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tableViewCellIdentifier, for: indexPath)
        
        if isFiltering {
            cell.textLabel?.text = filteredStudents[indexPath.row].firstName + " " + filteredStudents[indexPath.row].lastName
        } else {
            cell.textLabel?.text = arrayStudents[indexPath.row].firstName + " " + arrayStudents[indexPath.row].lastName
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let semesterVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SemesterViewController") as? SemesterViewController else {
            return
        }
        
        if isFiltering {
            semesterVC.student = filteredStudents[indexPath.row]
        } else {
            semesterVC.student = arrayStudents[indexPath.row]
        }
        semesterVC.delegate = self
        self.navigationController?.pushViewController(semesterVC, animated: true)
    }
}

/// Extension of StudentsListViewController for Save Student ViewController Delegate methods
extension StudentsListViewController: SaveStudentViewControllerDelegate {
    func saveStudentData(student: Student) {
        self.arrayStudents.append(student)
        self.tableView.reloadData()
    }
}

/// Extension of StudentsListViewController for Search Result updating methods
extension StudentsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

/// Extension of StudentsListViewController for Semester View Controller Delegate methods
extension StudentsListViewController: SemesterViewControllerDelegate {
    func didChangeSemesterData(student: Student) {
        for i in 0..<arrayStudents.count {
            if arrayStudents[i].firstName == student.firstName {
                arrayStudents[i] = student
                self.tableView.reloadData()
                return
            }
        }
    }
}


