//
//  MainBracketView.swift
//  Tournament
//
//  Created by TJ Sartain on 8/19/18.
//  Copyright © 2018 iTrinity, Inc. All rights reserved.
//

import UIKit

class MainBracketView: UIView
{
    var parent: UpperBracketVC?
    var gamesInView: Int = 0
    var teamCount: Int = 0
    var rounds: Int = 0

    var cell = CGSize(width: 0, height: 0)

    var skipOne = false
    var noTopGame = false
    var noBottomGame = false

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
            if view.tag > 0 { view.removeFromSuperview() }
        }
        teamCount = theTournament.bracketSize
        gamesInView = teamCount - 1
        rounds = Int(log2(Double(teamCount)))
        for g in 0..<gamesInView
        {
            if let game = theTournament.games?[g] as? Game
            {
                game.setupViews()
                addSubview(game.gameView)
                addSubview(game.topTeamButton)
                game.topTeamButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                if game.number <= gamesInView {
                    addSubview(game.bottomTeamButton)
                    game.bottomTeamButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                }
            }
        }
        if let game = theTournament.games?[gamesInView] as? Game {
            game.setupViews()
            addSubview(game.topTeamButton)
        }

        for i in 0...gamesInView
        {
            if let game = theTournament.games?[i] as? Game {
                game.setTeam(game.top_team, top: true)
                game.setTeam(game.bottom_team, top: false)
            }
        }

        setNeedsDisplay()
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        if subviews.count < 1 { return }
        teamCount = theTournament.bracketSize
        gamesInView = teamCount - 1
        rounds = Int(log2(Double(teamCount)))

        noTopGame = false
        if let game = theTournament.games?[0] as? Game
        {
            if let t = game.top_team, let b = game.bottom_team {
                if t.name == "bye" || b.name == "bye" {
                    noTopGame = true
                }
            }
        }
        noBottomGame = false
        if let game = theTournament.games?[theTournament.bracketSize/2-1] as? Game
        {
            if let t = game.top_team, let b = game.bottom_team {
                if t.name == "bye" || b.name == "bye" {
                    noBottomGame = true
                }
            }
        }

        cell = CGSize(width: bounds.width / CGFloat(rounds + 1),
                      height: bounds.height / CGFloat(2 * theTournament.bracketSize - (noTopGame ? 1 : 0) - (noBottomGame ? 1 : 0)))

        theTournament.teamLabelWidth = 116 // bounds.width / CGFloat(rounds + 2) - 4
        theTournament.teamLabelHeight = 36 // h - 4

        var i = 1
        var games = teamCount / 2
        for r in 0..<rounds
        {
            for g in 0..<games
            {
                var hidden = false
                if let game = theTournament.games?[i-1] as? Game
                {
                    if let t = game.top_team, let b = game.bottom_team {
                        if t.name == "bye" || b.name == "bye" {
                            hidden = true
                        }
                    }

                    if let button = viewWithTag(i) as? GameView {
                        button.isHidden = hidden
                        let pr2 = pow(2, CGFloat(r+2)) //  4,
                        let pr1 = pow(2, CGFloat(r+1)) //  2,
                        let pr = pow(2, CGFloat(r))    //  1,
                        button.frame = CGRect(x: CGFloat(r) * cell.width,
                                              y: (CGFloat(g) * pr2 + pr - (noTopGame ? 1 : 0)) * cell.height,
                                              width: cell.width,
                                              height: pr1 * cell.height)
//                        print(i, r, g, pr2, pr1, pr, button.frame.minY)
                        if let topTeamButton = viewWithTag(1000 + i) as? TeamButton {
                            topTeamButton.isHidden = hidden
                            topTeamButton.frame = CGRect(x: button.frame.midX - theTournament.teamLabelWidth / 2,
                                                    y: button.frame.minY - theTournament.teamLabelHeight / 2,
                                                    width: theTournament.teamLabelWidth,
                                                    height: theTournament.teamLabelHeight)
                        }
                        if let bottomTeamButton = viewWithTag(2000 + i) as? TeamButton {
                            bottomTeamButton.isHidden = hidden
                            bottomTeamButton.frame = CGRect(x: button.frame.midX - theTournament.teamLabelWidth / 2,
                                                       y: button.frame.maxY - theTournament.teamLabelHeight / 2,
                                                       width: theTournament.teamLabelWidth,
                                                       height: theTournament.teamLabelHeight)
                        }
                    }
                }
                i += 1
            }
            games /= 2
        }

        if let game = theTournament.games?[gamesInView] as? Game
        {
            if let button = viewWithTag(gamesInView) as? GameView {
                let topTeamButton = game.topTeamButton
                topTeamButton.frame = CGRect(x: button.frame.maxX + (cell.width - theTournament.teamLabelWidth) / 2,
                                        y: button.frame.midY - theTournament.teamLabelHeight / 2,
                                        width: theTournament.teamLabelWidth,
                                        height: theTournament.teamLabelHeight)
            }
        }
    }

    override func draw(_ rect: CGRect)
    {
        // the last winner line
        normalLineColor.setStroke()
        let path = UIBezierPath()
        let button = viewWithTag(gamesInView) as! GameView
        let y = button.frame.midY
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY + y))
        path.addLine(to: CGPoint(x: rect.maxX - cell.width, y: rect.minY + y))
        path.lineWidth = 1
        path.stroke()

//        UIColor.red.setStroke()
//        for x in 0...10 {
//            let path = UIBezierPath()
//            path.move(to: CGPoint(x: rect.minX+CGFloat(x)*cell.width, y: rect.minY))
//            path.addLine(to: CGPoint(x: rect.minX+CGFloat(x)*cell.width, y: rect.maxY))
//            path.lineWidth = 1
//            path.stroke()
//        }
//        for y in 0...50 {
//            let path = UIBezierPath()
//            path.move(to: CGPoint(x: rect.minX, y: rect.minY+CGFloat(y)*cell.height))
//            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY+CGFloat(y)*cell.height))
//            path.lineWidth = 1
//            path.stroke()
//        }
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
                        }
                    }
                }
            }
        }
    }

    /*

     if game.winner == topTeam {
     // do nothing
     } else if game.winner == nil {
     // apply
     } else {
     // warn about altering future games
     // if OK, wipe future, then apply

     /* wiping future: start queue with game.top
     while queue is not empty
     pop queue, clear game.position
     add winnergame.position to queue
     add loergame.position to queue
     */
     }

 */

}
