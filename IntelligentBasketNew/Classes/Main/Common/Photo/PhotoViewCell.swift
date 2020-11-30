//
//  PhotoViewCell.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/27.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

class PhotoViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    var image: String? {
        didSet {
            self.imageView.image = nil
            imageView.image = UIImage(named: image!)
            imageView.contentMode = .scaleAspectFill
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        autoresizingMask = []
        contentView.backgroundColor = UIColor.white
    }

}
