//
//  segmentPageView.swift
//  apricot
//
//  Created by 宁哥 on 2017/2/28.
//  Copyright © 2017年 ritu. All rights reserved.
//

import UIKit

struct segmentOption{
    
    let titles: [String]
    let viewControllers:[String]
    
    let titleHeight:CGFloat!
    let titleBackgoundColor:UIColor!
    let titleSelectedColor:UIColor!
    let titleUnSelectedColor:UIColor!
    let indicatorHeight:CGFloat!
    let indicatorSelectedColor:UIColor!
    let titleFontSize:CGFloat!
    
    let scrollEnable:Bool!
    
    
    init(titles: [String],
         viewControllers:[String],
         titleHeight:CGFloat?,
         titleBackgoundColor:UIColor?,
         titleSelectedColor:UIColor?,
         titleUnSelectedColor:UIColor?,
         indicatorHeight:CGFloat?,
         indicatorSelectedColor:UIColor?,
         titleFontSize:CGFloat?,
         scrollEnable:Bool!) {
        
        self.titles = titles
        self.viewControllers = viewControllers
        self.titleHeight = titleHeight ?? 40
        self.titleBackgoundColor = titleBackgoundColor ?? UIColor(red: 234, green: 234, blue: 234)
        self.titleSelectedColor = titleSelectedColor ?? UIColor(red: 33, green: 149, blue: 244)
        self.titleUnSelectedColor = titleUnSelectedColor ?? UIColor(red: 200, green: 200, blue: 200)
        self.indicatorHeight = indicatorHeight ?? 2
        self.indicatorSelectedColor = indicatorSelectedColor ?? UIColor(red: 33, green: 149, blue: 244)
        self.titleFontSize = titleFontSize ?? 15
        self.scrollEnable = scrollEnable
    }
}


class segmentPageView: UIView ,UIScrollViewDelegate{
    
    open func sutupSegmentView(option:segmentOption) {
        self.titles = option.titles
        self.viewControllers = option.viewControllers
        self.titleHeight = option.titleHeight
        self.IndicatorHeight = option.indicatorHeight
        self.titleBackgoundColor = option.titleBackgoundColor
        self.titleSelectedColor = option.titleSelectedColor
        self.titleUnSelectedColor = option.titleUnSelectedColor
        self.indicatorSelectedColor = option.indicatorSelectedColor
        self.titleFontSize = option.titleFontSize
        self.ScrollEnable = option.scrollEnable
        if self.titles.count > 5{
            self.titleWidth = self.bounds.size.width*0.2
        }else{
            self.titleWidth = self.bounds.size.width/CGFloat(titles.count)
        }
        self.addSubview(titleScrollerView)
        self.addSubview(contentScrollerView)
        addTitles()
        addViewControllS()
    }
    
    private var titles:[String]!
    
    private var viewControllers:[String]!
    
    private var VCs = [UIViewController]()
    
    private var titleHeight:CGFloat!
    
    private var IndicatorHeight:CGFloat!
    
    private var titleWidth:CGFloat!
    
    private var titleFontSize:CGFloat!
    
    private var titleBackgoundColor:UIColor!
    
    private var titleSelectedColor:UIColor!
    
    private var titleUnSelectedColor:UIColor!
    
    private var indicatorSelectedColor:UIColor!
    
    private var titleBtns = [UIButton]()
    
    private var IndicatorLine: UIView!
    
    private var ScrollEnable: Bool!
    
