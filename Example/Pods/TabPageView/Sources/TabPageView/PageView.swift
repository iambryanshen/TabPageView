//
//  PageView.swift
//  TabPageView
//
//  Created by brian on 2017/11/27.
//  Copyright © 2017年 brian. All rights reserved.
//

import UIKit

protocol PageViewDelegate: class {
    // 调整标题的位置
    func pageView(pageView: PageView, currentIndex: Int)
    // 调整标题的样式
    func pageView(pageView: PageView, currentIndex: Int, previousIndex: Int, progress: CGFloat)
}

class PageView: UIView {
    
    weak var delegate: PageViewDelegate?
    var collectionView: UICollectionView?
    var startOffsetX: CGFloat = 0
    var isForbidDelegate: Bool = false
    var isScrollToRight: Bool = true    // 是否是往右滚动
    
    var currentIndex: Int = 0
    var previousIndex: Int = 0
    var progress: CGFloat = 0
    
    var style: PageStyle
    var childVCs: [UIViewController]
    var parentVC: UIViewController
    
    init(frame: CGRect, style: PageStyle, childVCs: [UIViewController], parentVC: UIViewController) {
        self.style = style
        self.childVCs = childVCs
        self.parentVC = parentVC
        super.init(frame: frame)
        
        setupSubviews()
        defaultSetting()
    }
    
    private func defaultSetting() {
        collectionView?.scrollToItem(at: IndexPath(item: style.selectedIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PageView {
    
    func setupSubviews() {
        addCollectionView()
        addChildVC()
    }
    
    func addCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: bounds.width, height: bounds.height - style.pageViewTopOffset - style.pageViewBottomOffset)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView = collectionView
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "TabPageViewID")
        if #available(iOS 11, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            parentVC.automaticallyAdjustsScrollViewInsets = false
        }
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: topAnchor, constant: style.pageViewTopOffset).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -style.pageViewBottomOffset).isActive = true
    }
    
    func addChildVC() {
        for childVC in childVCs {
            parentVC.addChildViewController(childVC)
        }
    }
}

extension PageView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabPageViewID", for: indexPath)
        let childVC = childVCs[indexPath.item]
        childVC.view.frame = cell.contentView.frame
        cell.contentView.addSubview(childVC.view)
        return cell
    }
}

extension PageView: UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidDelegate = false
        //获取开始偏移量
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isForbidDelegate { return }
        
        // 1. 获取currentIndex、previousIndex
        let currentOffsetX = scrollView.contentOffset.x
        // 往左滑动
        if currentOffsetX > startOffsetX {
            currentIndex = Int(ceil(currentOffsetX/bounds.width))
            previousIndex = currentIndex - 1
            progress = 1 - (ceil(currentOffsetX/bounds.width) - currentOffsetX/bounds.width)
            isScrollToRight = true
        } else if currentOffsetX < startOffsetX {
            currentIndex = Int(floor(currentOffsetX/bounds.width))
            previousIndex = currentIndex + 1
            progress = 1 - (currentOffsetX/bounds.width - floor(currentOffsetX/bounds.width))
            isScrollToRight = false
        } else {
            if isScrollToRight {
                currentIndex = currentIndex - 1
                previousIndex = previousIndex + 1
            } else {
                currentIndex = currentIndex + 1
                previousIndex = previousIndex - 1
            }
            progress = 1
        }
        
        // 临界值判断
        if currentIndex < 0 {
            currentIndex = 0
        }
        
        // 临界值判断
        if previousIndex < 0 {
            previousIndex = 0
        }
        
        // 临界值判断
        if currentIndex > childVCs.count - 1 {
            currentIndex = childVCs.count - 1
        }
        
        // 临界值判断
        if previousIndex > childVCs.count - 1 {
            previousIndex = childVCs.count - 1
        }
        
        delegate?.pageView(pageView: self, currentIndex: currentIndex, previousIndex: previousIndex, progress: progress)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if style.isScrollEnable {
            collectionViewDidEndScroll(scrollView: scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if style.isScrollEnable {
            collectionViewDidEndScroll(scrollView: scrollView)
        }
    }
    
    private func collectionViewDidEndScroll(scrollView: UIScrollView) {
        //1. 获取当前选中的pageView的currentIndex
        let currentIndex = Int(scrollView.contentOffset.x/scrollView.bounds.width)
        //2. 通知tabView移动当前选中的titleLabel到屏幕中间位置
        delegate?.pageView(pageView: self, currentIndex: currentIndex)
    }
}

extension PageView: TabViewDelegate {
    func tabView(tabView: TabView, currentIndex: Int) {
        isForbidDelegate = true
        collectionView?.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: false)
    }
}
