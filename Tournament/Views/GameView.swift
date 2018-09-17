//
//  GameView.swift
//  CasualTournament
//
//  Created by TJ Sartain on 9/5/18.
//  Copyright © 2018 iTrinity, Inc. All rights reserved.
//

import UIKit

class GameView: UIView
{
    var state: GameViewState = .normal

    override func draw(_ rect: CGRect)
    {
        print("GameView draw")
        let left = rect.minX
        let right = rect.minX + rect.width - 0.5
        let top = rect.minY + 0.5
        let bottom = rect.minY + rect.height - 0.5
        let path = UIBezierPath()
        normalLineColor.setStroke()
        path.move(to: CGPoint(x: left, y: top))
        path.addLine(to: CGPoint(x: right, y: top))
        if state == .normal {
            print("GameView draw state == .normal")
            path.addLine(to: CGPoint(x: right, y: bottom))
            path.addLine(to: CGPoint(x: left, y: bottom))
        }
        path.setLineDash([], count: 0, phase: 0)
        path.lineWidth = 1
        path.lineJoinStyle = .miter
        path.lineCapStyle = .butt
        path.stroke()
        if state == .optional {
            print("GameView draw state == .optional")
            let path = UIBezierPath()
            path.move(to: CGPoint(x: right, y: top))
            path.addLine(to: CGPoint(x: right, y: bottom))
            path.addLine(to: CGPoint(x: left, y: bottom))
            path.setLineDash([5, 3], count: 2, phase: 0)
            path.lineWidth = 1
            path.lineJoinStyle = .miter
            path.lineCapStyle = .butt
            optionalLineColor.setStroke()
            path.stroke()
        }

        if state != .hidden {
            "\(tag % 1000)".draw(at: CGPoint(x: rect.midX, y: rect.midY),
                                 font: UIFont.systemFont(ofSize: 18),
                                 color: UIColor.darkGray,
                                 shadow: nil,
                                 align: .Center,
                                 vAlign: .Middle)
        }
    }
}
