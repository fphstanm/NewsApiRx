//
//  FilterItemCell.swift
//  NewsApi
//
//  Created by Philip on 07.01.2021.
//

import UIKit

class FilterItemCell: UITableViewCell {

    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var selectedStateImage: UIImageView!
    
    var option: ArticlesFilterItem?
    
    
    func setup(withOption option: ArticlesFilterItem) {
        self.option = option
        name.text = option.name
        selectedStateImage.isHidden = !option.isSelected
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
