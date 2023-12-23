//
//  LoginController.swift
//  FlashChat
//
//  Created by macbook on 18.12.2023.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

final class LoginViewController: UIViewController {
    private let email = UITextField()
    private let password = UITextField()
    private let button = UIButton()
    
    private let emailImageView = UIImageView(image: UIImage(named: "textfield")!)
    private let passwordImageView = UIImageView(image: UIImage(named: "textfield")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConst()
        targets()
    }
    
    private func targets() {
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    private func setupView() {
        view.addSubviews(emailImageView, passwordImageView, button)
        emailImageView.addSubviews(email)
        passwordImageView.addSubviews(password)
        email.placeholder = "Enter your email"
        email.text = "yakovenko06122002@icloud.com"
        password.text = "Nikita06122002Y"
        password.placeholder = "Enter your password"
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        view.backgroundColor = UIColor(named: "BrandBlue")
        emailImageView.isUserInteractionEnabled = true
        passwordImageView.isUserInteractionEnabled = true
        
    }
    
    private func setupConst() {
        NSLayoutConstraint.activate([
            emailImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            emailImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            passwordImageView.topAnchor.constraint(equalTo: emailImageView.bottomAnchor, constant: -20),
            passwordImageView.leadingAnchor.constraint(equalTo: emailImageView.leadingAnchor),
            
            email.centerXAnchor.constraint(equalTo: emailImageView.centerXAnchor),
            email.topAnchor.constraint(equalTo: emailImageView.topAnchor, constant: emailImageView.bounds.height / 4),
            email.bottomAnchor.constraint(lessThanOrEqualTo: emailImageView.bottomAnchor),
            
            password.centerXAnchor.constraint(equalTo: passwordImageView.centerXAnchor),
            password.topAnchor.constraint(equalTo: passwordImageView.topAnchor, constant: emailImageView.bounds.height / 4),
            password.bottomAnchor.constraint(lessThanOrEqualTo: passwordImageView.bottomAnchor),
            
            button.topAnchor.constraint(equalTo: passwordImageView.bottomAnchor, constant: 10),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
    }
    
    @objc func buttonAction() {
        if let email = email.text, let password = password.text {
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let e = error {
                    let alert = UIAlertController(title: "Внимание", message: "\(e.localizedDescription)", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                } else {
                    let vc = ChatController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
