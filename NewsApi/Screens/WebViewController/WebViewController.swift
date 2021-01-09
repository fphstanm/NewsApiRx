//
//  WebViewController.swift
//  NewsApi
//
//  Created by Philip on 09.01.2021.
//

import Foundation
import WebKit


class WebViewController: UIViewController {
    
    var webView: WKWebView!
    var urlString = ""
    
    
    override func viewDidLoad() {
        loadView()
        
        guard let url = URL(string: urlString) else { return }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
}

extension WebViewController: WKNavigationDelegate {
    
}
