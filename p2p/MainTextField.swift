//
//  MainTextField.swift
//  p2p
//
//  Created by Amar Ramachandran on 10/16/16.
//  Copyright © 2016 sfhacks. All rights reserved.
//

import UIKit

class MainTextField: UITextField {
    let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 5);

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        create()
    }
    required override init(frame: CGRect) {
        super.init(frame: frame)
        create()
    }
    
    func create() {
        self.layer.cornerRadius = 0.0
        self.layer.shadowOpacity = 0.35
        self.layer.shadowRadius = 2.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
