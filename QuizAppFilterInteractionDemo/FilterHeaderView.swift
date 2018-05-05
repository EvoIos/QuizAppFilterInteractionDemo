//
//  FilterHeaderView.swift
//  QuizAppFilterInteractionDemo
//
//  Created by Pace.Z on 2018/4/29.
//  Copyright © 2018年 Pace.Z. All rights reserved.
//

import UIKit

typealias Tap = () -> Void

class FilterHeaderView: UICollectionReusableView {
	
	var tap:Tap?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	func setup() {
		backgroundColor = UIColor.white
		
		let lineView = UIView()
		lineView.backgroundColor = UIColor.init(hex: "d0d0d0")
		lineView.layer.cornerRadius = 1.5
		lineView.clipsToBounds = true
		addSubview(lineView)
		lineView.snp.makeConstraints { (make) in
			make.centerX.equalTo(self)
			make.top.equalTo(self).offset(10)
			make.size.equalTo(CGSize.init(width: 60, height: 3))
		}
		
		let label = UILabel()
		label.textColor = UIColor(hex: "333333")
		label.backgroundColor = UIColor.clear
		label.text = "Filter"
		label.textAlignment = .center
		label.numberOfLines = 1
		label.font = UIFont.boldSystemFont(ofSize: 20)
		addSubview(label)
		label.snp.makeConstraints { (make) in
			make.left.right.equalTo(self)
			make.centerX.equalTo(self)
			make.centerY.equalTo(self).offset(5)
		}
		
		let tapButton = UIButton()
		tapButton.backgroundColor = UIColor.clear
		tapButton.addTarget(self, action: #selector(tapButtonClicked), for: .touchUpInside)
		addSubview(tapButton)
		tapButton.snp.makeConstraints { (make) in
			make.centerX.equalTo(self)
			make.top.bottom.equalTo(self)
			make.width.equalTo(lineView)
		}
	}
	
	@objc func tapButtonClicked() {
		self.tap?()
	}
}
