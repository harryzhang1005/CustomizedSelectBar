//
//  ViewController.swift
//  SelectBarTestDemo
//
//  Created by Harvey Zhang on 2016/11/7.
//  Copyright © 2016 HappyGuy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let strArray = ["Apple", "Google", "Microsoft", "Facebook", "IBM", "Intel", "Alibaba", "Baidu", "Tencent", "Huawei"]
    var label: UILabel!
	var labelBar: HGLabelControlBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
		
		setupLabel()
		
        setupLabelControlBar()
    }
	
	// MARK: - Private helpers
	
	fileprivate func setupLabel() -> Void
	{
		label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
		label.center = CGPoint(x: UIScreen.main.bounds.width/2, y: 200)
		label.textColor = .white
		label.backgroundColor = .red
		label.textAlignment = .center
		
		self.view.addSubview(label)
	}
	
	// Test our customized label control bar
    fileprivate func setupLabelControlBar()
	{
		let bar = HGLabelControlBar(frame: CGRect(x: 0, y: 50, width: UIScreen.main.bounds.width, height: 40))
        bar.backgroundColor = .white
        bar.setItemColor(color: .white)
        bar.setItemSelectedColor(color: .orange)
		bar.setSliderColor(color: .orange)
		
		bar.setBarItemSelectedCallback { [weak self] (index: Int) in
            print("index clicked: \(index)")
			self?.label.text = (index == 0) ? "The First Company" : "The No.\(index) Company"	// Update UI
        }
		
		labelBar = bar
        self.view.addSubview(bar)
        
        // setup the bar items and make the first one as default selection
        labelBar.setItemsTitle(itemTitles: strArray)
		label.text = "The First Company"
    }
	
}
