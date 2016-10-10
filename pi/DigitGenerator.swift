//
//  DigitGenerator.swift
//  pi
//
//  Created by Emil Rosendahl on 16/07/16.
//  Copyright © 2016 Ellebellebi. All rights reserved.
//

import Foundation

class DigitGenerator {
	let file: String
	let digitCap: Int
	var digits: [Int] = []

	private var currentIndex: Int = 0

	init(file: String, digitCap: Int = 3) {
		self.file = file
		self.digitCap = digitCap
	}

	func prepare() {
		let characters = readFile().characters
		digits = characters.map({ Int(String($0))! })
	}

	func reset() {
		currentIndex = 0
	}

	func nextDigits() -> (Int, Int) {
		defer {
			currentIndex += 1
		}
		return (digits[currentIndex], digits[currentIndex + 1])
//		var from = digits[currentIndex]
//		var to   = digits[currentIndex + 1]
//
//		while true {
//			from = digits[currentIndex]
//			to   = digits[currentIndex + 1]
//
//			if from != to {
//				break
//			}
//
//			currentIndex += 1
//		}
//
//		currentIndex += 1
//		return (from, to)
	}

	func generate(block: (digit1: Int, digit2: Int) -> Void) {
		var digits = readFile().characters
		var digit1: Int = Int(String(digits.popFirst()!))!
		var digit2: Int = Int(String(digits.popFirst()!))!

		block(digit1: digit1, digit2: digit2)

		for (i, digit) in digits.enumerate() {
			guard let digit = Int(String(digit)) else { continue }

			digit1 = digit2
			digit2 = digit

			block(digit1: digit1, digit2: digit2)

			if digitCap > 0 && (i + 2) >= digitCap { break }
		}
	}

	private func readFile() -> String {
		guard let filepath = NSBundle.mainBundle().pathForResource("digits", ofType: "txt") else { return "" }
		var text = ""
		do {
			text = try NSString(contentsOfFile: filepath, encoding: NSUTF8StringEncoding) as String
		}
		catch {/* error handling here */}

		return text
	}
}
