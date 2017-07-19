//
//  PhotoCollectionViewCell.swift
//  FlickrClient
//
//  Created by Todor Brachkov on 18/07/2017.
//  Copyright © 2017 Todor Brachkov. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomContainerView: UIView!
    var storedImage: UIImage?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.contentMode = .scaleAspectFill
    }

    func configureCell(_ photoLink: String, name: String) {
        self.nameLabel.text = name
        self.bottomContainerView.bringSubview(toFront: nameLabel)
        self.imageView.sd_setImage(with: URL(string: photoLink), placeholderImage: UIImage(named: "placeholder.png"), options: []) { [weak self] (image, _, _, _) in
                self?.storedImage = image
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.sd_cancelCurrentImageLoad()
    }
}
