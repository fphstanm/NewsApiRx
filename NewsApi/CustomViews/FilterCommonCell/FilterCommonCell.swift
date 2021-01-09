//
//  FilterCommonCell.swift
//  NewsApi
//
//  Created by Philip on 07.01.2021.
//

import UIKit

final class FilterCommonCell: UITableViewCell {

    @IBOutlet private weak var categoryName: UILabel!
    @IBOutlet private weak var choosenFilter: UILabel!
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(withFilter filter: ArticlesFilterModel) {
        categoryName.text = filter.name
        choosenFilter.text = filter.selectedOption ?? filter.defaultOption
    }
}
