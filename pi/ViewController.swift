//
//  ViewController.swift
//  pi
//
//  Created by Emil Rosendahl on 22/06/16.
//  Copyright © 2016 Ellebellebi. All rights reserved.
//

import UIKit
import SpriteKit

let PI = CGFloat(M_PI)
let PI_2 = CGFloat(M_PI_2)
let PI_4 = CGFloat(M_PI_4)
let PI_8 = PI_4 / 2

class ViewController: UIViewController {

	var scene: PiScene!
	var isFirstStart = true

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		let skview = SKView(frame: CGRect(
			x: 0,
			y: 50,
			width: view.frame.size.width,
			height: view.frame.size.height
			))
		skview.backgroundColor = UIColor.clearColor()
		view.addSubview(skview)

		scene = PiScene(size: view.frame.size)
		scene.backgroundColor = UIColor.clearColor()
		scene.digitGenerator = DigitGenerator(file: "digits.txt", digitCap: 9995)
		skview.presentScene(scene)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func didTapStart(sender: UIButton) {
		if !isFirstStart {
			scene.reset()
			scene.prepare()
		}
		scene.drawImage()
		isFirstStart = false
	}
}
