//
//  FilterViewController.swift
//  QuizAppFilterInteractionDemo
//
//  Created by Pace.Z on 2018/4/29.
//  Copyright © 2018年 Pace.Z. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

	var layout = SpringCollectionViewFlowLayout()
	var collectionView:UICollectionView!
	
	var itemWidth:CGFloat = floor(CGFloat(SCREENWEIGHT - 10 * 4) / 3)
	var headerViewHeight:CGFloat = 60
	var collectionViewHeight:CGFloat = 0
	
	let imageFilterCellIdentifier = "imageFilterCell"
	let labelFilterCellIdentifier = "labelFilterCell"
	let headerIdentifier = "header"
	
	var infos = (0..<9).map { $0 }
	/// cell show image(false) or label(true).
	var isLabelFilter: Bool = false {
		didSet {
			if	isLabelFilter == true {
				collectionViewHeight = 40 * 6 + 10 * 7 + headerViewHeight
			} else {
				collectionViewHeight = itemWidth * 3 + 10 * 4 + headerViewHeight
			}
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		view.backgroundColor = AlphaBackgroundColor
		layout.invalidateLayout()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		view.backgroundColor = UIColor.clear
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupUI()
    }
	
	func setupUI() {

		let bgHeight = SCREENHEIGHT == 812 ? (collectionViewHeight + 34) : collectionViewHeight
		let bgView = UIView(frame: CGRect(x: 0, y: SCREENHEIGHT - bgHeight, width: SCREENWEIGHT, height: bgHeight))
		bgView.backgroundColor = UIColor.white
		bgView.clipsToBounds = true
		let path = UIBezierPath(roundedRect: bgView.bounds,
								byRoundingCorners: [.topLeft,.topRight],
								cornerRadii: CGSize(width: 10, height: 10))
		let shapeLayer = CAShapeLayer()
		shapeLayer.path = path.cgPath
		bgView.layer.mask = shapeLayer
		view.addSubview(bgView)
		
		// config collectionView
		let margin:CGFloat = 10
		layout.scrollDirection = .vertical
		layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin)
		layout.minimumLineSpacing = margin
		layout.headerReferenceSize = CGSize(width: SCREENWEIGHT, height: headerViewHeight)

		collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREENWEIGHT, height: collectionViewHeight), collectionViewLayout: layout)
		collectionView.contentInsetAdjustmentBehavior = .never
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.backgroundColor = UIColor.white
		collectionView.alwaysBounceVertical = true
		collectionView.register(ImageFilterCell.self, forCellWithReuseIdentifier: imageFilterCellIdentifier)
		collectionView.register(LabelFilterCell.self, forCellWithReuseIdentifier: labelFilterCellIdentifier)
		collectionView.register(FilterHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier)
		bgView.addSubview(collectionView)
		
		collectionView.setContentOffset(CGPoint(x: 0, y: -collectionViewHeight/2.0), animated: false)
	}
}

// MARK: - UICollectionView delegate/dataSource
extension FilterViewController: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return isLabelFilter == true ? Data.labelFilters.count : Data.imageFilters.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if	isLabelFilter == true {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: labelFilterCellIdentifier, for: indexPath) as! LabelFilterCell
			cell.title = Data.labelFilters[indexPath.row]
			return cell
		} else {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageFilterCellIdentifier, for: indexPath) as! ImageFilterCell
			cell.title = Data.imageFilters[indexPath.row]
			cell.imageName = Data.imageNames[indexPath.row]
			return cell
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier, for: indexPath) as! FilterHeaderView
		headerView.tap = {
			[unowned self] in
			self.dismiss(animated: true, completion: nil)
		}
		return headerView
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		if	isLabelFilter == true {
			let title = Data.labelFilters[indexPath.row]
			let size = UIFont.systemFont(ofSize: 18).size(of: title, with: CGSize(width: CGFloat.infinity, height: CGFloat.infinity))
			return CGSize(width: ceil(size.width) + 40, height: 40)
		} else {
			return CGSize(width: itemWidth, height: itemWidth)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if isLabelFilter == true {
			let cell = collectionView.cellForItem(at: indexPath) as! LabelFilterCell
			cell.check()
		} else {
			let cell = collectionView.cellForItem(at: indexPath) as! ImageFilterCell
			cell.check()
		}
	}
}
