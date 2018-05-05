//
//  TXColorExtension.swift
//  TXMaike
//
//  Created by z on 2018/1/11.
//  Copyright © 2018年 z. All rights reserved.
//

import UIKit

extension UIColor {
    /// eg: let color = UIColor(hex: "ff0000")
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff,
            alpha: 1
        )
    }
	
	static var random:UIColor {
		
		let randomRed:CGFloat = CGFloat(drand48())
		
		let randomGreen:CGFloat = CGFloat(drand48())
		
		let randomBlue:CGFloat = CGFloat(drand48())
		
		return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
	}
}

