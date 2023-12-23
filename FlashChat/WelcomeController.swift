//
//  WelcomeController.swift
//  FlashChat
//
//  Created by macbook on 18.12.2023.
//

import UIKit


final class WelcomeController: UIViewController {
    
    private let label = UILabel()
    private let loginButton = UIButton()
    private let regButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConst()
        targets()
        animateLabel()
        view.backgroundColor = .white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    private func animateLabel() {
        let text = "⚡️FlashChat"
        var charIndex = 0.0
        for letter in text {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 * charIndex) {
                self.label.text?.append(letter)
            }
            charIndex += 1
        }
    }
    
    private func targets() {
        loginButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        regButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }
    
    private func setupView() {
        label.text = ""
        label.font = .systemFont(ofSize: 50, weight: .black)
        label.textColor = .systemTeal
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .systemTeal
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 25)
        loginButton.layer.cornerRadius = 10
        
        
        
        regButton.setTitle("Register", for: .normal)
        regButton.backgroundColor = UIColor(named: "BrandLightBlue")
        regButton.setTitleColor(.systemTeal, for: .normal)
        regButton.titleLabel?.font = .systemFont(ofSize: 25)
        regButton.layer.cornerRadius = 10
        view.addSubviews(label, loginButton, regButton)
    }
    
    private func setupConst() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            loginButton.heightAnchor.constraint(equalToConstant: 40),
            
            regButton.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -20),
            regButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            regButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            regButton.heightAnchor.constraint(equalToConstant: 40)
            
        ])
    }
    
    
    @objc private func buttonAction(_ sender: UIButton) {
        if sender.currentTitle == "Login" {
            print("Login")
            let vc = LoginViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = RegisterViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


//MARK: - SwiftUI
import SwiftUI
struct Provider_WelcomeController : PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainterView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            return WelcomeController()
        }
        
        typealias UIViewControllerType = UIViewController
        
        
        let viewController = WelcomeController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<Provider_WelcomeController.ContainterView>) -> WelcomeController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: Provider_WelcomeController.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<Provider_WelcomeController.ContainterView>) {
            
        }
    }
    
}
