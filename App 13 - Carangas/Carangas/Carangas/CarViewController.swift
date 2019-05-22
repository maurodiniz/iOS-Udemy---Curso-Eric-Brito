//
//  CarViewController.swift
//  Carangas
//
//  Created by Eric Brito on 21/10/17.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit
import WebKit
import Foundation

class CarViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var lbBrand: UILabel!
    @IBOutlet weak var lbGasType: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var car: Car!

    // MARK: - Super Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = car.name
        lbBrand.text = car.brand
        lbGasType.text = car.gas
        lbPrice.text = "R$ \(car.price)"
        
        // criando a url que a webview irá carregar
        let name = (title! + "+" + car.brand).replacingOccurrences(of: " ", with: "+")
        let urlString = "https://google.com/search?q=\(name)&tbm=isch"
        let url = URL(string: urlString)
        
        // com a url criada preciso criar um objeto de requisição que é o que será usado pela webview para carregar
        let request = URLRequest(url: url!)
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsLinkPreview = true
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.load(request)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddEditViewController
        vc.car = car
    }

}

extension CarViewController: WKNavigationDelegate, WKUIDelegate {
    // metodo que será chamado sempre que uma pagina for carregada
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loading.stopAnimating()
    }
}
