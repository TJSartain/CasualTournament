//
//  Utilities.swift
//  SwiftGraphics
//
//  Created by TJ Sartain on 5/11/17.
//  Copyright © 2017 iTrinity, Inc. All rights reserved.
//

import UIKit


func stringNotEmpty(_ string: Any?) -> Bool
{
    if var str = string as? String {
        str = str.trimmingCharacters(in: .whitespacesAndNewlines)
        if !["nil", "<null>", "-1", ""].contains(str) {
            return true
        }
    }
    return false
}

func det(_ a: Double, _ b: Double, _ c: Double, _ d: Double) -> Double
{
    return a*d - b*c;
}

func roots(a: Double, b: Double, c: Double) -> [Double]?
{
    let discriminant = b*b - 4*a*c
    if a == 0 || discriminant < -1e-07 {        // no real roots
        return nil
    } else if discriminant.equals(0, 1e-07) {   // one root
        return [-b / (2*a)]
    } else {                                    // two roots
        let x1 = (-b + sqrt(discriminant)) / (2*a)
        let x2 = (-b - sqrt(discriminant)) / (2*a)
        return [x1, x2]
    }
}

func showFonts()
{
    for family: String in UIFont.familyNames
    {
        print("\(family)")
        for name: String in UIFont.fontNames(forFamilyName: family)
        {
            print(".. \(name)")
        }
    }
}

func showFailureAlert(_ message: String)
{
    let alert = UIAlertController(title: "Configuration Error", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    if let controller = topMostContoller() {
        controller.present(alert, animated: true)
    }
}

func alert(title: String, message: String, buttons: [String]? = [], completion: @escaping (UIAlertAction) -> Void)
{
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    if buttons!.count > 0 {
        let okAction = UIAlertAction(title: buttons![0], style: .default, handler: completion)
        alert.addAction(okAction)
        if buttons!.count > 1 {
            let cancelAction = UIAlertAction(title: buttons![1], style: .cancel, handler: nil)
            alert.addAction(cancelAction)
        }
    } else {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: completion)
        alert.addAction(okAction)
    }
    if let controller = topMostContoller() {
        controller.present(alert, animated: true, completion: nil)
    }
}

func topMostContoller() -> UIViewController?
{
    if !Thread.current.isMainThread
    {
        print("ACCESSING TOP MOST CONTROLLER OUTSIDE OF MAIN THREAD")
        return nil
    }

    let topMostVC:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
    return topVCWithRootVC(topMostVC)
}

func topVCWithRootVC(_ rootVC:UIViewController) -> UIViewController?
{
    if rootVC is UITabBarController
    {
        let tabBarController:UITabBarController = rootVC as! UITabBarController
        if let selectVC = tabBarController.selectedViewController {
            return topVCWithRootVC(selectVC)
        } else {
            return nil
        }
    } else if rootVC.presentedViewController != nil {
        if let presentedViewController = rootVC.presentedViewController! as UIViewController? {
            return topVCWithRootVC(presentedViewController)
        } else {
            return nil
        }
    } else {
        return rootVC
    }
}

