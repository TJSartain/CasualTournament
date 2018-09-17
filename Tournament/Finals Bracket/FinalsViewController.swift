//
//  FinalsViewController.swift
//  CasualTournament
//
//  Created by TJ Sartain on 8/25/18.
//  Copyright © 2018 iTrinity, Inc. All rights reserved.
//

import UIKit

class FinalsViewController: UIViewController
{
    @IBOutlet weak var finalsBracketView: FinalsBracketView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        finalsBracketView.setupView()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransition(to: size, with: coordinator)
        finalsBracketView.redrawGameViews()
        finalsBracketView.setNeedsDisplay()
    }
}
