//
//  PhotoCollectionViewController.swift
//  CrownControlDemo
//
//  Created by Daniel Huri on 11/16/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import UIKit
import CrownControl

class PhotoCollectionViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var crownViewController: CrownViewController!

    private var dataSource: [PhotoData] = []
    
    private let photoScreenWidthRelation: CGFloat = 0.85
    private var photoScreenEdgeInset: CGFloat {
        return (1.0 - photoScreenWidthRelation) * 0.5
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadData()
        setupCrownViewController()
    }
    
    // MARK: - Setup
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: PhotoCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: PhotoCollectionViewCell.className)
    }
    
    private func setupCrownViewController() {
        let attributes = CrownAttributes(using: collectionView)
        attributes.sizes.backgroundSurfaceDiameter = 70
        attributes.anchorPosition = .top
        let color1 = UIColor(rgb: 0xffb347)
        let color2 = UIColor(rgb: 0xffcc33)
        attributes.backgroundStyle.content = .color(color: UIColor(white: 0.98, alpha: 1))
        attributes.foregroundStyle.content = .gradient(gradient: .init(colors: [color1, color2], startPoint: .zero, endPoint: .init(x: 1, y: 1)))
        attributes.foregroundStyle.border = .none
        attributes.foregroundStyle.shadow = .none
        attributes.sizes.scrollRelation = CGFloat(dataSource.count) * 0.5
        attributes.scrollAxis = .horizontal
        
        crownViewController = CrownIndicatorViewController(with: attributes, delegate: self)
        
        // Cling the bottom of the crown to the bottom of the web view with -35 offset
        let verticalConstraint = CrownAttributes.AxisConstraint(crownEdge: .bottom, anchorView: view, anchorViewEdge: .bottom, offset: -70)
        
        // Cling the bottom of the crown to the bottom of its superview with -50 offset
        let horizontalConstraint = CrownAttributes.AxisConstraint(crownEdge: .centerX, anchorView: view, anchorViewEdge: .centerX)
        
        crownViewController.layout(in: self, horizontalConstaint: horizontalConstraint, verticalConstraint: verticalConstraint)
    }
    
    private func loadData() {
        dataSource += (1...13).map { PhotoData(fileName: "collection-photo-\($0).jpg", description: "Image \($0)") }
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension PhotoCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.className, for: indexPath) as! PhotoCollectionViewCell
        cell.imageData = dataSource[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.minEdge * photoScreenWidthRelation, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return view.bounds.minEdge * photoScreenEdgeInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let minEdge = view.bounds.minEdge
        return UIEdgeInsets(top: 0, left: minEdge * photoScreenEdgeInset, bottom: 0, right: minEdge * photoScreenEdgeInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let xOffset = collectionView.contentOffset.x / (collectionView.contentSize.width - collectionView.bounds.width)
        crownViewController?.spin(to: xOffset)
    }
}

// MARK: - CrownDelegate

extension PhotoCollectionViewController: CrownDelegate {}
