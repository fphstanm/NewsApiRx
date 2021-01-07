//
//  UIViewController.swift
//  NewsApi
//
//  Created by Philip on 07.01.2021.
//

import UIKit

extension UIViewController {
    func initControllerFromStoryboard(of type: UIViewController.Type) -> UIViewController? {
        let className = String(describing: type)
        let storyboard = UIStoryboard(name: className, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: className)
        
        return controller
    }
}
