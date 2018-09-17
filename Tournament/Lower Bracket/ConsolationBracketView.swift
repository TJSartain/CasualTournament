//
//  ConsolationBracket.swift
//  Tournament
//
//  Created by TJ Sartain on 8/22/18.
//  Copyright © 2018 iTrinity, Inc. All rights reserved.
//

import UIKit

class ConsolationBracketView: UIView
{
    var gamesInView: Int = 0
    var teamCount: Int = 0
    var rounds: Int = 0
    var noTopGame = false
    var noBottomGame = false
    @IBOutlet weak var thirdPlaceMedal: UIImageView!

    var cell = CGSize(width: 0, height: 0)

    func redrawGameViews()
    {
        for view in subviews
        {
            if view.isMember(of: GameView.self)
            {
                view.setNeedsDisplay()
            }
        }
    }
    
    func setupView()
    {
        for view in subviews
        {
            if view.tag > 0 {
                view.removeFromSuperview()
            }
        }
        teamCount = theTournament.bracketSize / 2
        gamesInView = theTournament.bracketSize - 2
        rounds = Int(log2(Double(teamCount)))
        for g in 0..<gamesInView {
            if let game = theTournament.games?[g+2*teamCount] as? Game
            {
                game.setupViews()
//                addSubview(game.button)
                insertSubview(game.gameView, at: 0)
                addSubview(game.topTeamButton)
                game.topTeamButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                if game.number <= gamesInView + theTournament.bracketSize {
                    addSubview(game.bottomTeamButton)
                    game.bottomTeamButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                }
            }
        }
        if let game = theTournament.games?[theTournament.bracketSize-1] as? Game {
            addSubview(game.bottomTeamButton)
        }
        if let game = theTournament.games?[2*(theTournament.bracketSize-1)-1] as? Game {
            thirdPlaceMedal.isHidden = (game.winner == nil)
        }
    }
    
    func allByes() -> Bool
    {
        let gameID = 1 + 2 * teamCount
        let games = teamCount / 2
        for g in gameID..<gameID+games
        {
            if let game = theTournament.games?[g-1] as? Game
            {
                if ((game.top_team == nil || game.top_team!.name != "bye") &&
                    (game.bottom_team == nil || game.bottom_team!.name != "bye"))
                {
                    return false
                }
            }
        }
        return true
    }
    
