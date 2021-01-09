//
//  BaseViewController.swift
//  NewsApi
//
//  Created by Philip on 07.01.2021.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class BaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
}
