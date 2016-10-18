//
//  TutorListQueryBar.swift
//  p2p
//
//  Created by Amar Ramachandran on 10/17/16.
//  Copyright © 2016 sfhacks. All rights reserved.
//

import UIKit

class TutorListQueryBar: UIView {
    @IBOutlet weak var subjectField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        create()
    }
    required override init(frame: CGRect) {
        super.init(frame: frame)
        create()
    }
    
    func create() {
        self.layer.shadowOpacity = 0.25
        self.layer.shadowRadius = 10.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.subjectField.bottomBorder(color: #colorLiteral(red: 0.8039215686, green: 0.8039215686, blue: 0.8039215686, alpha: 1), width: 1.0)
        self.locationField.bottomBorder(color: #colorLiteral(red: 0.8039215686, green: 0.8039215686, blue: 0.8039215686, alpha: 1), width: 1.0)
    }
}

extension UITextField
{
    func bottomBorder(color: UIColor, width: Double) {
        
        let border = CALayer()
        let width = CGFloat(width)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
}
