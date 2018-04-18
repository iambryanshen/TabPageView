//
//  TabPageView.swift
//  TabPageView
//
//  Created by brian on 2017/11/27.
//  Copyright © 2017年 brian. All rights reserved.
//

import UIKit

class TabPageView: UIView {
    
    var style: PageStyle
    var titles: [String]
    var childVCs: [UIViewController]
    var parentVC: UIViewController
    
    public init(frame: CGRect, style: PageStyle, titles: [String], childVCs: [UIViewController], parentVC: UIViewController) {
        self.style = style
        self.titles = titles
        self.childVCs = childVCs
        self.parentVC = parentVC
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TabPageView {
    
    func setupSubviews() {
        
        // 1. 添加tabView
        let tabView = TabView(frame: bounds, style: self.style, titles: self.titles)
        tabView.backgroundColor = style.tabViewBackgroundColor
        addSubview(tabView)
        tabView.translatesAutoresizingMaskIntoConstraints = false
        tabView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        tabView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tabView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tabView.heightAnchor.constraint(equalToConstant: style.tabViewHeight).isActive = true
        
        // 2. 添加pageView
        let pageView = PageView(frame: frame, style: self.style, childVCs: self.childVCs, parentVC: self.parentVC)
        pageView.backgroundColor = style.pageViewBackgroundColor
        insertSubview(pageView, belowSubview: tabView)
        
        // 3. 设置标题栏和控制器的代理
        tabView.delegate = pageView
        pageView.delegate = tabView
    }
}
