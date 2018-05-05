//
//  QuizListCell.swift
//  QuizAppFilterInteractionDemo
//
//  Created by Pace.Z on 2018/4/28.
//  Copyright © 2018年 Pace.Z. All rights reserved.
//

import UIKit

class QuizListCellModel {
	let colors:[CGColor]!
	let title:String!
	let detail:String!
	
	init(colors: [CGColor], title: String, detail: String) {
		self.colors = colors
		self.title = title
		self.detail = detail
	}
}

class QuizListCell: UICollectionViewCell {
	
	var titleLabel: UILabel!
	var detailLabel: UILabel!
	var gradientLayer: CAGradientLayer!

	var model: QuizListCellModel? {
		didSet {
			if let model = model  {
				titleLabel.text = model.title
				detailLabel.text = model.detail
				gradientLayer.colors = model.colors
			}
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
	
	override func prepareForReuse() {
		super.prepareForReuse()
	}
	
	func setup() {
	
		let radius = bounds.size.height / 2.0
		self.clipsToBounds = true
		self.layer.cornerRadius = radius
		
		gradientLayer = CAGradientLayer()
		gradientLayer.frame = self.bounds
		gradientLayer.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor]
		gradientLayer.startPoint = CGPoint(x: 0.3, y: 0)
		gradientLayer.endPoint = CGPoint(x: 1, y: 0.7)
		contentView.layer.addSublayer(gradientLayer)
		
		titleLabel = UILabel()
		titleLabel.textColor = UIColor.white
		titleLabel.font = UIFont.systemFont(ofSize: 40)
		titleLabel.textAlignment = .center
		contentView.addSubview(titleLabel)
		detailLabel = UILabel()
		detailLabel.textColor = UIColor.white
		detailLabel.font = UIFont.systemFont(ofSize: 14)
		detailLabel.textAlignment = .center
		detailLabel.numberOfLines = 2
		contentView.addSubview(detailLabel)
		titleLabel.snp.makeConstraints { (make) in
			make.bottom.equalTo(contentView.snp.centerY).offset(-8)
			make.left.right.equalTo(contentView)
			make.height.equalTo(40)
		}
		detailLabel.snp.makeConstraints { (make) in
			make.top.equalTo(contentView.snp.centerY).offset(8)
			make.left.equalTo(contentView).offset(radius + 15)
			make.right.equalTo(contentView).offset(-radius-15)
			make.height.lessThanOrEqualTo(60)
		}
	}
}
