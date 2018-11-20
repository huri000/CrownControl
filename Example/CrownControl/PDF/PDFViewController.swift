//
//  PDFViewController.swift
//  CrownControlDemo
//
//  Created by Daniel Huri on 11/16/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import UIKit
import QuickLayout
import WebKit
import CrownControl

class PDFViewController: UIViewController {

    // MARK: - Properties
    
    private var webView: WKWebView!
    private var crownViewController: CrownViewController!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        setupCrownViewController()
    }
    
    // MARK: - Setup
    
    private func setupWebView() {
        webView = WKWebView(frame: view.bounds)
        view.addSubview(webView)
        webView.fillSuperview()
        webView.scrollView.delegate = self
        let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "sample", ofType: "pdf")!)
        webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
    }
    
    private func setupCrownViewController() {
        let attributes = CrownAttributes(using: webView.scrollView)
        attributes.forgroundStyle.content = .color(color: .white)
        crownViewController = CrownIndicatorViewController(with: attributes)
        addChild(crownViewController)
        view.addSubview(crownViewController.view)
        crownViewController.layoutVertically(.bottom, to: .bottom, of: webView, offset: -35)
        crownViewController.layoutHorizontally(.trailing, to: .trailing, of: view, offset: -50)
    }
}

// MARK: - CrownDelegate

extension PDFViewController: CrownDelegate {}

// MARK: - UIScrollViewDelegate

extension PDFViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y / (scrollView.contentSize.height - scrollView.bounds.height)
        crownViewController?.spin(to: offsetY)
    }
}
