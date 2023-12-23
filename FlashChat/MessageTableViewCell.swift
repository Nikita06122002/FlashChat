//
//  MessageTableViewCell.swift
//  FlashChat
//
//  Created by macbook on 19.12.2023.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    private let containerView = UIView()
    private let messageLabel = UILabel()
    private let image = UIImageView()
    private let youImage = UIImageView()
    private let stackView = UIStackView()
    var bool: Bool?
    
    static let identifier = "message"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.isUserInteractionEnabled = false
        // Настройка внутреннего вида контейнера
        containerView.backgroundColor = .purple
        containerView.addSubview(messageLabel)
        
        // Настройка label
        messageLabel.textColor = UIColor(named: "BrandLightBlue")
        messageLabel.font = .systemFont(ofSize: 18)
        messageLabel.text = "Label"
        messageLabel.numberOfLines = 0
        
        // Настройка imageView
        image.image = UIImage(named: "MeAvatar")
        image.contentMode = .scaleAspectFit
        
        youImage.image = UIImage(named: "YouAvatar")
        youImage.contentMode = .scaleAspectFit
        
        // Настройка stackView
        stackView.addArrangedSubview(youImage)
        stackView.addArrangedSubview(containerView)
        stackView.addArrangedSubview(image)
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .top
        stackView.distribution = .fill
        containerView.layer.cornerRadius = 10
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        youImage.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Ограничения для stackView
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Ограничения для imageView
            image.widthAnchor.constraint(equalToConstant: 50),
            image.heightAnchor.constraint(equalToConstant: 50),
            
            youImage.widthAnchor.constraint(equalToConstant: 50),
            youImage.heightAnchor.constraint(equalToConstant: 50),
            
            // Ограничения для messageLabel
            messageLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)
        ])
    }
    func config(with model: String) {
        messageLabel.text = model
    }

    func hideYou(bool: Bool) {
        youImage.isHidden = bool
    }
    func hideMe(bool: Bool) {
        image.isHidden = bool
    }
    func viewBackgroundColor(color: UIColor) {
        containerView.backgroundColor = color
    }
    func textColor(color: UIColor) {
        messageLabel.textColor = color
    }
    
}
