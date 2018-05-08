//
//  ViewController.swift
//  Example
//
//  Created by brian on 2018/4/18.
//  Copyright © 2018年 Brian Inc. All rights reserved.
//


import UIKit
import TabPageView

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let titles = ["iPhone", "iOS", "KobeBryant", "Beautiful Girl", "iPod", "brianbryant", "Jordan", "中国", "Taylor Swift"]
        let titles = ["我的", "你的", "她的"]
        
        var childVCs = [UIViewController]()
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            childVCs.append(vc)
        }
        
        let style = PageStyle()
        style.isScrollEnable = false
        let titleContentView = TabPageView(frame: self.view.bounds, style: style, titles: titles, childVCs: childVCs, parentVC: self)
        titleContentView.backgroundColor = UIColor.orange
        
        view.addSubview(titleContentView)
        view.backgroundColor = UIColor.red
    }
}
