//
//  Tournament+CoreDataClass.swift
//  CasualTournament
//
//  Created by TJ Sartain on 8/28/18.
//  Copyright © 2018 iTrinity, Inc. All rights reserved.
//
//

import UIKit
import CoreData


public class Tournament: NSManagedObject
{
    var bracketSize = 0
    var teamLabelWidth: CGFloat = 0
    var teamLabelHeight: CGFloat = 0
    public override var description: String
    {
        var teamDesc = "Teams: \n"
        for team in teams! {
            teamDesc += "\(team) \n"
        }
        var gameDesc = "Games: \n"
        for game in games! {
            gameDesc += "\(game) \n"
        }
        return "\(teamDesc)\(gameDesc)"
    }

    func setup(_ teams: NSMutableOrderedSet)
    {
        // create all teams with placeholder name: bye

        bracketSize = Int(pow(2, ceil(log2(Double(teams.count)))))
        let set = Int(ceil(log2(Double(bracketSize)))) - 3

        // spread team names input over the range

        for _ in teams.count..<bracketSize
        {
            let team = newTeam("bye")
            team.seed = 999
            teams.add(team)
        }
        for i in 0..<bracketSize
        {
            if let team = teams[seeds[set][i]-1] as? Team {
                theTournament.addToTeams(team)
            }
        }
        
        // create all the games with positional info

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        gameEntity = NSEntityDescription.entity(forEntityName: "Game", in: context)!
        if let games = theTournament.games, games.count > 0 {
            theTournament.removeFromGames(theTournament.games!)
        }
        for g in 0..<configs[set].count
        {
            let game = NSManagedObject(entity: gameEntity, insertInto: context) as! Game
            game.commonInit(g+1, configs[set][g].1>0, configs[set][g].2>0, configs[set][g].3>0, configs[set][g].4>0)
            if g < bracketSize/2
            {
                game.setTeam(theTournament.teams![2*g] as? Team, top: true)
                game.setTeam(theTournament.teams![2*g+1] as? Team, top: false)
//                game.top_team = tournament.teams![2*g] as? Team
//                game.bottom_team = tournament.teams![2*g+1] as? Team
            }
            if g == configs[set].count-1 {
                game.gameView.state = .optional
            }
            theTournament.addToGames(game)
        }

        // apply backward and forward linkage among games

        for g in 0..<configs[set].count
        {
            if let game = theTournament.games?[g] as? Game
            {
                let game1 = configs[set][g].1 == 0 ? nil : theTournament.games?[abs(configs[set][g].1)-1] as? Game
                let game2 = configs[set][g].2 == 0 ? nil : theTournament.games?[abs(configs[set][g].2)-1] as? Game
                let game3 = configs[set][g].3 == 0 ? nil : theTournament.games?[abs(configs[set][g].3)-1] as? Game
                let game4 = configs[set][g].4 == 0 ? nil : theTournament.games?[abs(configs[set][g].4)-1] as? Game
                game.config(game1, game2, game3, game4)
            }
        }

        // apply winners of bye games

        for g in 0..<bracketSize/2
        {
            if let game = theTournament.games?[g] as? Game {
                if let topTeam = game.top_team, let bottomTeam = game.bottom_team {
                    if topTeam.name == "bye" {
                        applyResultCD(game, bottomTeam, topTeam)
                    } else if bottomTeam.name == "bye" {
                        applyResultCD(game, topTeam, bottomTeam)
                    }
                }
            }
        }

        // apply backward and forward placeholders

        for g in 0..<2*bracketSize-1
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

        for g in bracketSize..<bracketSize*3/2
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
    }

    func newTeam(_ name: String) -> Team
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let t = NSManagedObject(entity: teamEntity, insertInto: context) as! Team
        t.name = name
        return t
    }
}
