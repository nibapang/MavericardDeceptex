//
//  PrivacyVC.swift
//  MavericardDeceptex
//
//  Created by Mavericard Deceptex on 2025/3/8.
//

import UIKit
import Adjust
import WebKit

class MavericardPrivacyController: UIViewController , WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler{

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var indcatorView: UIActivityIndicatorView!
    @objc var urlStr: String?
    let ads: [String] = UserDefaults.standard.object(forKey: "ADSdatas") as? [String] ?? []
    
    //MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mavericardInitUI()
        configureMavericardWebView()
        loadRequest()
    }
    
    //MARK: - Functions
    private func mavericardInitUI() {
        backBtn.isHidden = (urlStr != nil)
        indcatorView.hidesWhenStopped = true
        view.backgroundColor = .black
    }
    
    private func configureMavericardWebView() {
        webView.backgroundColor = .black
        webView.scrollView.backgroundColor = .black
        webView.isOpaque = false
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        if ads.count > 3 {
            let userContentController = webView.configuration.userContentController
            let trackScript = WKUserScript(source: ads[1],
                                           injectionTime: .atDocumentStart,
                                           forMainFrameOnly: false)
            userContentController.addUserScript(trackScript)
            userContentController.add(self, name: ads[2])
            userContentController.add(self, name: ads[3])
        }
    }
    
    private func loadRequest() {
        indcatorView.startAnimating()
        guard let urlString = urlStr, let url = URL(string: urlString) else {
            if let emptyURL = URL(string: "https://www.termsfeed.com/live/2f1e492b-f40d-4bf3-b890-aa05a70e6e85") {
                webView.load(URLRequest(url: emptyURL))
            }
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    //MARK: - Declare IBAction
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopIndicator()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        stopIndicator()
    }
    
    private func stopIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.indcatorView.stopAnimating()
        }
    }
    
    // MARK: - WKUIDelegate
    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil, let url = navigationAction.request.url {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        return nil
    }
    
    // MARK: - WKScriptMessageHandler
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        guard ads.count >= 4 else { return }
        
        if message.name == ads[2],
           let data = message.body as? String,
           let url = URL(string: data) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else if message.name == ads[3],
                  let data = message.body as? [String: Any],
                  let evTok = data["eventToken"] as? String,
                  !evTok.isEmpty {
            print("eventToken：\(evTok)")
            Adjust.trackEvent(ADJEvent(eventToken: evTok))
        }
    }
    
}
