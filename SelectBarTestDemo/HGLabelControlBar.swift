//
//  HGLabelControlBar.swift
//  SelectBarTestDemo
//
//  Created by Harvey Zhang on 2016/11/7.
//  Copyright © 2016 HappyGuy. All rights reserved.
//

import UIKit

typealias HGLabelControlBarItemSelectedCallback = (_ index: Int) -> Void

let DEFAULT_SLIDER_COLOR = UIColor.orange
let SLIDER_VIEW_HEIGHT: CGFloat = 2

// HZ: Customized label control bar, looks like a label with an underscore
class HGLabelControlBar: UIView, HGLabelControlBarItemDelegate {
	
    var itemsTitle: [String]!
    var itemColor: UIColor!
	var itemSelectedColor: UIColor!
	
	var sliderView: UIView!			// use to identify which item is selected
    var sliderColor: UIColor!
    
    fileprivate var scrollView: UIScrollView!			// contain all the bar items
	
    fileprivate var items: [HGLabelControlBarItem]!
	
    fileprivate var selectedItem: HGLabelControlBarItem! {	// store the selected item
        willSet(newValue) {
            if selectedItem != nil {
                selectedItem.selected = false
            }
        }
        didSet {
            selectedItem.selected = true
        }
    }
	
	// Just like click one of the label-control-bar-item
    fileprivate var callback: HGLabelControlBarItemSelectedCallback!
    
    // MARK: - lifecicle
    override init(frame: CGRect) {
        super.init(frame: frame)
		
        items = [HGLabelControlBarItem]()
        setupScrollView()
        setupSliderView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
	
    func setBarItemSelectedCallback(closure: @escaping HGLabelControlBarItemSelectedCallback) -> Void {
        callback = closure
    }
    
    // MARK: - Custom Accessors
	
    func setItemsTitle(itemTitles: [String]) {
        itemsTitle = itemTitles
        setupItems()
    }
    
    func setItemColor(color: UIColor) {
        for i in 0..<items.count {
            let item = items[i]
            item.setItem(titleColor: color)
        }
    }
    
    func setItemSelectedColor(color: UIColor) {
        for i in 0..<items.count {
            let item = items[i]
            item.setItemSelected(titleColor: color)
        }
    }
    
    func setSliderColor(color: UIColor) {
        sliderColor = color
        sliderView.backgroundColor = color
    }
    
    
    // MARK: - Private methods
	
    fileprivate func setupScrollView() {
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        scrollView.backgroundColor = UIColor.clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(scrollView)
    }
	
	// HZ: The slider view look like a line. In fact, it's just a hight==2 UIView with bg color
    fileprivate func setupSliderView() {
		sliderColor = DEFAULT_SLIDER_COLOR
		sliderView = UIView()
        sliderView.backgroundColor = sliderColor
		// The frame of slider view will be set later
        scrollView.addSubview(sliderView)
    }
	
	// HZ: create label control bar items and add them to the view hierarchy
    fileprivate func setupItems()
	{
        var itemX:CGFloat = 0
        for item in items {
            item.removeFromSuperview()
        }
        items.removeAll()
		
		/// Step-1: Calc label control bar items' frame and add them to the scroll view
        for i in 0..<itemsTitle.count {
            let aLCBItem = HGLabelControlBarItem()
            aLCBItem.delegate = self
			
            //set up current item's frame
            let title = itemsTitle[i]
            let itemWidth = HGLabelControlBarItem.widthForTitle(title: title)
            aLCBItem.setItem(title: title)
            aLCBItem.frame = CGRect(x: itemX, y: 0, width: itemWidth, height: scrollView.frame.size.height)
			
			items.append(aLCBItem)
            itemX = aLCBItem.frame.maxX		// move the x position
            scrollView.addSubview(aLCBItem)
        }
		
		/// Step-2: Set the scrollview's content size
        scrollView.contentSize = CGSize(width: itemX , height: scrollView.frame.height)
		
		// !!!: Here you will see the difference between scroll view's frame and its contentSize
        if scrollView.contentSize.width < self.frame.width {
            let width = scrollView.contentSize.width
            let x = (self.frame.width - width)/2		// put it in the middle of screen
            scrollView.frame = CGRect(x: x, y: 0, width: width , height: scrollView.frame.size.height)
        }
		else { // common case
            scrollView.frame = CGRect(x: 0, y: 0, width:self.frame.width, height: scrollView.frame.size.height)
        }
		
        /// Step-3: make the first item as default selection
        let firstItem = self.items.first
        firstItem?.selected = true
        selectedItem = firstItem
        
        //set frame of slider View by selected item
        sliderView.frame = CGRect(x: 0, y: self.frame.size.height - SLIDER_VIEW_HEIGHT,
                                  width: firstItem!.frame.size.width, height: SLIDER_VIEW_HEIGHT)
		
    }
    
    fileprivate func scrollToVisibleItem(item: HGLabelControlBarItem)
	{
        let selectedItemIndex = items.index(of: selectedItem)	// previous selected item
        let visibleItemIndex = items.index(of: item)			// will select item
        if selectedItemIndex == visibleItemIndex {
            return
        }
		
		// The point at which `the origin of the content view` is offset from `the origin of the scroll view`.
        var offset = scrollView.contentOffset
		
        /// Step-1: If the item to be visible is in the screen, nothing to do
        if item.frame.minX >= offset.x &&
		   item.frame.maxX <= (offset.x + scrollView.frame.size.width) {
            return
        }
        
        /// Step-2: Update the scrollView's content Offset according to different situation
        if (selectedItemIndex! < visibleItemIndex!)
		{
            // The item to be visible is on the right of the selected item and the selected item is out of screeen by the left, also the opposite case, set the offset respectively
            if (selectedItem.frame.maxX < offset.x) {
                offset.x = item.frame.minX
            } else {
                offset.x = item.frame.maxX - scrollView.frame.size.width	// make sure the new item fully appear on the screen
            }
        }
		else {
            // The item to be visible is on the left of the selected item and the selected item is out of screeen by the right, also the opposite case, set the offset respectively
            if selectedItem.frame.minX > (offset.x + scrollView.frame.size.width) {
                offset.x = item.frame.maxX - scrollView.frame.size.width
            } else {
                offset.x = item.frame.minX
            }
        }
		
        scrollView.contentOffset = offset;
    }
    
    fileprivate func addAnimationOnSelectedItem(item: HGLabelControlBarItem) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.2,
                       options: UIViewAnimationOptions.curveEaseInOut, animations: {
            var rect = self.sliderView.frame
            rect.origin.x = item.frame.minX			// only the x and width may be different with previous item's
            rect.size.width = item.frame.width
            self.sliderView.frame = rect
        }) { (finish: Bool) in
            
        }
		
    }
    
    // MARK: - HGLabelControlBarItemDelegate method
	
    func barSelected(item: HGLabelControlBarItem)
	{
        if item == selectedItem {
            return
        }
		
		scrollToVisibleItem(item: item)			// make sure the new item fully appear on the screen
        addAnimationOnSelectedItem(item: item)	// animate the slider view of the selected item
		selectedItem = item						// store selected item, attention orders
        callback( items.index(of: item)! )		// update label text
    }
    
}//End-Class
