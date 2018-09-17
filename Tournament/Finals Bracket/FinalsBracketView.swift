//
//  FinalsBracketView.swift
//  CasualTournament
//
//  Created by TJ Sartain on 9/10/18.
//  Copyright © 2018 iTrinity, Inc. All rights reserved.
//

import UIKit
import CoreData

class FinalsBracketView: UIView
{
    var winnerTeamButton = TeamButton()
    var finalGame = Game()
    var finalFinal = Game()
    var cell = CGSize(width: 0, height: 0)
    lazy var context: NSManagedObjectContext = {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }()
    @IBOutlet weak var firstPlaceMedal: UIImageView!
    @IBOutlet weak var secondPlaceMedal: UIImageView!
    @IBOutlet weak var upperBracketWinner: UILabel!
    @IBOutlet weak var lowerBracketWinner: UILabel!

    func setupView()
    {
        for view in subviews { if view.tag > 0 { view.removeFromSuperview() } }

        finalGame = theTournament.games?[theTournament.bracketSize-1] as! Game
        insertSubview(finalGame.gameView, at: 0)
        addSubview(finalGame.finalTopTeamButton)
        finalGame.finalTopTeamButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        addSubview(finalGame.finalBottomTeamButton)
        finalGame.finalBottomTeamButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        finalFinal = theTournament.games?[2*(theTournament.bracketSize-1)] as! Game
        finalFinal.setupViews()
        finalFinal.gameView.state = .optional
        insertSubview(finalFinal.gameView, at: 0)
        addSubview(finalFinal.topTeamButton)
        finalFinal.topTeamButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        addSubview(finalFinal.bottomTeamButton)
        finalFinal.bottomTeamButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        addSubview(winnerTeamButton)
        winnerTeamButton.team = finalFinal.winner

        if finalFinal.winner != nil // we played the optional game
        {
            setupForOptionalWasPlayed()
        }
        else if finalGame.winner != nil  // we only played the final
        {
            setupForFinalWasPlayed()
        }
        else // we haven't played the final yet
        {
            setupForFinalToBePlayed()
        }
    }

    func setupForFinalToBePlayed()
    {
        print("FinalsBracketView setupForFinalToBePlayed")

        finalFinal.gameView.state = .optional
        finalFinal.bottomTeamButton.isHidden = false
        winnerTeamButton.isHidden = true
        firstPlaceMedal.isHidden = true
        secondPlaceMedal.isHidden = true
    }
    
    func setupForFinalWasPlayed()
    {
        if finalGame.winner == finalGame.top_team { // tournament is over
            print("FinalsBracketView setupForFinalWasPlayed tournament is over")

            finalFinal.gameView.state = .hidden
            finalFinal.bottomTeamButton.isHidden = true
            winnerTeamButton.isHidden = true
            firstPlaceMedal.isHidden = false
            secondPlaceMedal.isHidden = false
        } else {
            // no winner yet
            print("FinalsBracketView setupForFinalWasPlayed no winner yet")

            finalFinal.gameView.state = .normal
            finalFinal.bottomTeamButton.isHidden = false
            winnerTeamButton.isHidden = true
            firstPlaceMedal.isHidden = true
            secondPlaceMedal.isHidden = true
        }
    }

    func setupForOptionalWasPlayed()
    {
        print("FinalsBracketView setupForOptionalWasPlayed")

        finalFinal.gameView.state = .normal
        finalFinal.bottomTeamButton.isHidden = false
        winnerTeamButton.isHidden = false
        firstPlaceMedal.isHidden = false
        secondPlaceMedal.isHidden = false
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        print("FinalsBracketView layoutSubviews")

        cell = CGSize(width: 200, height: 50)

        // Single Elimination Final Game

        let finalGame = theTournament.games?[theTournament.bracketSize-1] as! Game
        finalGame.gameView.frame = CGRect(x: (bounds.width - cell.width)/2 - cell.width,
                                        y: bounds.height/2 - 3*cell.height,
                                        width: cell.width,
                                        height: 4 * cell.height)
        finalGame.finalTopTeamButton.frame = CGRect(x: finalGame.gameView.frame.midX - theTournament.teamLabelWidth / 2,
                                y: finalGame.gameView.frame.minY - theTournament.teamLabelHeight / 2,
                                width: theTournament.teamLabelWidth,
                                height: theTournament.teamLabelHeight)
        finalGame.finalBottomTeamButton.frame = CGRect(x: finalGame.gameView.frame.midX - theTournament.teamLabelWidth / 2,
                                   y: finalGame.gameView.frame.maxY - theTournament.teamLabelHeight / 2,
                                   width: theTournament.teamLabelWidth,
                                   height: theTournament.teamLabelHeight)

        // Double Elimination Final Game

        let finalFinal = theTournament.games?[2*(theTournament.bracketSize-1)] as! Game
        finalFinal.gameView.frame = CGRect(x: (bounds.width - cell.width)/2,
                                           y: bounds.height/2 - cell.height,
                                           width: cell.width,
                                           height: 4 * cell.height)
        finalFinal.topTeamButton.frame = CGRect(x: finalFinal.gameView.frame.midX - theTournament.teamLabelWidth / 2,
                                                y: finalFinal.gameView.frame.minY - theTournament.teamLabelHeight / 2,
                                                width: theTournament.teamLabelWidth,
                                                height: theTournament.teamLabelHeight)
        finalFinal.bottomTeamButton.frame = CGRect(x: finalFinal.gameView.frame.midX - theTournament.teamLabelWidth / 2,
                                                   y: finalFinal.gameView.frame.maxY - theTournament.teamLabelHeight / 2,
                                                   width: theTournament.teamLabelWidth,
                                                   height: theTournament.teamLabelHeight)

        winnerTeamButton.frame = CGRect(x: finalFinal.gameView.frame.maxX + (cell.width - theTournament.teamLabelWidth) / 2,
                                        y: finalFinal.gameView.frame.midY - theTournament.teamLabelHeight / 2,
                                        width: theTournament.teamLabelWidth,
                                        height: theTournament.teamLabelHeight)

        // Labels for Bracket Winners
        
        let upperFrame = upperBracketWinner.frame.offsetBy(dx: finalGame.gameView.frame.minX - upperBracketWinner.frame.maxX,
                                                           dy: finalGame.gameView.frame.minY - upperBracketWinner.frame.midY)
        upperBracketWinner.frame = upperFrame
        
        let lowerFrame = lowerBracketWinner.frame.offsetBy(dx: finalGame.gameView.frame.minX - lowerBracketWinner.frame.maxX,
                                                           dy: finalGame.gameView.frame.maxY - lowerBracketWinner.frame.midY)
        lowerBracketWinner.frame = lowerFrame

        // Layout for 1st and 2nd Place Medals
        
        if finalFinal.winner != nil {
            layoutForOptionalWasPlayed()
        } else if finalGame.winner != nil {
            layoutForFinalWasPlayed()
        }
    }
    
