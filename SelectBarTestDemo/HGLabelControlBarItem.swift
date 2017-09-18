//
//  HGLabelControlBarItem.swift
//  SelectBarTestDemo
//
//  Created by Harvey Zhang on 2016/11/7.
//  Copyright © 2016 HappyGuy. All rights reserved.
//

import UIKit

protocol HGLabelControlBarItemDelegate: NSObjectProtocol {
	// select the bar item callback
    func barSelected(item: HGLabelControlBarItem) -> Void
}

let DEFAULT_TITLE_FONTSIZE = CGFloat(15)
let DEFAULT_TITLE_SELECTED_FONTSIZE = CGFloat(16)
let DEFAULT_TITLE_COLOR = UIColor.black
let DEFAULT_TITLE_SELECTED_COLOR = UIColor.orange
let HORIZONTAL_MARGIN: CGFloat = 10

// Customize a bar view like a label
class HGLabelControlBarItem: UIView {
	
    var selected: Bool! {
        didSet {
            setNeedsDisplay()	// value changed, color & font also change
        }
    }
	
    weak var delegate: HGLabelControlBarItemDelegate?
	
    private var title: String!
    private var fontSize: CGFloat!
    private var selectedFontSize: CGFloat!
    private var color: UIColor!
    private var selectedColor: UIColor!
    
    init() {
        super.init(frame:CGRect(x:0, y:0, width:0, height:0))
		// It's frame will be set later
        self.fontSize = DEFAULT_TITLE_FONTSIZE
        self.selectedFontSize = DEFAULT_TITLE_SELECTED_FONTSIZE
        self.color = DEFAULT_TITLE_COLOR
        self.selectedColor = DEFAULT_TITLE_SELECTED_COLOR
        self.selected = false
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
    override func draw(_ rect: CGRect) {
        let size = self.frame.size
		let aTitleSize = titleSize()
		
		let titleX = (size.width - aTitleSize.width) * 0.5
        let titleY = (size.height - aTitleSize.height) * 0.5
        let titleRect = CGRect(x: titleX, y: titleY, width: aTitleSize.width, height: aTitleSize.height)
		
        let attributes = [NSFontAttributeName: titleFont(),
                          NSForegroundColorAttributeName: titleColor()]
		
        let strTitle = NSString(string: title!)
		
		// HZ: Draw text in rect
		strTitle.draw(in: titleRect, withAttributes: attributes)
    }
    
    // MARK: - public
	
    func setItem(title: String) -> Void {
        self.title = title
        self.setNeedsDisplay()
    }
    
    func setItem(titleFontSize: CGFloat) -> Void {
        self.fontSize = titleFontSize
        setNeedsDisplay()
    }
    
    func setItem(titleColor: UIColor) -> Void {
        self.color = titleColor
        setNeedsDisplay()
    }
    
    func setItemSelected(titleFontSize: CGFloat) -> Void {
        self.selectedFontSize = titleFontSize
        setNeedsDisplay()
    }
    
    func setItemSelected(titleColor: UIColor) -> Void {
        self.selectedColor = titleColor
        setNeedsDisplay()
    }
    
    // MARK: - Private
	
	// HZ: Calculate the title size based on string length and font size
    fileprivate func titleSize() -> CGSize {
        let attributes = [NSFontAttributeName: titleFont()]
        let strTitle = NSString(string: self.title!)
        var size = strTitle.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)),
                                         options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size
        size.width = ceil(size.width)
        size.height = ceil(size.height)
        return size
    }
    
    fileprivate func titleFont() -> UIFont {
		return (self.selected == true) ? UIFont.boldSystemFont(ofSize: self.selectedFontSize) : UIFont.systemFont(ofSize: self.fontSize)
    }
    
    fileprivate func titleColor() -> UIColor {
		return (self.selected == true) ? self.selectedColor : self.color
    }
    
    // MARK: - Public Class Method
    
    class func widthForTitle(title: String) -> CGFloat {
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: DEFAULT_TITLE_FONTSIZE)]
        let strTitle = NSString(string: title)
        var size = strTitle.boundingRect(with: CGSize(width:CGFloat(MAXFLOAT), height:CGFloat(MAXFLOAT)),
                                         options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                         attributes: attributes, context: nil).size
        size.width = ceil(size.width) + HORIZONTAL_MARGIN * 2
        return size.width
    }
    
    // MARK: - Responder
	
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.selected = true
		if (self.delegate != nil) {
            self.delegate!.barSelected(item: self)
        }
    }
	
}
