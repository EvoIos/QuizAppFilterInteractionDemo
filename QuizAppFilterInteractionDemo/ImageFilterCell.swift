//
//  ImageFilterCell.swift
//  QuizAppFilterInteractionDemo
//
//  Created by Pace.Z on 2018/5/4.
//  Copyright © 2018年 Pace.Z. All rights reserved.
//

import UIKit

class ImageFilterCell: UICollectionViewCell {
	
	var imageName:String? {
		didSet {
			if let imageName = imageName {
				DispatchQueue.global(qos: .background).async {
					let image = UIImage(named: imageName)
					DispatchQueue.main.async {
						self.imageView.image = image
					}
				}
			}
		}
	}
	
	var title:String? {
		didSet {
			self.label.text = title
		}
	}
	
	private var imageView:UIImageView!
	private var label:UILabel!
	private var overlay: UIView = UIView()
	
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
		layer.cornerRadius = bounds.width / 2.0
		
		imageView = UIImageView()
		imageView.backgroundColor = UIColor(hex: "f0f0f0")
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		contentView.addSubview(imageView)
		imageView.snp.makeConstraints { (make) in
			make.edges.equalTo(contentView)
		}
		
		contentView.addSubview(overlay)
		overlay.snp.makeConstraints { (make) in
			make.edges.equalTo(contentView)
		}
		overlay.backgroundColor = UIColor(hex: "FF58AD")
		overlay.layer.cornerRadius = bounds.width / 2.0
		overlay.clipsToBounds = true
		overlay.alpha = 0
		overlay.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
		let checkmark = UIImageView(image: UIImage(named: "checkmark"))
		overlay.addSubview(checkmark)
		checkmark.snp.makeConstraints { (make) in
			make.top.equalTo(overlay).offset(20)
			make.centerX.equalTo(overlay)
			make.size.equalTo(CGSize(width: 25, height: 25))
		}
		
		label = UILabel()
		label.textColor = UIColor.white
		label.textAlignment = .center
		label.numberOfLines = 1
		label.font = UIFont.boldSystemFont(ofSize: 20)
		contentView.addSubview(label)
		label.snp.makeConstraints { (make) in
			make.edges.equalTo(contentView).inset(UIEdgeInsetsMake(1, 1, 1, 1))
		}
	}
	
	func check() {
		UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
			self.overlay.alpha = 1
			self.overlay.transform = CGAffineTransform.identity
		}, completion: nil)
	}
}
