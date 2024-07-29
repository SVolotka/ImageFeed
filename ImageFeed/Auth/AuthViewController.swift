//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Sergei Volotka on 17.06.2024.

import UIKit
import ProgressHUD

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

final class AuthViewController: UIViewController {
    
    // MARK: - Public Properties
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - Private Properties
    private let showWebViewSegueIdentifier = "ShowWebView"
    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(showWebViewSegueIdentifier)") }
            let authHelper = AuthHelper()
            let webViewPresenter = WebViewPresenter(authHelper: authHelper)
            webViewViewController.presenter = webViewPresenter
            webViewPresenter.view = webViewViewController
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private Methods
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black")
    }
}

// MARK: - Extensions
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        navigationController?.popViewController(animated: true)
        
        UIBlockingProgressHUD.show()
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success(let accessToken):
                self.oauth2TokenStorage.token = accessToken
                self.delegate?.didAuthenticate(self)
            case .failure(let error):
                print(error)
                let alertPresenter = AlertPresenter(delegate: self)
                alertPresenter.showAlert(
                    title: "Что-то пошло не так(",
                    message: "Не удалось войти в систему",
                    buttonTitle: "Ok")
                break
            }
        }
    }
}
