//
//  Game+CoreDataProperties.swift
//  Casual Tournament
//
//  Created by TJ Sartain on 9/14/18.
//  Copyright © 2018 iTrinity, Inc. All rights reserved.
//
//

import Foundation
import CoreData


extension Game {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Game> {
        return NSFetchRequest<Game>(entityName: "Game")
    }

    @NSManaged public var loser_to_top: Bool
    @NSManaged public var number: Int64
    @NSManaged public var winner_from_bottom: Bool
    @NSManaged public var winner_from_top: Bool
    @NSManaged public var winner_to_top: Bool
    @NSManaged public var bottom_team: Team?
    @NSManaged public var bottomSource: Game?
    @NSManaged public var loserGame: Game?
    @NSManaged public var top_team: Team?
    @NSManaged public var topSource: Game?
    @NSManaged public var tournament: Tournament?
    @NSManaged public var winner: Team?
    @NSManaged public var winnerGame: Game?

}