    func topOrBottom()
    {
        let gameID = 1 + 2 * teamCount
        let games = teamCount / 2
        let allByes = self.allByes()
        let topID = gameID + (allByes ? games : 0)
        let bottomID = gameID+games-1 + (allByes ? games : 0)
        
        noTopGame = false
        if let game = theTournament.games?[topID-1] as? Game
        {
            if let t = game.top_team, let b = game.bottom_team {
                if t.name == "bye" || b.name == "bye" {
                    noTopGame = true
//                    print("No top \(gameID)")
                }
            }
        }
        noBottomGame = false
        if let game = theTournament.games?[bottomID-1] as? Game
        {
            if let t = game.top_team, let b = game.bottom_team {
                if t.name == "bye" || b.name == "bye" {
                    noBottomGame = true
//                    print("No bottom \(gameID)")
                }
            }
        }
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        teamCount = theTournament.bracketSize / 2
        gamesInView = theTournament.bracketSize - 2
        rounds = Int(log2(Double(teamCount)))

        var gameID = 1 + 2 * teamCount
        var games = teamCount / 2
        let allByes = self.allByes()
        topOrBottom()
        cell = CGSize(width: bounds.width / CGFloat(2 * rounds + 1 - (allByes ? 1 : 0)),
                      height: bounds.height / CGFloat(2 * (teamCount + rounds - 2) + 1 - (allByes ? 1 : 0) - (noBottomGame ? 1 : 0)))

        for r in 0..<rounds
        {
            for i in 0..<2
            {
                for g in 0..<games
                {
                    var hidden = false
                    if let game = theTournament.games?[gameID-1] as? Game
                    {
                        if let t = game.top_team, t.name == "bye" {
                            hidden = true
                        } else if let b = game.bottom_team, b.name == "bye" {
                            hidden = true
                        }
                        let left = CGFloat(2 * r + i - (allByes ? 1 : 0)) * cell.width
                        let pr1 = pow(2, CGFloat(r+1))
                        let pr = pow(2, CGFloat(r))
                        let yOffset = CGFloat(2 * (rounds - 1)) - CGFloat(i) * pr + 1
                        let yDelta = 4 * pr
                        if let button = viewWithTag(gameID) as? GameView {
                            button.isHidden = hidden
                            button.frame = CGRect(x: left,
                                                  y: ((yOffset + CGFloat(g) * yDelta) - 0.5) * cell.height,
                                                  width: cell.width, // right margin for text
                                height: pr1 * cell.height)
                            if let topTeamButton = viewWithTag(1000 + gameID) as? TeamButton {
                                topTeamButton.isHidden = hidden
                                topTeamButton.frame = CGRect(x: button.frame.midX - theTournament.teamLabelWidth / 2,
                                                        y: button.frame.minY - theTournament.teamLabelHeight / 2,
                                                        width: theTournament.teamLabelWidth,
                                                        height: theTournament.teamLabelHeight)
                            }
                            if let bottomTeamButton = viewWithTag(2000 + gameID) as? TeamButton {
                                bottomTeamButton.isHidden = hidden
                                bottomTeamButton.frame = CGRect(x: button.frame.midX - theTournament.teamLabelWidth / 2,
                                                           y: button.frame.maxY - theTournament.teamLabelHeight / 2,
                                                           width: theTournament.teamLabelWidth,
                                                           height: theTournament.teamLabelHeight)
                            }
                        }
                    }
                    gameID += 1
                }
            }
            games /= 2
        }
        if let game = theTournament.games?[theTournament.bracketSize-1] as? Game
        {
            if let button = viewWithTag(2*(gamesInView+1)) as? GameView {
                let bottomTeamButton = game.bottomTeamButton
                bottomTeamButton.frame = CGRect(x: button.frame.maxX + (cell.width - theTournament.teamLabelWidth) / 2,
                                           y: button.frame.midY - theTournament.teamLabelHeight / 2,
                                           width: theTournament.teamLabelWidth,
                                           height: theTournament.teamLabelHeight)
            }
        }

        layoutForThirdPlaceMedal()
    }

    func layoutForThirdPlaceMedal()
    {
        if let game = theTournament.games?[2*(theTournament.bracketSize-1)-1] as? Game {
            if game.winner != nil {
                if game.winner == game.bottom_team {
                    thirdPlaceMedal.center = CGPoint(x: game.gameView.frame.maxX,
                                                     y: game.gameView.frame.minY)
                } else {
                    thirdPlaceMedal.center = CGPoint(x: game.gameView.frame.maxX,
                                                     y: game.gameView.frame.maxY)
                }
            }
        }
    }

    override func draw(_ rect: CGRect)
    {
        normalLineColor.setStroke()
        let path = UIBezierPath() // the last winner line
        let button = viewWithTag(2*(gamesInView+1)) as! GameView
        let y = button.frame.midY
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY+y))
        path.addLine(to: CGPoint(x: rect.maxX-rect.width/CGFloat(2 * rounds + 1 - (allByes() ? 1 : 0)), y: rect.minY+y))
        path.lineWidth = 1
        path.stroke()
    }

    @objc @IBAction func buttonTapped(_ sender: UIButton)
    {
        if hasEnded() {
            alert(title: "\(theTournament.name!) has already ended",
            message: "No changes allowed.") { (action) in }
        } else {
            if let teamButton = sender as? TeamButton
            {
                if let game = teamButton.game, let team = teamButton.team
                {
                    if let topTeam = game.top_team, let name = topTeam.name, name.count > 0 && name != "bye"
                    {
                        if let bottomTeam = game.bottom_team, let name = bottomTeam.name, name.count > 0 && name != "bye"
                        {
                            if team == topTeam {
                                apply(winner: topTeam, to: game, loser: bottomTeam)
                                //                            applyResultCD(game, topTeam, bottomTeam)
                            } else {
                                apply(winner: bottomTeam, to: game, loser: topTeam)
                                //                            applyResultCD(game, bottomTeam, topTeam)
                            }
                            if game.number == 2*(theTournament.bracketSize-1) {
                                thirdPlaceMedal.isHidden = false
                                layoutForThirdPlaceMedal()
                                thirdPlaceMedal.setNeedsDisplay()
                            }
                        }
                    }
                }
            }
        }
    }
}
