//
//  Team+CoreDataClass.swift
//  CasualTournament
//
//  Created by TJ Sartain on 8/28/18.
//  Copyright © 2018 iTrinity, Inc. All rights reserved.
//
//

import Foundation
import CoreData


public class Team: NSManagedObject
{
    public override var description: String
    {
        return "\(String(describing: name)) \(seed)"
    }
}
