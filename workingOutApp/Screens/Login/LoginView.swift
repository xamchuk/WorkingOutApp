//
//  LoginView.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 20/02/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

class LoginView: UIView {

    let emailTextField = LoginTextField()
    let passwordTextField = LoginTextField()
    let loginButton = LoginButton()
    let registerButton = LoginButton()
    let resetButton = UIButton(type: .system)
    let errorLabel = ErrorLabel()


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupSubviews() {
        setBackgroudView()
       
        emailTextField.placeholderString = "Email"
        passwordTextField.placeholderString = "Password"
        passwordTextField.isSecureTextEntry = true
        loginButton.attributedTitle = "Login"
        registerButton.attributedTitle = "Sign Up"
        setupForgotPasswordButton()

        let stackView = setupStackView()
        addSubview(stackView)
        stackView.centerInSuperview()
        stackView.widthAnchor.constraint(equalTo: widthAnchor, constant: -60).isActive = true
    }

    func setupForgotPasswordButton() {
        resetButton.setTitle("Forrgot Password?", for: .normal)
        resetButton.setTitleColor(.white, for: .normal)
    }

    func setupStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [errorLabel, emailTextField, passwordTextField, loginButton, registerButton,resetButton])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }
}
