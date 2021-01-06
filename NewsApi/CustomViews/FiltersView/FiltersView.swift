//
//  FiltersView.swift
//  NewsApi
//
//  Created by Philip on 06.01.2021.
//

import UIKit

class FiltersView: UIView {
    @IBOutlet weak var label1: UILabel!
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("FiltersView", owner: self, options: nil)
    }
}
