//
//  Extensions.swift
//  pi
//
//  Created by Emil Rosendahl on 16/07/16.
//  Copyright © 2016 Ellebellebi. All rights reserved.
//

import UIKit
import SpriteKit


extension UIColor {
	class func random() -> UIColor {
		let hue = ( CGFloat(arc4random()) % 256 / 256.0 )
		let saturation = ( CGFloat(arc4random()) % 128 / 256.0 ) + 0.5
		let brightness = ( CGFloat(arc4random()) % 128 / 256.0 ) + 0.5
		return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
	}
}

func blend(color color1: UIColor, withColor color2: UIColor) -> UIColor {
	var r1: CGFloat = 0
	var g1: CGFloat = 0
	var b1: CGFloat = 0
	var a1: CGFloat = 0
	var r2: CGFloat = 0
	var g2: CGFloat = 0
	var b2: CGFloat = 0
	var a2: CGFloat = 0

	color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
	color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

	return UIColor(red: avg([r1, r2]), green: avg([g1, g2]), blue: avg([b1, b2]), alpha: avg([a1, a2]))
}

func avg(n: [CGFloat]) -> CGFloat {
	return n.reduce(0, combine: +) / CGFloat(n.count)
}

func +(lh: UIColor, rh: UIColor) -> UIColor {
	return blend(color: lh, withColor: rh)
}

func +(left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPoint(
		x: CGFloat(left.x) + CGFloat(right.x),
		y: CGFloat(left.y) + CGFloat(right.y)
	)
}
