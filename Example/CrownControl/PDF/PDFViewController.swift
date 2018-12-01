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
    private var crownControl: CrownControl!

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
        var attributes = CrownAttributes(scrollView: webView.scrollView, scrollAxis: .vertical)
        attributes.foregroundStyle.content = .color(color: .white)
        
        // Cling the bottom of the crown to the bottom of the web view with -35 offset
        let verticalConstraint = CrownAttributes.AxisConstraint(crownEdge: .bottom, anchorView: webView, anchorViewEdge: .bottom, offset: -35)
        
        // Cling the bottom of the crown to the bottom of its superview with -50 offset
        let horizontalConstraint = CrownAttributes.AxisConstraint(crownEdge: .trailing, anchorView: view, anchorViewEdge: .trailing, offset: -50)
        
        // Setup the crown control within *self*
        crownControl = CrownControl(attributes: attributes)
        crownControl.layout(in: self, horizontalConstaint: horizontalConstraint, verticalConstraint: verticalConstraint)
    }
}

// MARK: - UIScrollViewDelegate

extension PDFViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        crownControl?.spinToMatchScrollViewOffset()
    }
}
