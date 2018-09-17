//
//  BracketViewController.swift
//  Tournament
//
//  Created by TJ Sartain on 8/19/18.
//  Copyright © 2018 iTrinity, Inc. All rights reserved.
//

import UIKit

class UpperBracketVC: UIViewController
{
//    @IBOutlet weak var tournamentLabel: UILabel!
    @IBOutlet weak var mainBracketView: MainBracketView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        mainBracketView.parent = self
//        tournamentLabel.text = theTournament.name
        mainBracketView.setupView()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        if let game = theTournament.games?[theTournament.bracketSize-1] as? Game {
            game.topTeamButton.team = game.top_team
        }
//        if UIDevice.current.orientation.isLandscape {
//            tournamentLabel.font = UIFont.boldSystemFont(ofSize: 54)
//        } else {
//            tournamentLabel.font = UIFont.boldSystemFont(ofSize: 36)
//        }
    }

//    @IBAction func goHome(_ sender: UIButton)
//    {
//        AppDelegate.show(controller: "Home", storyboard: "Main")
//    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        mainBracketView.redrawGameViews()
        mainBracketView.setNeedsDisplay()
//        if UIDevice.current.orientation.isLandscape {
//            tournamentLabel.font = UIFont.boldSystemFont(ofSize: 54)
//        } else {
//            tournamentLabel.font = UIFont.boldSystemFont(ofSize: 36)
//        }
    }
}
