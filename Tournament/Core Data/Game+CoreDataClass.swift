//
//  Game+CoreDataClass.swift
//  CasualTournament
//
//  Created by TJ Sartain on 8/28/18.
//  Copyright © 2018 iTrinity, Inc. All rights reserved.
//
//

import UIKit
import CoreData


public class Game: NSManagedObject
{
    var gameView = GameView()
    var topTeamButton = TeamButton()
    var bottomTeamButton = TeamButton()
    var finalTopTeamButton = TeamButton()
    var finalBottomTeamButton = TeamButton()
    
    public override var description: String
    {
        let t1 = top_team != nil ? top_team!.name : topTeamButton.placeHolder != nil ? topTeamButton.placeHolder! : "???"
        let t2 = bottom_team != nil ? bottom_team!.name : bottomTeamButton.placeHolder != nil ? bottomTeamButton.placeHolder! : "???"
        let w = winner != nil ? " (w: \(winner!.name ?? "???"))" : ""
        return "Game \(number): \(t1 ?? "???") vs \(t2 ?? "???") \(w)"
    }

    func commonInit(_ n: Int, _ wtt: Bool, _ ltt: Bool, _ wft: Bool, _ wfb: Bool)
    {
        number = Int64(n)
        winner_to_top = wtt
        loser_to_top = ltt
        winner_from_top = wft
        winner_from_bottom = wfb
        setupViews()
    }
    
    func config(_ wg: Game?, _ lg: Game?, _ ts: Game?, _ bs: Game?)
    {
        winnerGame = wg
        loserGame = lg
        topSource = ts
        bottomSource = bs
    }

    func setTeam(_ team: Team?, top: Bool)
    {
        if top {
            top_team = team
            topTeamButton.team = team
            topTeamButton.text = team?.name ?? ""
        } else {
            bottom_team = team
            bottomTeamButton.team = team
            bottomTeamButton.text = team?.name ?? ""
        }
        if number == Int64(theTournament.bracketSize) {
            if top {
                finalTopTeamButton.team = team
                finalTopTeamButton.text = team?.name ?? ""
            } else {
                finalBottomTeamButton.team = team
                finalBottomTeamButton.text = team?.name ?? ""
            }
        }
    }

    func setupViews()
    {
        print("Setting up Game View \(number)")
        gameView.tag = Int(number)

        topTeamButton.tag = Int(1000 + number)
        topTeamButton.game = self

        bottomTeamButton.tag = Int(2000 + number)
        bottomTeamButton.game = self

        if number == Int64(theTournament.bracketSize) {
            finalTopTeamButton.tag = Int(1000 + number)
            finalTopTeamButton.game = self
            finalBottomTeamButton.tag = Int(2000 + number)
            finalBottomTeamButton.game = self
        }
    }

    func createViewsX()
    {
        print("Creating views for game \(number)")
        gameView = GameView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        gameView.tag = Int(number)

        topTeamButton = TeamButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        topTeamButton.tag = Int(1000 + number)
        topTeamButton.game = self
        if let topTeam = top_team {
            topTeamButton.team = topTeam
        }

        bottomTeamButton = TeamButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bottomTeamButton.tag = Int(2000 + number)
        bottomTeamButton.game = self
        if let bottomTeam = bottom_team {
            bottomTeamButton.team = bottomTeam
        }

        if number == Int64(theTournament.bracketSize) {
            finalTopTeamButton = TeamButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            finalTopTeamButton.tag = Int(1000 + number)
            finalTopTeamButton.game = self
            finalBottomTeamButton = TeamButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            finalBottomTeamButton.tag = Int(2000 + number)
            finalBottomTeamButton.game = self
        }
    }
}
