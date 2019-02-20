//
//  LoginViewController.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 20/02/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import Firebase
import UIKit


class LoginViewController: UIViewController {

    var coreDataStack: CoreDataStack!
    let loginView = LoginView()
    var loginButton: UIButton!
    var registerButton: UIButton!
    var resetButton: UIButton!
   

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(loginView)
        loginView.fillSuperview()
        setupButtons()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            let vc = MainViewController()
            vc.userName = Auth.auth().currentUser?.displayName
            vc.coreDataStack = coreDataStack
            let nc = UINavigationController(rootViewController: vc)
            present(nc, animated: false, completion: nil)
        }
    }

    func setupButtons() {
        loginButton = loginView.loginButton
        registerButton = loginView.registerButton
        resetButton = loginView.resetButton
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
        loginButton.addTarget(self, action: #selector(handeleLoginButton), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(handleRegisterButton), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(handleResetButton), for: .touchUpInside)
    }

    @objc func handeleLoginButton() {
        guard let email = loginView.emailTextField.text,
        let password = loginView.passwordTextField.text
        else { return }

        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if error == nil && user != nil {
                self.loginView.emailTextField.text = nil
                self.loginView.passwordTextField.text = nil
                let vc = MainViewController()
                vc.userName = Auth.auth().currentUser?.displayName
                vc.coreDataStack = self.coreDataStack
                let nc = UINavigationController(rootViewController: vc)
                self.present(nc, animated: true)

            } else {
                self.handleFirebaseError(error: error!)
            }
        }
    }

    func handleFirebaseError(error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            switch (errorCode) {

            case .invalidEmail:

                loginView.errorLabel.text = "Email is not correct"
            case .missingEmail:
                loginView.errorLabel.text = "Email missing"
            case .wrongPassword:
                 loginView.errorLabel.text = "Wrong Password"
            case .networkError:
                loginView.errorLabel.text = "Check your internet conection"
            case .nullUser:
                loginView.errorLabel.text = "User not found"
            default:
                break
            }
        }
    }

    @objc func handleRegisterButton() {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func handleResetButton() {
        let vc = ResetPasswordViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
