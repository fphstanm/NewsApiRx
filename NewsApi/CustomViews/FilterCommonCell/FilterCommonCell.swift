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
    @IBOutlet private weak var foregroundView: UIView!
    
    
    func setup(withFilter filter: ArticlesFilterModel) {
        categoryName.text = filter.name
        choosenFilter.text = filter.selectedItems.joined(separator: ", ")

        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.foregroundView.alpha = filter.isActive ? 0.0 : 0.75
        }
    }
}
