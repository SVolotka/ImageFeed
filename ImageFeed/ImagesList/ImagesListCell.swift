
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
        (cellImage.kf.indicator?.view as? UIActivityIndicatorView)?.color = .ypBlack
        cellImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder_image"))
        dateLabel.text = photo.createdAt
        
        let isLiked = photo.isLiked
        setIsLiked(isLiked)
    }
    
    func setIsLiked(_ isLiked: Bool ) {
        if isLiked {
            likeButton.setImage(UIImage(named: "like_button_on"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "like_button_off"), for: .normal)
        }
    }
}
