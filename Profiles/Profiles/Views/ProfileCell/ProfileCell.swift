//
//  ProfileCell.swift
//  Profiles
//
//  Created by Егор Шкарин on 01.07.2022.
//

import UIKit

final class ProfileCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
    }
    func configure(with imageUrl: URL?, name: String) {
        nameLabel.text = name
        imageView.setImage(url: imageUrl)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