    func layoutForOptionalWasPlayed() // we played the optional finalFinal game
    {
        firstPlaceMedal.center = CGPoint(x: finalFinal.gameView.frame.maxX + cell.width,
                                         y: finalFinal.gameView.frame.midY)
        if finalFinal.winner == finalFinal.top_team {
            secondPlaceMedal.center = CGPoint(x: finalFinal.gameView.frame.maxX,
                                              y: finalFinal.gameView.frame.maxY)
        } else {
            secondPlaceMedal.center = CGPoint(x: finalFinal.gameView.frame.maxX,
                                              y: finalFinal.gameView.frame.minY)
        }
    }
    
    func layoutForFinalWasPlayed()  // we only played the final
    {
        if finalGame.winner == finalGame.top_team {
            firstPlaceMedal.center = CGPoint(x: finalGame.gameView.frame.maxX + cell.width,
                                             y: finalGame.gameView.frame.midY)
            secondPlaceMedal.center = CGPoint(x: finalGame.gameView.frame.maxX,
                                              y: finalGame.gameView.frame.maxY)
        }
    }

    override func draw(_ rect: CGRect)
    {
        print("FinalsBracketView draw")
        let finalFinal = theTournament.games?[2*(theTournament.bracketSize-1)] as! Game
        if finalFinal.gameView.state != .hidden {
            if finalFinal.gameView.state == .normal {
                print("FinalsBracketView draw state == .normal")
                normalLineColor.setStroke()
            } else {
                print("FinalsBracketView draw state != .normal")
                optionalLineColor.setStroke()
            }
            let path = UIBezierPath() // the last winner line
            let x = finalFinal.gameView.frame.maxX
            let y = finalFinal.gameView.frame.midY
            print(cell, finalFinal.gameView.frame, rect, bounds)
            path.move(to: CGPoint(x: x, y: y))
            path.addLine(to: CGPoint(x: x + cell.width, y: y))
            path.lineWidth = 1
            if finalFinal.gameView.state == .optional {
                print("FinalsBracketView draw state == .optional")
                path.setLineDash([5, 3], count: 2, phase: 0)
            }
            path.stroke()
        }
    }

    override func setNeedsDisplay() {
        redrawGameViews()
        super.setNeedsDisplay()
    }

    func redrawGameViews()
    {
        for view in subviews { if view.isMember(of: GameView.self) { view.setNeedsDisplay() } }
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
                    if let topTeam = game.top_team, let bottomTeam = game.bottom_team
                    {
                        if game.number == theTournament.bracketSize {
                            if team == topTeam {
                                print("\(team) is the tournament winner!")
                                game.winner = team
                                game.winnerGame?.setTeam(team, top: true)
                                let loserFinal = theTournament.games?[2*(theTournament.bracketSize-1)-1] as! Game
                                setWinners(team,
                                           bottomTeam,
                                           loserFinal.top_team == bottomTeam ? loserFinal.bottom_team : loserFinal.top_team)
                            } else {
                                apply(winner: bottomTeam, to: game, loser: topTeam)
                            }
                            setupForFinalWasPlayed()
                            layoutForFinalWasPlayed()
                        } else {
                            print("\(team) is the tournament winner!")
                            game.winner = team
                            let loserFinal = theTournament.games?[2*(theTournament.bracketSize-1)-1] as! Game
                            setWinners(team,
                                       game.top_team == team ? game.bottom_team : game.top_team,
                                       loserFinal.bottom_team == bottomTeam ? loserFinal.top_team : loserFinal.bottom_team)
                            winnerTeamButton.team = team
                            setupForOptionalWasPlayed()
                            layoutForOptionalWasPlayed()
                        }
                        setNeedsDisplay()
                        do { try self.context.save() } catch { }
                    }
                }
            }
        }
    }

    func setWinners(_ first: Team, _ second: Team?, _ third: Team?)
    {
        theTournament.winner = first
        theTournament.second = second
        theTournament.third = third
    }
}
