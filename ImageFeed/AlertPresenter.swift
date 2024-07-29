//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Sergei Volotka on 09.07.2024.
//

import UIKit

final class AlertPresenter {
    
    weak var delegate: UIViewController?
    
    init(delegate: UIViewController?) {
        self.delegate = delegate
    }
    
    func showAlert(title: String?, message: String?, buttonTitle: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default)
        alert.addAction(action)
        delegate?.present(alert, animated: true)
    }
    
    func showLogoutAlert(title: String?, message: String?,
                         actionYes: UIAlertAction,
                         actionNo: UIAlertAction) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(actionYes)
        alert.addAction(actionNo)
        alert.view.accessibilityIdentifier = "logoutAlert"
        delegate?.present(alert, animated: true)
    }
}
