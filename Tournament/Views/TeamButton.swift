//
//  TeamButton.swift
//  CasualTournament
//
//  Created by TJ Sartain on 9/5/18.
//  Copyright © 2018 iTrinity, Inc. All rights reserved.
//

import UIKit

class TeamButton: UIButton
{
    var game: Game?
    var team: Team? {
        didSet {
            setDashedBorder()
            if let team = team {
                setTitleColor(.white, for: .normal)
                setTitle(team.name, for: .normal)
            }
            setGradient()
        }
    }
    var placeHolder: String? {
        didSet {
            if team == nil {
                setTitleColor(.darkGray, for: .normal)
                setTitle(placeHolder, for: .normal)
            }
            setDashedBorder()
        }
    }
    var text: String = "" {
        didSet {
            setTitle(text, for: .normal)
        }
    }
    override var frame: CGRect {
        didSet {
            super.frame = frame
            setDashedBorder()
            setGradient() // when the frame changes, need to redo the gradient
        }
    }
    let gradient = CAGradientLayer()
    let dashedLayer = CAShapeLayer()

    func setGradient()
    {
        if team != nil {
            if let top = team!.color1, let bottom = team!.color2 {
                gradient.removeFromSuperlayer()
                gradient.frame = bounds
                gradient.colors = [top.cgColor, bottom.cgColor]
                layer.cornerRadius = 7
                gradient.cornerRadius = 7
                layer.insertSublayer(gradient, at: 0)
            }
            else {
                gradient.removeFromSuperlayer()
                layer.cornerRadius = 0
            }
        } else {
            gradient.removeFromSuperlayer()
            layer.cornerRadius = 0
        }
    }

    func setDashedBorder()
    {
        if team == nil {
            if let placeholder = placeHolder, placeholder.starts(with: "Loser") {
                dashedLayer.strokeColor = UIColor.darkGray.cgColor
                dashedLayer.lineDashPattern = [5, 3]
                dashedLayer.lineWidth = 1
                dashedLayer.frame = bounds
                layer.cornerRadius = 7
                dashedLayer.fillColor = UIColor.black.cgColor
                dashedLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 7).cgPath
                layer.insertSublayer(dashedLayer, at: 0)
            }
            else {
                dashedLayer.removeFromSuperlayer()
                layer.cornerRadius = 0
            }
        } else {
            dashedLayer.removeFromSuperlayer()
            layer.cornerRadius = 0
        }
    }
}
