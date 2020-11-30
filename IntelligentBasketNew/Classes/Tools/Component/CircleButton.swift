//
//  CircleButton.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/22.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

private let kImageViewWH: CGFloat = 45

class CircleButton: UIView {
    
    var text = ""
    var image = ""

    private lazy var imageView: UIImageView = { [weak self] in
        let imageView = CommonViewFactory.createImageView(image: image)
        imageView.layer.cornerRadius = kImageViewWH / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var textLabel: UILabel = { [weak self] in
        let label = UILabel()
        label.text = self!.text
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.darkGray
        return label
    }()
        
    init(frame: CGRect, text: String, image: String) {
        super.init(frame: frame)
        self.text = text
        self.image = image
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CircleButton {
    private func setUI() {
        addSubview(imageView)
        addSubview(textLabel)
        imageView.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
            make.width.height.equalTo(kImageViewWH)
        }
        textLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom).offset(6)
        }
    }
}
