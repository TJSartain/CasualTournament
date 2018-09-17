//
//  HomeViewController.swift
//  CasualTournament
//
//  Created by TJ Sartain on 8/31/18.
//  Copyright © 2018 iTrinity, Inc. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController
{
    @IBOutlet var appLabel: UILabel!
    @IBOutlet var versionLabel: UILabel!

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        setNeedsStatusBarAppearanceUpdate()
        if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            appLabel.text = "\(appName)"
        }
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            versionLabel.text = "Version \(version)"
        }
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Home", style: UIBarButtonItemStyle.plain, target: nil, action: nil)

    }
}
