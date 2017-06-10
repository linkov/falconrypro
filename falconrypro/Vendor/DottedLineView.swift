//
//  DotLineView.swift
//  DotLineView
//
//  Created by Kenji Abe on 2016/06/28.
//  Copyright © 2016年 Kenji Abe. All rights reserved.
//

import UIKit


public class DottedLineView: UIView {


    public var lineColor: UIColor = UIColor.white
    

    public var lineWidth: CGFloat = CGFloat(2)
    

    public var round: Bool = false
    

    public var horizontal: Bool = false
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initBackgroundColor()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initBackgroundColor()
    }
    
    override public func prepareForInterfaceBuilder() {
        initBackgroundColor()
    }

    public override func draw(_ rect: CGRect) {

        let path = UIBezierPath()
        path.lineWidth = lineWidth

        if round {
            configureRoundPath(path: path, rect: rect)
        } else {
            configurePath(path: path, rect: rect)
        }

        lineColor.setStroke()
        
        path.stroke()
    }

    func initBackgroundColor() {
        if backgroundColor == nil {
            backgroundColor = .clear
        }
    }
    
    private func configurePath(path: UIBezierPath, rect: CGRect) {
        if horizontal {

//            let center = rect.height * 0.5
//            
//            let drawWidth = rect.size.width - (rect.size.width %% (lineWidth * 2)) + lineWidth
//            let startPositionX = (rect.size.width - drawWidth) * 0.5 + lineWidth
//            
//            path.move(to: CGPoint(x: startPositionX, y: center))
//            path.addLine(to: CGPoint(x: drawWidth, y: center))
            
        } else {

            let center = rect.width * 0.5
            let drawHeight = rect.size.height - (rect.size.height %% (lineWidth * 2)) + lineWidth
            let startPositionY = (rect.size.height - drawHeight) * 0.5 + lineWidth
            
            path.move(to: CGPoint(x: center, y: startPositionY))
            path.addLine(to: CGPoint(x: center, y: drawHeight))
        }
        
        let dashes: [CGFloat] = [lineWidth, lineWidth]
        path.setLineDash(dashes, count: dashes.count, phase: 0)
        path.lineCapStyle = CGLineCap.butt
    }
    
    private func configureRoundPath(path: UIBezierPath, rect: CGRect) {
//        if horizontal {
//            let center = rect.height * 0.5
//            let drawWidth = rect.size.width - (rect.size.width %% (lineWidth * 2))
//            let startPositionX = (rect.size.width - drawWidth) * 0.5 + lineWidth
//            
//            path.move(to: CGPoint(x: startPositionX, y: center))
//            path.addLine(to: CGPoint(x: drawWidth, y: center))
//            
//        } else {
//            let center = rect.width * 0.5
//            let drawHeight = rect.size.height - (rect.size.height %% (lineWidth * 2))
//            let startPositionY = (rect.size.height - drawHeight) * 0.5 + lineWidth
//            
//            path.move(to: CGPoint(x: center, y: startPositionY))
//            path.addLine(to: CGPoint(x: center, y: drawHeight))
//        }
//
//        let dashes: [CGFloat] = [0, lineWidth * 2]
//        path.setLineDash(dashes, count: dashes.count, phase: 0)
//        path.lineCapStyle = CGLineCap.round
    }
    
}


infix operator %%/*<--infix operator is required for custom infix char combos*/
/**
 * Brings back simple modulo syntax (was removed in swift 3)
 * Calculates the remainder of expression1 divided by expression2
 * The sign of the modulo result matches the sign of the dividend (the first number). For example, -4 % 3 and -4 % -3 both evaluate to -1
 * EXAMPLE:
 * print(12 %% 5)    // 2
 * print(4.3 %% 2.1) // 0.0999999999999996
 * print(4 %% 4)     // 0
 * NOTE: The first print returns 2, rather than 12/5 or 2.4, because the modulo (%) operator returns only the remainder. The second trace returns 0.0999999999999996 instead of the expected 0.1 because of the limitations of floating-point accuracy in binary computing.
 */
public func %% (left:CGFloat, right:CGFloat) -> CGFloat {
    return left.truncatingRemainder(dividingBy: right)
}
