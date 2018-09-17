//
//  Tournament+CoreDataProperties.swift
//  Casual Tournament
//
//  Created by TJ Sartain on 9/14/18.
//  Copyright © 2018 iTrinity, Inc. All rights reserved.
//
//

import Foundation
import CoreData


extension Tournament {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tournament> {
        return NSFetchRequest<Tournament>(entityName: "Tournament")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var location: String?
    @NSManaged public var name: String?
    @NSManaged public var games: NSOrderedSet?
    @NSManaged public var teams: NSOrderedSet?
    @NSManaged public var winner: Team?
    @NSManaged public var second: Team?
    @NSManaged public var third: Team?

}

// MARK: Generated accessors for games
extension Tournament {

    @objc(insertObject:inGamesAtIndex:)
    @NSManaged public func insertIntoGames(_ value: Game, at idx: Int)

    @objc(removeObjectFromGamesAtIndex:)
    @NSManaged public func removeFromGames(at idx: Int)

    @objc(insertGames:atIndexes:)
    @NSManaged public func insertIntoGames(_ values: [Game], at indexes: NSIndexSet)

    @objc(removeGamesAtIndexes:)
    @NSManaged public func removeFromGames(at indexes: NSIndexSet)

    @objc(replaceObjectInGamesAtIndex:withObject:)
    @NSManaged public func replaceGames(at idx: Int, with value: Game)

    @objc(replaceGamesAtIndexes:withGames:)
    @NSManaged public func replaceGames(at indexes: NSIndexSet, with values: [Game])

    @objc(addGamesObject:)
    @NSManaged public func addToGames(_ value: Game)

    @objc(removeGamesObject:)
    @NSManaged public func removeFromGames(_ value: Game)

    @objc(addGames:)
    @NSManaged public func addToGames(_ values: NSOrderedSet)

    @objc(removeGames:)
    @NSManaged public func removeFromGames(_ values: NSOrderedSet)

}

// MARK: Generated accessors for teams
extension Tournament {

    @objc(insertObject:inTeamsAtIndex:)
    @NSManaged public func insertIntoTeams(_ value: Team, at idx: Int)

    @objc(removeObjectFromTeamsAtIndex:)
    @NSManaged public func removeFromTeams(at idx: Int)

    @objc(insertTeams:atIndexes:)
    @NSManaged public func insertIntoTeams(_ values: [Team], at indexes: NSIndexSet)

    @objc(removeTeamsAtIndexes:)
    @NSManaged public func removeFromTeams(at indexes: NSIndexSet)

    @objc(replaceObjectInTeamsAtIndex:withObject:)
    @NSManaged public func replaceTeams(at idx: Int, with value: Team)

    @objc(replaceTeamsAtIndexes:withTeams:)
    @NSManaged public func replaceTeams(at indexes: NSIndexSet, with values: [Team])

    @objc(addTeamsObject:)
    @NSManaged public func addToTeams(_ value: Team)

    @objc(removeTeamsObject:)
    @NSManaged public func removeFromTeams(_ value: Team)

    @objc(addTeams:)
    @NSManaged public func addToTeams(_ values: NSOrderedSet)

    @objc(removeTeams:)
    @NSManaged public func removeFromTeams(_ values: NSOrderedSet)

}
