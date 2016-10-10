//
//  Segment.swift
//  pi
//
//  Created by Emil Rosendahl on 16/07/16.
//  Copyright © 2016 Ellebellebi. All rights reserved.
//

import Foundation
import SpriteKit

class Segment {
	let startAngle: CGFloat
	let endAngle: CGFloat
	let color: UIColor

	init(startAngle: CGFloat, endAngle: CGFloat, color: UIColor) {
		self.startAngle = startAngle
		self.endAngle = endAngle
		self.color = color
	}

	func toShapeNode(center: CGPoint, radius: CGFloat, lineWidth: CGFloat) -> SKShapeNode {
		let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
		let node = SKShapeNode()
		node.strokeColor = color
		node.lineCap = .Round
		node.path = path.CGPath
		node.lineWidth = lineWidth
		return node
	}

	func centerPosition() -> CGFloat {
		return decimalPosition(5)
	}

	func decimalPosition(point: Int) -> CGFloat {
		return startAngle + ((endAngle - startAngle) / 9 * CGFloat(point))
	}
}
