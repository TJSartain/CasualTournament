//
//  SetupViewController.swift
//  Tournament
//
//  Created by TJ Sartain on 8/24/18.
//  Copyright © 2018 iTrinity, Inc. All rights reserved.
//

import UIKit
import CoreData

class CreateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var doubleElimSwitch: UISwitch!

    @IBOutlet weak var teamsTable: UITableView!
    @IBOutlet weak var reorderButton: UIButton!
    var teams = NSMutableOrderedSet()
    var colorPool = Array(teamColorPool)
    lazy var context: NSManagedObjectContext = {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        nameField.text = ""

        let teamNames = ["Team 1",
                         "Team 2",
                         "Team 3",
                         "Team 4",
                         "Team 5",
                         "Team 6",
                         "Team 7"]

        teamEntity = NSEntityDescription.entity(forEntityName: "Team", in: context)!
        tournamentEntity = NSEntityDescription.entity(forEntityName: "Tournament", in: context)!
        
        for i in 0..<teamNames.count
        {
            teams.add(newTeam(teamNames[i]))
        }
//        teamsTable.isEditing = true
        teamsTable.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d/yy"
        dateField.text = formatter.string(from: Date())
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        nameField.becomeFirstResponder()
    }

    func detectDates(_ text: String) -> [Date]?
    {
        let nsString = text as NSString
        let length = nsString.length
        let nsRange = NSRange(location: 0, length: length)
        return try? NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue)
            .matches(in: text, range: nsRange)
            .compactMap { $0.date }
    }

    func newTeam(_ name: String) -> Team
    {
        let team = NSManagedObject(entity: teamEntity, insertInto: context) as! Team
        if let color = getColor() {
            team.color1 = color.0
            team.color2 = color.1
        } else {
            team.color1 = ltBlue
            team.color2 = dkBlue
        }
        team.name = name
        return team
    }

    func getColor() -> (UIColor, UIColor, String)?
    {
        if colorPool.count > 0
        {
            let n = arc4random_uniform(UInt32(colorPool.count))
            let color = colorPool.remove(at: Int(n))
            return color
        } else {
            return nil
        }
    }

    // MARK: - Actions -

    @IBAction func beginTapped(_ sender: UIButton)
    {
        view.endEditing(true)
        teamsTable.isEditing = false
        if nameField.text!.isEmpty {
            let alert = UIAlertController(title: "Oops", message: "Please enter a name for your tournament.", preferredStyle: UIAlertControllerStyle.alert)
            let OK = UIAlertAction(title: "OK", style: .default) {
                (alertAction) in
            }
            alert.addAction(OK)
            present(alert, animated:true, completion: nil)
        } else if teams.count > 4, teams.count < 33 {
            theTournament = NSManagedObject(entity: tournamentEntity, insertInto: context) as! Tournament
            if nameField.text!.isEmpty {
                theTournament.name = "Casual Tournament"
            } else {
                theTournament.name = nameField.text!
            }
            theTournament.location = locationField.text!
            let date = dateField.text!
            if let dates = detectDates(date) {
                if dates.count > 0 {
                    theTournament.date = dates[0] as NSDate
                }
            }
            //tournament.double_elim = doubleElimSwitch.isSelected

            theTournament.setup(teams)
            print(theTournament)

            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            performSegue(withIdentifier: "New Tournament", sender: self)
        } else {
            let alert = UIAlertController(title: "Oops", message: "Tournaments must at least 5 teams and at most, 32.", preferredStyle: UIAlertControllerStyle.alert)
            let OK = UIAlertAction(title: "OK", style: .default) {
                (alertAction) in
            }
            alert.addAction(OK)
            present(alert, animated:true, completion: nil)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        view.endEditing(true)
        teamsTable.isEditing = false
    }

    @IBAction func addTeam(_ sender: UIButton)
    {
        teamsTable.isEditing = false
        let alert = UIAlertController(title: "Team Entry", message: "", preferredStyle: UIAlertControllerStyle.alert)
        let add = UIAlertAction(title: "Add Team", style: .default) {
            (alertAction) in
            self.teams.add(self.newTeam(alert.textFields![0].text!))
            self.teamsTable.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) {
            (alertAction) in
        }
        alert.addTextField {
            (textField) in
            textField.placeholder = "<enter name>"
        }
        alert.addAction(add)
        alert.addAction(cancel)
        present(alert, animated:true, completion: nil)
    }

    @IBAction func reorderTapped(_ sender: UIButton)
    {
        view.endEditing(true)
        if teamsTable.isEditing {
            teamsTable.isEditing = false
//            reorderButton.setTitle("Reorder", for: .normal)
        } else {
            teamsTable.isEditing = true
//            reorderButton.setTitle("Done Reordering", for: .normal)
        }
    }

//    @IBAction func homeTapped(_ sender: Any)
//    {
//        AppDelegate.show(controller: "Home", storyboard: "Main")
//    }

    func renamePopup(_ team: Team)
    {
//        if let indexPath = self.teamsTable.indexPathForSelectedRow {
//            let team = self.teams[indexPath.row] as! Team
            let alert = UIAlertController(title: "Modify Team Name", message: "", preferredStyle: UIAlertControllerStyle.alert)
            let rename = UIAlertAction(title: "Rename", style: .default) {
                (alertAction) in
                if alert.textFields![0].text!.isNotEmpty() {
                    team.name = alert.textFields![0].text!
                    self.teamsTable.reloadData()
                }
                self.view.endEditing(true)
            }
//            let delete = UIAlertAction(title: "Delete", style: .destructive) {
//                (alertAction) in
//                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//                self.teams.removeObject(at: indexPath.row)
//                self.teamsTable.deleteRows(at: [indexPath], with: .automatic)
//                context.delete(team)
//            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) {
                (alertAction) in
                self.view.endEditing(true)
            }
            alert.addTextField {
                (textField) in
                textField.text = team.name
            }
            alert.addAction(rename)
//            alert.addAction(delete)
            alert.addAction(cancel)
            present(alert, animated:true, completion: nil)
//        }
    }

    // MARK: - Table Stuff -

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return teams.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.showsReorderControl = true
        if let team = teams[indexPath.row] as? Team
        {
            cell.textLabel?.text = team.name
        }
        return cell
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

