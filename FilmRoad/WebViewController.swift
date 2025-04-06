//
//  WebViewController.swift
//  MapViewTest
//
//  Created by hello on 3/21/25.
//

import UIKit
import WebKit
class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    var url:URL?
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let url else {return}
        let request = URLRequest(url: url)
        webView.load(request)
        
    }
    
}
