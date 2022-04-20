//
//  ViewController.swift
//  browser
//
//  Created by 佐藤裕太 on 2020/09/16.
//  Copyright © 2020 佐藤裕太. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var browserWebView: UIWebView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var browserActivityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.browserWebView.delegate = self
        self.urlTextField.delegate = self
        self.browserActivityIndicatorView.hidesWhenStopped = true
            
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField != self.urlTextField{
            return true
        }
        if let urlString = textField.text{
            self.loadUrl(urlString: urlString)
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField != self.urlTextField{
            return
        }
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.browserActivityIndicatorView.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if let urlString = self.browserWebView.request?.url?.absoluteString{
            self.urlTextField.text = urlString
        }
        self.browserActivityIndicatorView.stopAnimating()
        self.backButton.isEnabled = self.browserWebView.canGoBack
        self.forwardButton.isEnabled = self.browserWebView.canGoForward
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let urlString = "https://google.com"
        //let urlString = ""
        self.loadUrl(urlString:urlString)
        self.addBorder()
    }
    
    func addBorder(){
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0.0, y: 0.0, width: self.browserWebView.frame.size.width, height: 1.0)
        topBorder.backgroundColor = UIColor.lightGray.cgColor
        self.browserWebView.layer.addSublayer(topBorder)
    }
    
    func showAlert(_ message:String){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        if(error as! URLError).code == URLError.cancelled{
            return
        }
        self.showAlert("Network Error")
        self.browserWebView.stopLoading()
        self.browserActivityIndicatorView.stopAnimating()
    }
    
    func getValidatedUrl(urlString:String) -> URL?{
        let trimmed = urlString.trimmingCharacters(in: NSCharacterSet.whitespaces)
        if URL(string:trimmed) == nil{
            //print("Invalid URL")
            self.showAlert("Invalid URL")
            return nil
        }
        return URL(string:self.appendScheme(trimmed))
    }
    
    func appendScheme(_ urlString: String) -> String {
        if URL(string: urlString)?.scheme == nil {
            return "http://" + urlString
        }
        return urlString
    }
    
    func loadUrl(urlString:String){
        if let url = self.getValidatedUrl(urlString:urlString){
            let urlRequest = URLRequest(url: url)
            self.browserWebView.loadRequest(urlRequest)
        }
    }
    
    @IBAction func goback(_ sender: Any) {
        self.browserWebView.goBack()
    }
    
    @IBAction func goforward(_ sender: Any) {
        self.browserWebView.goForward()
    }
    
    @IBAction func reload(_ sender: Any) {
        self.browserWebView.reload()
    }
}