//    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        let movedObject = teams[sourceIndexPath.row] as! Team
        teams.removeObject(at: sourceIndexPath.row)
        teams.insert(movedObject, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
//        let deleteAction = self.contextualDeleteAction(forRowAtIndexPath: indexPath)
//        deleteAction.backgroundColor = Scarlet
        let renameAction = self.contextualRenameAction(forRowAtIndexPath: indexPath)
        renameAction.backgroundColor = Marine
        let swipeConfig = UISwipeActionsConfiguration(actions: [renameAction])
        return swipeConfig
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let deleteAction = self.contextualDeleteAction(forRowAtIndexPath: indexPath)
        deleteAction.backgroundColor = Scarlet
//        let renameAction = self.contextualRenameAction(forRowAtIndexPath: indexPath)
//        renameAction.backgroundColor = Marine
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfig
    }

    func contextualDeleteAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction
    {
        let team = self.teams[indexPath.row] as! Team
        let action = UIContextualAction(style: .normal,
                                        title: "Delete") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
                                            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                                            self.teams.removeObject(at: indexPath.row)
                                            self.teamsTable.deleteRows(at: [indexPath], with: .automatic)
                                            context.delete(team)
                                            completionHandler(false)
        }
        return action
    }

    func contextualRenameAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction
    {
        let team = teams[indexPath.row] as! Team
        let action = UIContextualAction(style: .normal,
                                        title: "Rename") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
                                            self.renamePopup(team)
                                            completionHandler(false)
        }
        return action
    }
}
