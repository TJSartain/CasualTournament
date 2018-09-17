//
//  ReplaceSegue.swift
//  ClearChain
//
//  Created by TJ Sartain on 7/11/18.
//  Copyright © 2018 Penske Logistics. All rights reserved.
//

import UIKit

class ReplaceSegue: UIStoryboardSegue
{
    override func perform()
    {
        if let controller = source.navigationController
        {
            var stack = controller.viewControllers
            if let index = stack.index(of: source)
            {
                stack[index] = destination
                controller.setViewControllers(stack, animated: true)
            }
        }
    }
}
