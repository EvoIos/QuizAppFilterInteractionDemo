//
//  UIFont+Size.swift
//  QuizAppFilterInteractionDemo
//
//  Created by Pace.Z on 2018/4/29.
//  Copyright © 2018年 Pace.Z. All rights reserved.
//

import UIKit

extension UIFont {
	func size(of string: String, with constrainedSize : CGSize) -> CGSize {
		return NSString(string: string)
			.boundingRect(
				with: constrainedSize,
				options: NSStringDrawingOptions.usesLineFragmentOrigin,
				attributes: [NSAttributedStringKey.font: self],
				context: nil).size
	}
}
