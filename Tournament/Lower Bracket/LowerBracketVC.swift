//
//  ConsolationViewController.swift
//  Tournament
//
//  Created by TJ Sartain on 8/22/18.
//  Copyright © 2018 iTrinity, Inc. All rights reserved.
//

import UIKit

class LowerBracketVC: UIViewController
{
    @IBOutlet weak var consolationBracketView: ConsolationBracketView!
//    @IBOutlet weak var tournamentLabel: UILabel!

    override func viewDidLoad()
    {
        super.viewDidLoad()

//        tournamentLabel.text = theTournament.name
        consolationBracketView.setupView()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
//        if UIDevice.current.orientation.isLandscape {
//            tournamentLabel.font = UIFont.boldSystemFont(ofSize: 54)
//        } else {
//            tournamentLabel.font = UIFont.boldSystemFont(ofSize: 36)
//        }

        // apply backward and forward placeholders
        
        for g in 0..<2*theTournament.bracketSize-1
        {
            if let game = theTournament.games?[g] as? Game {
                if let loserGame = game.loserGame {
                    let placeholder = "Loser of \(game.number)"
                    if game.loser_to_top {
                        loserGame.topTeamButton.placeHolder = placeholder
                    } else {
                        loserGame.bottomTeamButton.placeHolder = placeholder
                    }
                }
            }
        }
        
        for g in theTournament.bracketSize..<theTournament.bracketSize*3/2
        {
            if let game = theTournament.games?[g] as? Game {
                if let winnerGame = game.winnerGame {
                    if let topTeam = game.top_team, topTeam.name == "bye" {
                        let placeholder = game.bottomTeamButton.placeHolder
                        if game.winner_to_top {
                            winnerGame.topTeamButton.placeHolder = placeholder
                        } else {
                            winnerGame.bottomTeamButton.placeHolder = placeholder
                        }
                    } else if let bottomTeam = game.bottom_team, bottomTeam.name == "bye" {
                        let placeholder = game.topTeamButton.placeHolder
                        if game.winner_to_top {
                            winnerGame.topTeamButton.placeHolder = placeholder
                        } else {
                            winnerGame.bottomTeamButton.placeHolder = placeholder
                        }
                    }
                }
            }
        }
        
        for g in 1..<theTournament.bracketSize-1
        {
            if let game = theTournament.games?[theTournament.bracketSize+g] as? Game {
                game.topTeamButton.team = game.top_team
                game.bottomTeamButton.team = game.bottom_team
            }
        }
        if let game = theTournament.games?[theTournament.bracketSize-1] as? Game {
            game.bottomTeamButton.team = game.bottom_team
        }
    }

//    @IBAction func goHome(_ sender: UIButton)
//    {
//        AppDelegate.show(controller: "Home", storyboard: "Main")
//    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        consolationBracketView.redrawGameViews()
//        if UIDevice.current.orientation.isLandscape {
//            tournamentLabel.font = UIFont.boldSystemFont(ofSize: 54)
//        } else {
//            tournamentLabel.font = UIFont.boldSystemFont(ofSize: 36)
//        }
    }
}
