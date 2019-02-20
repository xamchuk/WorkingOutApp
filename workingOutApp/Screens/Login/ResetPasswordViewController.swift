//
//  ResetPasswordViewController.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 20/02/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//
import Firebase
import UIKit

class ResetPasswordViewController: UIViewController {

    let emailTextField = LoginTextField()
    let resetButton = LoginButton()
    let errorLabel = ErrorLabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.tintColor = .white
        setupSubview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    func setupSubview() {
        view.setBackgroudView()
        emailTextField.placeholderString = "Email"
        emailTextField.delegate = self
        resetButton.setTitle("Reset", for: .normal)
        resetButton.addTarget(self, action: #selector(handleResetButton), for: .touchUpInside)
        let stackView = setupStackView()
        view.addSubview(stackView)
        stackView.centerInSuperview()
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60).isActive = true
    }

    func setupStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [errorLabel, emailTextField, resetButton])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }

    @objc func handleResetButton() {
        guard let email = emailTextField.text else { return }
        Auth.auth().sendPasswordReset(withEmail: email) { error in 
            if error != nil {
                self.handleFirebaseError(error: error!)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }

    }

    func handleFirebaseError(error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            switch (errorCode) {

            case .missingEmail:
                errorLabel.text = "missing Email"
            case .userNotFound:
                errorLabel.text = "User not found with this Email"
            default:
                break
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
    }
}

extension ResetPasswordViewController: UITextFieldDelegate {
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
    }
}
