//
//  Globals.swift
//  Tournament
//
//  Created by TJ Sartain on 8/25/18.
//  Copyright © 2018 iTrinity, Inc. All rights reserved.
//

import UIKit
import CoreData

var tournamentEntity = NSEntityDescription()
var teamEntity = NSEntityDescription()
var gameEntity = NSEntityDescription()

//var tournamentNCD = TournamentNCD("Casual Tournament")
var theTournament = Tournament()

var haveAddedTeam = false
var haveDeletedTeam = false
var haveSetDate = false
var haveTappedGame = false
var haveSeenConsolation = false
var haveCreatedTournament = false
var haveSelectedTournament = false


enum GameViewState
{
    case normal
    case optional
    case hidden
}
let normalLineColor = ltTeal
let optionalLineColor = UIColor.darkGray

let seeds = [[1, 8, 5, 4, 3, 6, 7, 2],
             [1, 16, 9, 8, 5, 12, 13, 4, 3, 14, 11, 6, 7, 10, 15, 2],
             [1, 32, 17, 16, 9, 24, 25, 8, 5, 28, 21, 12, 13, 20, 29, 4, 3, 30, 19, 14, 11, 22, 27, 6, 7, 26, 23, 10, 15, 18, 31, 2]]
//                                       size i r g m
var configs = [[( 1,   5,   9,   0,   0),// 8 1 0 0 4   1 1
                ( 2,  -5,  -9,   0,   0),// 8 2 0 1 4   1 1
                ( 3,   6,  10,   0,   0),// 8 3 0 2 4   2 2
                ( 4,  -6, -10,   0,   0),// 8 4 0 3 4   2 2
                ( 5,   7,  12,   0,   0),// 8 5 1 0 2   3 1
                ( 6,  -7,  11,   0,   0),// 8 6 1 1 2   4 1
                ( 7,   8,  14,   0,   0),//
                ( 8,  15, -15,   7,  14),//         (size + (g+2)/2 + 2*r) * (g%2==0 ? 1 : -1)
                ( 9, -11,   0,  -1,  -2),
                (10, -12,   0,  -3,  -4),
                (11,  13,   0,  -9,   6),
                (12, -13,   0, -10,   5),
                (13, -14,   0,  11,  12),
                (14,  -8,   0,  -7,  13),
                (15,   0,   0,   8,  -8)],
               
               [( 1,   9,  17,   0,   0),
                ( 2,  -9, -17,   0,   0),
                ( 3,  10,  18,   0,   0),
                ( 4, -10, -18,   0,   0),
                ( 5,  11,  19,   0,   0),
                ( 6, -11, -19,   0,   0),
                ( 7,  12,  20,   0,   0),
                ( 8, -12, -20,   0,   0),
                ( 9,  13,  24,   1,   2),
                (10, -13,  23,   3,   4),
                (11,  14,  22,   5,   6),
                (12, -14,  21,   7,   8),
                (13,  15,  27,   9,  10),
                (14, -15,  28,  11,  12),
                (15,  16,  30,  13,  14),
                (16,  31, -31,  15,  30),
                (17, -21,   0,  -1,  -2),
                (18, -22,   0,  -3,  -4),
                (19, -23,   0,  -5,  -6),
                (20, -24,   0,  -7,  -8),
                (21,  25,   0, -12,  17),
                (22, -25,   0, -11,  18),
                (23,  26,   0, -10,  19),
                (24, -26,   0,  -9,  20),
                (25, -27,   0,  21,  22),
                (26, -28,   0,  23,  24),
                (27,  29,   0, -13,  25),
                (28, -29,   0, -14,  26),
                (29, -30,   0,  27,  28),
                (30, -16,   0, -15,  29),
                (31,   0,   0,  16, -16)]]

