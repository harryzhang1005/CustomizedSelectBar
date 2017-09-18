# Customized Select Bar Item

Animate the slider view to identify which item has been selected

```swift
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
```

Calculate the title width

```swift
class func widthForTitle(title: String) -> CGFloat {
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: DEFAULT_TITLE_FONTSIZE)]
        let strTitle = NSString(string: title)
        var size = strTitle.boundingRect(with: CGSize(width:CGFloat(MAXFLOAT), height:CGFloat(MAXFLOAT)),
                                         options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                         attributes: attributes, context: nil).size
        size.width = ceil(size.width) + HORIZONTAL_MARGIN * 2
        return size.width
    }
```
Happy coding! :+1:  :sparkles:
