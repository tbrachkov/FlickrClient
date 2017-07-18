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

    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.contentMode = .scaleAspectFill
    }

    func configureCell(_ photoLink: String) {
        self.imageView.sd_setImage(with: URL(string: photoLink), placeholderImage: UIImage(named: "placeholder.png"))
    }
}
