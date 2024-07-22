//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Sergei Volotka on 04.06.2024.


import UIKit

final class SingleImageViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    
    // MARK: - Public Properties
    var image: URL? {
        didSet {
            guard isViewLoaded else { return }
            setImage()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setImage()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
       // scrollView.maximumZoomScale = 3
    }
    
    // MARK: - IB Actions
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
        guard let image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func setImage() {
        guard let image = image else { return }
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with:image, placeholder: UIImage(named: "placeholder_image")) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure(let error):
                print("[setImage]: SingleImageViewController - \(error) ")
                showError()
            }
        
        }
        guard let image = imageView.image else { return }
        self.rescaleAndCenterImageInScrollView(image: image)
    }
    
    private func showError() {
        let alert = UIAlertController(
            title: "Что-то пошло не так. Попробовать ещё раз?",
            message: nil,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "Не надо",
            style: .default,
            handler: nil))
        alert.addAction(UIAlertAction(
            title: "Повторить",
            style: .default,
            handler: {action in
            self.setImage()
        }))
        self.present(alert, animated: true)
    }
}

// MARK: - Extensions
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let x = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let y = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        scrollView.contentInset = UIEdgeInsets(top: y, left: x, bottom: 0, right: 0)
    }
}
