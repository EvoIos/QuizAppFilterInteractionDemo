//
//  ViewController.swift
//  QuizAppFilterInteractionDemo
//
//  Created by Pace.Z on 2018/4/28.
//  Copyright © 2018年 Pace.Z. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - Constant
let SCREENHEIGHT = UIScreen.main.bounds.size.height
let SCREENWEIGHT = UIScreen.main.bounds.size.width
let AlphaBackgroundColor = UIColor.black.withAlphaComponent(0.75)

typealias Data = FalseData

// MARK: -
class QuizListViewController: UIViewController, UIViewControllerTransitioningDelegate {
	
	let layout = QuizListCollectionViewFlowLayout()
	var collectionView:UICollectionView!
	let filterButton = UIButton()
	let transition = BubbleTransition()
	var infos:[QuizListCellModel] = []
	var filterCenter:CGPoint = CGPoint.zero
	
	var firstIn = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// makeup data
		let max = Data.titles.count
		(0..<max).forEach { (index) in
			let model = QuizListCellModel(colors: Data.gradientColors[index],
										  title: Data.titles[index],
										  detail: Data.details[index])
			infos.append(model)
		}
		
		// config collectionView
		layout.scrollDirection = .vertical
		layout.itemSize = CGSize(width: ceil(SCREENWEIGHT - 20), height: 144)
		layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
		layout.minimumLineSpacing = 10
		layout.minimumInteritemSpacing  = 10
		collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
		collectionView.contentInsetAdjustmentBehavior = .never
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.backgroundColor = UIColor.white
		collectionView.alwaysBounceHorizontal = false
		collectionView.register(QuizListCell.self, forCellWithReuseIdentifier: "cell")
		view.addSubview(collectionView)
		collectionView.snp.makeConstraints { (make) in
			make.edges.equalTo(self.view)
		}
		
		// filter button
		filterButton.backgroundColor = UIColor(hex: "304456")
		filterButton.setImage(UIImage(named: "filter"), for: .normal)
		filterButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		filterButton.clipsToBounds = true
		filterButton.layer.cornerRadius = 25
		filterButton.addTarget(self, action: #selector(showFilter(sender:)), for: .touchUpInside)
		view.addSubview(filterButton)
		filterButton.snp.makeConstraints { (make) in
			make.size.equalTo(CGSize.init(width: 50, height: 50))
			make.right.equalTo(self.view).offset(-15)
			if	#available(iOS 11.0, *) {
				make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
			} else {
				make.bottom.equalTo(view).offset(-20)
			}
		}
		
		// transition
		view.layoutIfNeeded()
		transition.startingPoint = filterButton.center
		transition.options = .curveEaseOut
		transition.duration = 0.3
		transition.bubbleColor = AlphaBackgroundColor
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if !firstIn { return }

		collectionView.setContentOffset(CGPoint.zero, animated: false)
		collectionView.setContentOffset(CGPoint(x: 0, y: -SCREENHEIGHT), animated: false)

		UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseInOut, animations: {
			self.collectionView.setContentOffset(CGPoint.zero, animated: false)
		}, completion: nil)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		layout.invalidateLayout()
		if !firstIn {
			firstIn = true
			collectionView.setContentOffset(CGPoint(x: 0, y: -SCREENHEIGHT), animated: false)
			UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseInOut, animations: {
				self.collectionView.setContentOffset(CGPoint.zero, animated: false)
			}, completion: nil)
		}
	}
	
	@objc func showFilter(sender: UIButton) {
		sender.isHidden = true
		let filterVC = FilterViewController()
		filterVC.transitioningDelegate = self
		filterVC.modalPresentationStyle = .custom
		filterVC.isLabelFilter = sender.isSelected
		self.present(filterVC, animated: true) {
			sender.isHidden = false
			sender.isSelected = !sender.isSelected
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

// MARK: - transitioning delegate
extension QuizListViewController {
	// MARK: UIViewControllerTransitioningDelegate
	
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		transition.transitionMode = .present
		return transition
	}
	
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		transition.transitionMode = .dismiss
		return transition
	}
	
}

// MARK: - UICollectionView delegate/dataSource
extension QuizListViewController: UICollectionViewDelegate,UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return infos.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! QuizListCell
		cell.model = infos[indexPath.row]
		return cell
	}
}


