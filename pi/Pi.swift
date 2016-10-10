//
//  Pi.swift
//  pi
//
//  Created by Emil Rosendahl on 16/07/16.
//  Copyright © 2016 Ellebellebi. All rights reserved.
//

import Foundation
import SpriteKit

class PiScene: SKScene {

	var digitGenerator: DigitGenerator!
	let lineWidth: CGFloat = 10
	var segments: [Segment] = []
	let randomizeFactor = 3
	let animationDelay = 0.0

	var label: SKLabelNode!

	lazy var radius: CGFloat = {
		return (self.view!.frame.width - self.lineWidth ) / 2
	}()

	lazy var circleRadius: CGFloat = {
		return self.radius * 0.8
	}()

	lazy var center: CGPoint = {
		return CGPoint(x: self.view!.frame.midX, y: self.view!.frame.midY)
	}()

	override func didMoveToView(view: SKView) {
		super.didMoveToView(view)
		prepare()
	}

	func reset() {
		removeAllActions()
		removeAllChildren()
		digitGenerator.reset()
	}

	func prepare() {
		label = SKLabelNode()
		label.verticalAlignmentMode = .Center
		label.horizontalAlignmentMode = .Center
		label.position = CGPoint(x: center.x, y: center.y + radius + 20)
		label.text = "3"
		label.fontSize = 34.0
		label.alpha = 0

		addChild(label)

		drawSegments(10, spacing: 0.15)
		drawEndpoints()
	}

	func drawImage() {
//		drawOrigin()
		digitGenerator.prepare()
		let drawLineAction = SKAction.sequence([
			SKAction.waitForDuration(self.animationDelay),
			SKAction.runBlock({
				let (from, to) = self.digitGenerator.nextDigits()
				self.label.runAction(SKAction.sequence([
					SKAction.fadeOutWithDuration(0.1),
					SKAction.runBlock({ 
						self.label.text = String(to)
					}),
					SKAction.fadeInWithDuration(0.1)
				]))
				self.drawLine(from, to: to)
			})
		])

		let action = SKAction.repeatAction(drawLineAction, count: digitGenerator.digitCap)

		runAction(SKAction.sequence([
			SKAction.runBlock({
				self.label.runAction(SKAction.fadeInWithDuration(0.4))
			}),
			action,
			SKAction.runBlock({ 
				self.label.runAction(SKAction.fadeOutWithDuration(0.4))
			})
			]))
	}

	func drawLine(from: Int, to: Int) {
		let segmentPointFrom = segments[from].decimalPosition(to)
		let segmentPointTo   = segments[to].decimalPosition(from)

		let fromPoint = angleToPoint(segmentPointFrom, radius: circleRadius - (lineWidth / 2))
		let toPoint = angleToPoint(segmentPointTo, radius: circleRadius - (lineWidth / 2))

		let path = UIBezierPath()
		path.moveToPoint(fromPoint)
		path.addQuadCurveToPoint(toPoint, controlPoint: randomize(center))

		let node = SKShapeNode()
		node.path = path.CGPath
		node.strokeColor = segments[from].color + segments[to].color
		addChild(node)
	}

	func drawOrigin() {
		let node = SKShapeNode(circleOfRadius: 4)
		node.position = center
		addChild(node)
	}

	func angleToPoint(angle: CGFloat, radius: CGFloat) -> CGPoint {
		return CGPoint(
			x: cos(angle) * radius,
			y: sin(angle) * radius
			) + center
	}

	func randomize(point: CGPoint) -> CGPoint {
		let random = CGFloat(arc4random_uniform(UInt32(randomizeFactor * 2)) + UInt32((100 - randomizeFactor))) / 100
		return CGPoint(x: point.x * random, y: point.y * random)
	}

	func drawEndpoints() {
		for (index, segment) in segments.enumerate() {
			for i in 0...9 {
				guard i != index else { continue }

				let dot = SKShapeNode(circleOfRadius: 1)
				dot.fillColor = UIColor.whiteColor()
				dot.strokeColor = UIColor.whiteColor()
				dot.position = angleToPoint(
					segment.decimalPosition(i),
					radius: circleRadius - (lineWidth / 2) + 0.75
				)
				dot.zPosition = 1
				addChild(dot)
			}
		}
	}

	func drawSegments(segments: Int, spacing: CGFloat) {
		let totalLength = PI * 2
		let segmentLength = (totalLength - spacing * CGFloat(segments) ) / CGFloat(segments)

		let startPos = -(PI + PI_2) + spacing / 2
		for i in 0..<segments {
			let i = CGFloat(i)
			let start = startPos + (i * segmentLength) + (i * spacing)
			let end = start + segmentLength

			let segment = Segment(startAngle: start, endAngle: end, color: colorForDigit(Int(i)))

			let node = segment.toShapeNode(center, radius: circleRadius, lineWidth: lineWidth)
			addChild(node)

			let digit = SKLabelNode(text: String(Int(i)))
			digit.position = center + CGPoint(
				x: cos(segment.centerPosition()) * radius * 0.95,
				y: sin(segment.centerPosition()) * radius * 0.95
			)
			digit.verticalAlignmentMode = .Center
			digit.horizontalAlignmentMode = .Center
			digit.fontSize = 18

			addChild(digit)

			self.segments.append(segment)
		}
	}

	func colorForDigit(i: Int) -> UIColor {
		return UIColor(hue: CGFloat(i * 36) / 360, saturation: 0.7, brightness: 0.9, alpha: 1)
	}
}
