//
//  SpringCollectionViewFlowLayout
//  UIComponentSwift
//
//  Created by z on 2018/5/3.
//  Copyright © 2018年 z. All rights reserved.
//

import UIKit

class SpringCollectionViewFlowLayout: UICollectionViewFlowLayout {
	
	var resistance:CGFloat = 1000.0
	
	var animator:UIDynamicAnimator!
	var visibleIndexPathsSet:Set<IndexPath> = []
	private var latestDelta:CGFloat = 0
	private lazy var centerHolders:[CGFloat] = []
	
	override init() {
		super.init()
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	func setup() {
		animator = UIDynamicAnimator(collectionViewLayout: self)
	}
}

extension SpringCollectionViewFlowLayout {
	override func prepare() {
		super.prepare()
		
		let visibleRect = CGRect.insetBy(CGRect.init(origin: collectionView!.bounds.origin, size: collectionView!.frame.size))(dx: 0, dy: 0)
		let items = super.layoutAttributesForElements(in: visibleRect)!.map { $0.copy() as! UICollectionViewLayoutAttributes }
		let itemsIndexPaths = Set(items.map { $0.indexPath })
		
		// remove old behaviors that no longer visible
		let noLongerVisibleBehaviours = animator.behaviors.filter { (behavior) -> Bool in
			let attachmentBehavior = behavior as! UIAttachmentBehavior
			let attribute = attachmentBehavior.items.first! as! UICollectionViewLayoutAttributes
			let indexPath = attribute.indexPath
			let currentlyVisible = itemsIndexPaths.contains(indexPath) != false
			return !currentlyVisible
		}
		
		noLongerVisibleBehaviours.forEach { (behavior) in
			animator.removeBehavior(behavior)
			let attachmentBehavior = behavior as! UIAttachmentBehavior
			let attribute = attachmentBehavior.items.first! as! UICollectionViewLayoutAttributes
			let indexPath = attribute.indexPath
			animator.removeBehavior(behavior)
			visibleIndexPathsSet.remove(indexPath)
		}
		
		// add newly behaviors that visibleIndexPathsSet not contains
		let newlyVisibleItems = items.filter { (item) -> Bool in
			let currentlyVisible = visibleIndexPathsSet.contains(item.indexPath) != false
			return !currentlyVisible
		}
		
		let touchLocation = collectionView!.panGestureRecognizer.location(in: collectionView!)
		
		for item in newlyVisibleItems {
			var center = item.center
			let springBehavior = UIAttachmentBehavior.init(item: item, attachedToAnchor: center)
			springBehavior.length = 0.0
			springBehavior.damping = 0.8
			springBehavior.frequency = 1.0
			
			if !__CGPointEqualToPoint(CGPoint.zero, touchLocation) {
				
				let yDistanceFromTouch = fabsf(Float(touchLocation.y - springBehavior.anchorPoint.y))
				let xDistanceFromTouch = fabsf(Float(touchLocation.x - springBehavior.anchorPoint.x))
				let scrollResistance:CGFloat = CGFloat(yDistanceFromTouch + xDistanceFromTouch) / resistance
				
				if self.latestDelta < 0{
					center.y += max(self.latestDelta, self.latestDelta * scrollResistance)
				} else {
					center.y += min(self.latestDelta, self.latestDelta * scrollResistance)
				}
				item.center = center
			}
			animator.addBehavior(springBehavior)
			visibleIndexPathsSet.insert(item.indexPath)
		}
	}
	
	override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		let delta = newBounds.origin.y - collectionView!.bounds.origin.y
		self.latestDelta = delta
		
		let touchLocation =  collectionView!.panGestureRecognizer.location(in: collectionView!)
		
		for behavior in animator.behaviors {
			let springBehaviour = behavior as! UIAttachmentBehavior
			
			let yDistanceFromTouch = fabsf(Float(touchLocation.y - springBehaviour.anchorPoint.y))
			let xDistanceFromTouch = fabsf(Float(touchLocation.x - springBehaviour.anchorPoint.x))
			let  scrollResistance = CGFloat(yDistanceFromTouch + xDistanceFromTouch) / resistance
			
			let item = springBehaviour.items.first!
			var center = item.center
			if delta < 0 {
				center.y += max(delta, delta * scrollResistance)
			} else {
				center.y += min(delta, delta * scrollResistance)
			}
			item.center = center
			animator.updateItem(usingCurrentState: item)
		}
		
		return false
	}
	
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		return animator.items(in: rect) as? [UICollectionViewLayoutAttributes]
	}
	
	override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		return animator.layoutAttributesForCell(at: indexPath)
	}
}

