//
//  ViewController.swift
//  segmentPageView
//
//  Created by 宁哥 on 2017/3/1.
//  Copyright © 2017年 qyning. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        let titles = ["111","222","3333","44444","5555","6666","77777","88888","9999","1001010","11111"]
        let VCs = ["UITableViewController","UITableViewController","UITableViewController","UITableViewController","UITableViewController","UITableViewController","UITableViewController","RTStatusticsVC","UITableViewController","UITableViewController","UITableViewController"];
        
        let PagerView = segmentPageView(frame: CGRect(x: 0, y: 20, width: self.view.bounds.size.width, height: self.view.bounds.size.height-20))
     
        PagerView.sutupSegmentView(option: segmentOption(titles: titles, viewControllers: VCs, titleHeight: 44, titleBackgoundColor: nil, titleSelectedColor: nil, titleUnSelectedColor: nil, indicatorHeight: 3, indicatorSelectedColor: nil, titleFontSize: 14, scrollEnable: true))
        
        self.view.addSubview(PagerView);
    }


}

