//
//  HistoryViewController.swift
//  CasualTournament
//
//  Created by TJ Sartain on 8/31/18.
//  Copyright © 2018 iTrinity, Inc. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate
{
    @IBOutlet weak var tourneysTable: UITableView!
    @IBOutlet var messageLabel: UILabel!
    lazy var context: NSManagedObjectContext = {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext }()
    var tourneys = [Tournament]() {
        didSet { updateView() } }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        messageLabel.text = "You have no tournaments."
        do {
            try self.fetchedResultsController.performFetch()
            tourneys = fetchedResultsController.fetchedObjects!
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request for Tournaments")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        self.updateView()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        if let path = tourneysTable.indexPathForSelectedRow {
            tourneysTable.deselectRow(at: path, animated: false)
        }
    }

    private func updateView()
    {
        let count = self.fetchedResultsController.sections?[0].numberOfObjects ?? 0
        let hasTourneys = count > 0
        tourneysTable.isHidden = !hasTourneys
        messageLabel.isHidden = hasTourneys
    }

    // MARK: - Actions -

    // MARK: - Core Data -

    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Tournament> =
    {
        let fetchRequest: NSFetchRequest<Tournament> = Tournament.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        tourneysTable.reloadData()
    }

    // MARK: - Table Stuff -

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tourney", for: indexPath) as! TourneyTableViewCell
        let tourney = fetchedResultsController.object(at: indexPath)

        cell.nameLabel.text = tourney.name

        if let date = tourney.date as Date? {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy"
            cell.dateLabel.text = formatter.string(from: date)
        } else {
            cell.dateLabel.text = ""
        }

        cell.locationLabel.text = tourney.location

        cell.winnerLabel.text = " "
        cell.secondLabel.text = "In Progress"
        cell.thirdLabel.text = " "
        cell.secondLabel.textColor = .white
        if let winner = tourney.winner {
            cell.winnerLabel.textColor = winner.color1
            cell.winnerLabel.text = winner.name!
            if let second = tourney.second {
                cell.secondLabel.textColor = second.color1
                cell.secondLabel.text = second.name!
                if let third = tourney.third {
                    cell.thirdLabel.textColor = third.color1
                    cell.thirdLabel.text = third.name!
                }
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        theTournament = fetchedResultsController.object(at: indexPath)
        theTournament.bracketSize = theTournament.teams!.count
        print(theTournament)
        performSegue(withIdentifier: "Past Tournament", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deleteTourneyAt(indexPath)
        }
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Delete" , handler: { (action:UITableViewRowAction!, indexPath:IndexPath!) -> Void in
            self.deleteTourneyAt(indexPath)
        })
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let deleteAction = self.contextualDeleteAction(forRowAtIndexPath: indexPath)
        deleteAction.backgroundColor = Scarlet
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfig
    }

    func contextualDeleteAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction
    {
        let action = UIContextualAction(style: .normal,
                                        title: "Delete") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
                                            self.deleteTourneyAt(indexPath)
                                            completionHandler(true)
        }
        return action
    }
    
    func deleteTourneyAt(_ indexPath : IndexPath)
    {
        let tourney = fetchedResultsController.object(at: indexPath)
        self.context.delete(tourney)
        do {
            try self.context.save()
            updateView()
        } catch {}
    }
}
