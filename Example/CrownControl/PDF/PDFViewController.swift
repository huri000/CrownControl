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
        attributes.foregroundStyle.content = .color(color: .white)
        crownViewController = CrownIndicatorViewController(with: attributes)
        
        // Cling the bottom of the crown to the bottom of the web view with -35 offset
        let verticalConstraint = CrownAxisConstraint(crownEdge: .bottom, anchorView: webView, anchorViewEdge: .bottom, offset: -35)
        
        // Cling the bottom of the crown to the bottom of its superview with -50 offset
        let horizontalConstraint = CrownAxisConstraint(crownEdge: .trailing, anchorView: view, anchorViewEdge: .trailing, offset: -50)
        
        crownViewController.layout(in: self, horizontalConstaint: horizontalConstraint, verticalConstraint: verticalConstraint)
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
