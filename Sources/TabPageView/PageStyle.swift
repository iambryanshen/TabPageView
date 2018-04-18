//
//  PageStyle.swift
//  TabPageView
//
//  Created by brian on 2017/11/27.
//  Copyright © 2017年 brian. All rights reserved.
//

import UIKit

public class PageStyle: NSObject {

    //MARK: - TabView
    public var tabViewHeight: CGFloat = 44
    public var tabViewBackgroundColor: UIColor = UIColor.green
    public var scrollViewBackgroundColor: UIColor = UIColor.cyan
    public var isScrollEnable: Bool = true
    public var titleLabelMargin: CGFloat = 20
    public var selectedIndex: Int = 0
    public var isNeedScale: Bool = true
    public var maxScale: CGFloat = 1.1
    public var font = UIFont(name: "PingFangSC-Semibold", size: 15)!
    public var selectedFont = UIFont(name: "PingFangSC-Semibold", size: 15)!
    public var textColor = UIColor(red: 155/255.0, green: 48/255.0, blue: 255/255.0, alpha: 1.0)
    public var selectedTextColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
    
    //MARK: - PageView
    public var pageViewBackgroundColor: UIColor = UIColor.yellow
    public var pageViewTopOffset: CGFloat = 0
    public var pageViewBottomOffset: CGFloat = 0
    
    
    //MARK: - BottomLine
    public var isShowBottomLine: Bool = true
    public var bottomLineHeight: CGFloat = 3
    public var bottomLineWidth: CGFloat?
    
    //MARK: - CoverView
    public var isShowCoverView: Bool = true
    public var coverViewBackgroundColor : UIColor = UIColor.blue
    public var coverViewAlpha : CGFloat = 0.3
    public var coverViewHeight : CGFloat = 40
    public var coverViewRadius : CGFloat = 12
    public var coverViewMargin : CGFloat = 5
}
