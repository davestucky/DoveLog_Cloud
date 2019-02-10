//
//  UITextFieldExtension.swift
//  DoveLog_Cloud
//
//  Created by Dave Stucky on 2/8/19.
//  Copyright © 2019 Dave Stucky. All rights reserved.
//

import UIKit

extension UITextField   {
    var hasValue: Bool  {
        guard text == "" else { return true }
        
        let imageView = UIImageView(frame: CGRect (x: 0,  y:0, width: 30, height:20) )
        imageView.image = #imageLiteral(resourceName: "warningtriangle")
        imageView.contentMode = .scaleAspectFit
        rightView = imageView
        rightViewMode = .unlessEditing
        
        return false
        
    }
}
