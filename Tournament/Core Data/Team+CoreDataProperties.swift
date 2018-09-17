//
//  Team+CoreDataProperties.swift
//  Casual Tournament
//
//  Created by TJ Sartain on 9/14/18.
//  Copyright © 2018 iTrinity, Inc. All rights reserved.
//
//

import UIKit
import CoreData


extension Team {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Team> {
        return NSFetchRequest<Team>(entityName: "Team")
    }

    @NSManaged public var color1: UIColor?
    @NSManaged public var color2: UIColor?
    @NSManaged public var name: String?
    @NSManaged public var seed: Int64
    @NSManaged public var tournament: Tournament?

}
