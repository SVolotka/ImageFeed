
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Sergei Volotka on 04.06.2024.

import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject {
    func updateAvatar()
    func updateProfileDetails(profile: Profile?)
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    // MARK: - IBOutlets
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var logoutButton: UIButton!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var loginNameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    
    // MARK: - Private Properties
    lazy var presenter: ProfilePresenterProtocol = ProfilePresenter(view: self)
    private let avatarImage = UIImage(named: "avatarImage")
   // private var profileImageServiceObserver: NSObjectProtocol?
    private let logoutService = ProfileLogoutService.shared
    private let splashViewController = SplashViewController()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        loadProfileViewController()
        presenter.viewDidLoad()
    }
    
    // MARK: - Private functions
    
    func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else {
            return
        }
        avatarImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder_avatar"))
    }
    
    func updateProfileDetails(profile: Profile?) {
        logoutButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        
        nameLabel.text = profile?.name
        loginNameLabel.text = profile?.loginName
        descriptionLabel.text = profile?.bio
    }
    
    private func loadProfileViewController() {
        loadAvatarImageView()
        loadNameLabel()
        loadLoginNameLabel()
        loadLogoutButton()
        loadDescriptionLabel()
    }
    
    private func loadAvatarImageView() {
        avatarImageView = UIImageView(image: avatarImage)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        avatarImageView.layer.cornerRadius = 35
        avatarImageView.clipsToBounds = true
        avatarImageView.tintColor = .gray
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
    }
    
    private func loadNameLabel() {
        nameLabel = UILabel()
        nameLabel.text = ""
        nameLabel.textColor = .white
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor)
        ])
    }
    
    private func loadLoginNameLabel() {
        loginNameLabel = UILabel()
        loginNameLabel.text = ""
        loginNameLabel.textColor = .gray
        loginNameLabel.font = UIFont.systemFont(ofSize: 13)
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        NSLayoutConstraint.activate([
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor)
        ])
    }
    
    private func loadDescriptionLabel() {
        descriptionLabel = UILabel()
        descriptionLabel.text = ""
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor)
        ])
    }
    
    private func loadLogoutButton() {
        let logoutButtonImage = UIImage(named: "logout_button") ?? UIImage()
        logoutButton = UIButton.systemButton(with: logoutButtonImage, target: self, action: #selector(Self.didTapLogoutButton))
        logoutButton.tintColor = .red
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        logoutButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        NSLayoutConstraint.activate([
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private func showLogoutAlert() {
        let alertPresenter = AlertPresenter(delegate: self)
        let actionYes = UIAlertAction(title: "Да", style: .default) { _ in
            self.presenter.logout()
        }
        let actionNo = UIAlertAction(title: "Нет", style: .default)
        alertPresenter.showLogoutAlert(title: "Пока, пока!",
                                       message: "Уверены, что хотите выйти?",
                                       actionYes: actionYes, actionNo: actionNo)
    }
    
    @objc
    private func didTapLogoutButton() {
        showLogoutAlert()
    }
}