    private var index = 0{
        didSet{
            if titles.count > 5 {
                if index >= 2 && index < titles.count-2{
                    self.titleScrollerView.setContentOffset(CGPoint(x: self.titleWidth*CGFloat(index-2), y: 0), animated: true)
                    
                }else if self.index >= self.titles.count-2{
                    self.titleScrollerView.setContentOffset(CGPoint(x: self.titleWidth*CGFloat(self.titles.count-5), y: 0), animated: true)
                }
            }
        }
    }
    private var titleIndex = 0{
        didSet{
            self.contentScrollerView.setContentOffset(CGPoint(x: self.bounds.size.width*CGFloat(self.titleIndex), y: 0), animated: true)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func selectIndex(btn:UIButton) {
        titleIndex = btn.tag
    }
    private func addTitles() {
        for index in 0 ..< self.titles.count {
            let btn = UIButton()
            btn.tag = index
            btn.frame = CGRect(x: self.titleWidth*CGFloat(index), y: 0, width: self.titleWidth, height: self.titleHeight-IndicatorHeight)
            btn.setTitle(self.titles[index], for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: self.titleFontSize)
            let titleColor = index == 0 ? titleSelectedColor : titleUnSelectedColor
            btn.setTitleColor(titleColor, for: .normal)
            btn.backgroundColor = UIColor.clear
            btn.addTarget(self, action: #selector(segmentPageView.selectIndex(btn:)), for: .touchUpInside)
            titleScrollerView.addSubview(btn)
            titleBtns.append(btn)
        }
        let lineView = UIView()
        lineView.frame = CGRect(x: 0, y: titleHeight-IndicatorHeight, width: titleWidth, height: IndicatorHeight)
        lineView.backgroundColor = indicatorSelectedColor
        IndicatorLine = lineView
        lineView.layer.cornerRadius = IndicatorHeight*0.5
        titleScrollerView.addSubview(lineView)
    }
    private func addViewControllS() {
        for index in 0 ..< self.viewControllers.count {
            if let vc = swiftClassFromString(className: self.viewControllers[index]){
                VCs.append(vc)
                vc.view.frame = CGRect(x: self.bounds.size.width*CGFloat(index), y: 0, width: self.bounds.size.width, height: self.bounds.size.height - self.titleHeight)
                self.contentScrollerView.addSubview(vc.view)
            }
        }
    }
    
    lazy var titleScrollerView: UIScrollView! = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.tag = 512
        scrollView.scrollsToTop = false
        let count = CGFloat(self.titles.count)
        scrollView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.titleHeight)
        scrollView.contentSize = CGSize(width: self.titleWidth*count, height: self.titleHeight)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.backgroundColor = self.titleBackgoundColor
        self.addSubview(scrollView)
        return scrollView
    }()
    
    lazy var contentScrollerView: UIScrollView! = {
        let scrollView = UIScrollView()
        scrollView.tag = 1024
        scrollView.autoresizesSubviews = false
        scrollView.delegate = self
        scrollView.scrollsToTop = false
        scrollView.isScrollEnabled = self.ScrollEnable;
        scrollView.isPagingEnabled = true
        scrollView.frame = CGRect(x: 0, y: self.titleScrollerView.bounds.size.height, width: self.bounds.size.width, height: self.bounds.size.height-self.titleHeight)
        scrollView.contentSize = CGSize(width: self.bounds.size.width * CGFloat(self.titles.count), height: self.bounds.size.height-self.titleHeight)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        self.addSubview(scrollView)
        return scrollView
    }()
    
    // MARK: - 代理
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 1024{
            let contentOffsetX = scrollView.contentOffset.x
            self.IndicatorLine.center = CGPoint(x: self.titleWidth*0.5 + self.titleWidth*CGFloat((contentOffsetX / self.bounds.size.width)), y: self.titleHeight-self.IndicatorHeight*0.5)
            
            let num = Int(contentOffsetX / self.bounds.size.width+0.5)
            
            if num == index {
                return
            }
            titleBtns[index].setTitleColor(titleUnSelectedColor, for: .normal)
            index = num
            titleBtns[index].setTitleColor(titleSelectedColor, for: .normal)
            
        }
    }
}

extension NSObject {
    
    func swiftClassFromString(className: String) -> UIViewController! {
        if  let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String? {
            let classStringName = "\(appName).\(className)"
            let classType = NSClassFromString(classStringName) as? UIViewController.Type
            if let type = classType {
                let newVC = type.init()
                return newVC
            }
        }
        return nil;
    }
}
extension UIColor {
    
    /// color by rgb
    ///
    /// - Parameters:
    ///   - red: 1
    ///   - green: 2
    ///   - blue: 3
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
    
}