var teamColorPool = [(UIColor.fromHex("30cfd0"), UIColor.fromHex("330867"), "Morpheus Den"),
                     (UIColor.fromHex("2575fc"), UIColor.fromHex("6a11cb"), "Deep Blue"),
                     (UIColor.fromHex("e5b2ca"), UIColor.fromHex("7028e4"), "Purple Division"),
                     (UIColor.fromHex("cc208e"), UIColor.fromHex("6713d2"), "Plum Bath"),
                     (UIColor.fromHex("f6007f"), UIColor.fromHex("38001d"), "Random 1"),
                     (UIColor.fromHex("ffb199"), UIColor.fromHex("ff0844"), "Love Kiss"),
                     (UIColor.fromHex("f093fb"), UIColor.fromHex("f5576c"), "Ripe Malinka"),
                     (UIColor.fromHex("f9d423"), UIColor.fromHex("f83600"), "Phoenix Start"),
                     (UIColor.fromHex("1d986c"), UIColor.fromHex("92f8b7"), "Random 5"),
                     (UIColor.fromHex("f0f1b5"), UIColor.fromHex("155159"), "Random 2"),
                     (UIColor.fromHex("4aa0ad"), UIColor.fromHex("25262b"), "Random 4"),
                     (UIColor.fromCSV("80, 225, 18"), UIColor.fromCSV("57, 113, 7"), "Green"),
                     (UIColor.fromCSV("245, 63, 66"), UIColor.fromCSV("124, 16, 0"), "Red"),
                     (UIColor.fromCSV("145, 51, 229"), UIColor.fromCSV("83, 25, 113"), "Purple"),
                     (UIColor.fromCSV("50, 172, 247"), UIColor.fromCSV("5, 81, 136"), "Blue"),
                     (UIColor.fromCSV("255, 195, 56"), UIColor.fromCSV("172, 97, 11"), "Yellow"),
                     (UIColor.fromCSV("0, 249, 201"), UIColor.fromCSV("0, 101, 81"), "Teal")
]

func apply(winner: Team, to game: Game, loser: Team)
{
    if game.winner != nil { // already have a winner: clear forward
        var gameQueue = [(Game, Bool)]() // (the game, position is top?)
        if let winnerGame = game.winnerGame {
            gameQueue.append((winnerGame, game.winner_to_top))
        }
        if let loserGame = game.loserGame {
            gameQueue.append((loserGame, game.loser_to_top))
        }
        while gameQueue.count > 0 {
            let (target, toTop) = gameQueue.remove(at: 0)
            print("Processing \(target)")
            if target.winner != nil { // already have a winner: clear forward
                if let winnerGame = target.winnerGame {
                    gameQueue.append((winnerGame, target.winner_to_top))
                }
                if let loserGame = target.loserGame {
                    gameQueue.append((loserGame, target.loser_to_top))
                }
            }
            target.setTeam(nil, top: toTop)
            target.winner = nil
        }
    }
    applyResultCD(game, winner, loser)
}

func applyResultCD(_ game: Game, _ winner: Team, _ loser: Team)
{
    game.winner = winner
    if let winnerGame = game.winnerGame {
        winnerGame.setTeam(winner, top: game.winner_to_top)
        // recurse forward
        if let topTeam = winnerGame.top_team, let bottomTeam = winnerGame.bottom_team {
            if topTeam.name == "bye" {
                applyResultCD(winnerGame, bottomTeam, topTeam)
            } else if bottomTeam.name == "bye" {
                applyResultCD(winnerGame, topTeam, bottomTeam)
            }
        }
    }

    if let loserGame = game.loserGame {
        loserGame.setTeam(loser, top: game.loser_to_top)
        // recurse forward
        if let topTeam = loserGame.top_team, let bottomTeam = loserGame.bottom_team {
            if topTeam.name == "bye" {
                applyResultCD(loserGame, bottomTeam, topTeam)
            } else if bottomTeam.name == "bye" {
                applyResultCD(loserGame, topTeam, bottomTeam)
            }
        }
    }
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
}

func hasEnded(_ tourney: Tournament? = theTournament) -> Bool
{
    return tourney!.winner != nil
}
