//
//  CardView.swift
//  p2p
//
//  Created by Amar Ramachandran on 10/18/16.
//  Copyright © 2016 sfhacks. All rights reserved.
//

import UIKit

class CardView: UIView {

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
        self.layer.shadowOpacity = 0.25
        self.layer.shadowRadius = 2.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    }

}
