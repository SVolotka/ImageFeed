
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Sergei Volotka on 03.06.2024.

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    // MARK: - IB Outlets
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
   // likeButton.accessibilityIdentifier = "likeButton"
    
    // MARK: - Public Properties
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    @IBAction private func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    // MARK: - Public Methods
    func configCell(with photo: Photo) {
        guard let url = URL(string: photo.thumbImageURL) else { return }
        cellImage.kf.indicatorType = .activity
        let view = cellImage.kf.indicator?.view as? UIActivityIndicatorView
        view?.color = .ypBlack
        cellImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder_image"))
        dateLabel.text = photo.createdAt
        
        let isLiked = photo.isLiked
        setIsLiked(isLiked)
    }
    
    func setIsLiked(_ isLiked: Bool ) {
        let imageName = isLiked ? "like_button_on" : "like_button_off"
        likeButton.setImage(UIImage(named: imageName), for: .normal)
    }
}
