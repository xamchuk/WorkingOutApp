//
//  RegisterViewController.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 20/02/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import Firebase
import UIKit

class RegisterViewController: UIViewController {

    let usernameTextField = LoginTextField()
    let emailTextField = LoginTextField()
    let passwordTextField = LoginTextField()
    let registerButton = LoginButton()
    let errorLabel = ErrorLabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.tintColor = .white
        setupViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    @objc func handleRegisterButton() {
        guard let username = usernameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text
            else { return }

        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error == nil && user != nil {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = username
                changeRequest?.commitChanges { error in
                    if error == nil {
                        self.navigationController?.popViewController(animated: false)
                    } else {
                        print("Error: \(error!.localizedDescription)")
                    }
                }
            } else {
                self.handleFirebaseError(error: error!)
            }
        }
    }

    func handleFirebaseError(error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            switch (errorCode) {
            case .emailAlreadyInUse:
                errorLabel.text = "Email already signed up, go to login page"
            default:
                break
            }
        }
    }

    func setupViews() {
        view.setBackgroudView()
        usernameTextField.placeholderString = "User Name"
        emailTextField.placeholderString = "Email"
        passwordTextField.placeholderString = "Password"
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        registerButton.attributedTitle = "Sign Up"
        registerButton.addTarget(self, action: #selector(handleRegisterButton), for: .touchUpInside)
        let stackView = setupStackView()
        view.addSubview(stackView)
        stackView.centerInSuperview()
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60).isActive = true
    }

    func setupStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [errorLabel, usernameTextField, emailTextField, passwordTextField, registerButton])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
}

    extension RegisterViewController: UITextFieldDelegate {
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
}
