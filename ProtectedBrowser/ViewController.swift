//
//  ViewController.swift
//  ProtectedBrowser
//
//  Created by Joyson  on 18/06/20.
//  Copyright © 2020 mobishala. All rights reserved.
//

import UIKit
import UIKit
import WebKit

class ViewController: UIViewController {
    
   @IBOutlet weak var webView: WKWebView!
   @IBOutlet weak var textField: UITextField!
   @IBOutlet weak var backButton: UIBarButtonItem!
   @IBOutlet weak var forwardButton: UIBarButtonItem!
   @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    let manager = LocalNotificationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        refreshNavigationControls()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           textField.becomeFirstResponder()
       }
       
       @IBAction func handleReturnPress(_ sender: UITextField) {
           guard let text = sender.text, let url = URL.httpURL(withString: text) else {
               return
           }
           webView.load(URLRequest(url: url))
       }
       
       @IBAction func handleBackButtonPress(_ sender: UIBarButtonItem) {
           webView.stopLoading()
           webView.goBack()
       }
       
       @IBAction func handleForwardButtonPress(_ sender: UIBarButtonItem) {
           webView.stopLoading()
           webView.goForward()
       }
       
       @IBAction func handleRefreshButtonPress(_ sender: UIBarButtonItem) {
           webView.reload()
       }
       
       // MARK: Private methods
       
       private func refreshNavigationControls() {
           backButton.isEnabled = webView.canGoBack
           forwardButton.isEnabled = webView.canGoForward
           refreshButton.isEnabled = webView.url != nil
       }


}

extension ViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        refreshNavigationControls()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = ProtectedBrowserse
        textField.text = webView.url?.absoluteString
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url , let host = url.host {
            if Constants.blockedDomains.contains(host)  {
                decisionHandler(.cancel)

//                 to get alert
//                self.presentAlertWithTitle(title: "Warning", message: "\(Constants.blockedMessgae)  \(host)", options: [.ok]) { (opted) in
//
//                }

//                sendNotification(domain: host)
            } else {
                decisionHandler(.allow)
//                removeNotification()
            }
        }else{
            decisionHandler(.allow)

        }

    }
    func sendNotification(domain:String){
        // setting 2 seconds delay
      let seconds: TimeInterval = 1 * 2
      let date = Date() + seconds
      let newcomponent = Calendar.current.dateComponents([.hour, .minute, .month, .year,.day, .second], from: date)
      
      let notification = LocalNotificationManager.LocalNotification(id: UUID().uuidString, title: "\(Constants.blockedMessgae)  \(domain)", datetime: newcomponent)
      manager.notifications.append(notification)
      manager.schedule()
    }
    func removeNotification(){
         self.manager.clearAllNotification()
    }
}



