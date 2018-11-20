//
//  PhotoCollectionViewCell.swift
//  CrownControlDemo
//
//  Created by Daniel Huri on 11/16/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import UIKit


class PhotoCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    var imageData: PhotoData! {
        didSet {
            let fileName = imageData.fileName
            DispatchQueue.global(qos: .userInitiated).async {
                let image = self.imageData.image
                DispatchQueue.main.async {
                    guard fileName == self.imageData.fileName else {
                        return
                    }
                    self.descriptionLabel.text = self.imageData.description
                    self.imageView.image = image
                }
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = true
        layer.cornerRadius = 20
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        descriptionLabel.text = nil
        imageView.image = nil
    }
}
