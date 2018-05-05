//
//  QuizListCollectionViewFlowLayout.swift
//  QuizAppFilterInteractionDemo
//
//  Created by Pace.Z on 2018/5/4.
//  Copyright © 2018年 Pace.Z. All rights reserved.
//

import UIKit

class QuizListCollectionViewFlowLayout: SpringCollectionViewFlowLayout {

	var maxDistance:CGFloat {
		return self.itemSize.height + self.minimumLineSpacing + self.sectionInset.top
	}
	
	override func prepare() {
		
		super.prepare()
		// change headItem transform
		let visibleRect = CGRect.insetBy(CGRect(origin: collectionView!.bounds.origin, size: collectionView!.frame.size))(dx: 0, dy: 0)
		guard let headIndexPath = visibleIndexPathsSet.sorted().first else {return }
		if Int(visibleRect.origin.y / maxDistance) < headIndexPath.item {
			return
		}
		let distance = visibleRect.origin.y.truncatingRemainder(dividingBy: maxDistance)
		let scale = (1 - distance / maxDistance) > 1 ? 1 : (1 - distance / maxDistance)
		let transform = CGAffineTransform(scaleX: scale, y: scale)
		if let currentItem = animator.layoutAttributesForCell(at: headIndexPath) {
			currentItem.transform = transform
		}
	}
}
