//
//  LabelFilterCell.swift
//  QuizAppFilterInteractionDemo
//
//  Created by Pace.Z on 2018/5/4.
//  Copyright © 2018年 Pace.Z. All rights reserved.
//

import UIKit
import SnapKit

class LabelFilterCell: UICollectionViewCell {
	
	private var label:UILabel!
	private var overlay: UIView = UIView()
	private var adjustedWidthConstraint: Constraint?
	private var fillColor = UIColor(hex: "FF58AD")
	
	var title:String? {
		didSet {
			self.label.text = title
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	func setup() {
		
		clipsToBounds = true
		layer.cornerRadius = bounds.height / 2.0
		layer.borderColor  = UIColor(hex: "666666").cgColor
		layer.borderWidth  = 1
		
		contentView.addSubview(overlay)
		overlay.snp.makeConstraints { (make) in
			make.bottom.top.equalTo(contentView)
			make.width.equalTo(contentView)
			make.right.equalTo(contentView.snp.left)
		}
		overlay.backgroundColor = fillColor
		overlay.alpha = 0
		overlay.frame.size.width = 0
		
		label = UILabel()
		label.textColor = UIColor(hex: "333333")
		label.textAlignment = .center
		label.numberOfLines = 1
		label.font = UIFont.boldSystemFont(ofSize: 18)
		contentView.addSubview(label)
		label.snp.makeConstraints { (make) in
			make.edges.equalTo(contentView)
		}
	}
	
	func check() {
		
		UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
			self.layer.borderColor = self.fillColor.cgColor
			self.overlay.alpha = 1
			self.overlay.frame.origin.x = 0
			self.label.textColor = UIColor.white
		}, completion: nil)
	}
}
