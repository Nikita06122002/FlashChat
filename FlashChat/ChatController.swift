//
//  ChatController.swift
//  FlashChat
//
//  Created by macbook on 18.12.2023.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import IQKeyboardManagerSwift

final class ChatController: UIViewController {
    
    private let textField = UITextField()
    private let button = UIButton()
    private let tableView = UITableView()
    private let db = Firestore.firestore()
    private var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMessages()
        setupView()
        setupConst()
        tableView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .done, target: self, action: #selector(buttonAction))
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableViewCell.identifier)
        
    }
    //MARK: - Загрузка сообщений из firebase
    private func loadMessages() {
        print("LoadMessages")
        
        db.collection(K.FStore.collectionName)//получение определенной коллекции
            .order(by: K.FStore.dateField)//сортировака коллекции по датам
            .addSnapshotListener { (querySnapshot, error) in//снэпшот(снимок данных)
                
                self.messages = []//обнуляем массив моделей
                
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {//получаем массив данных снепшота
                        for doc in snapshotDocuments {//Разбиваем на отдельные модели
                            let data = doc.data()//получаем словарь [String:Any]
                            //получаем отправителя и сообщение и кастим к строке
                            if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                                //из полученных данных собираем модель
                                let newMessage = Message(sender: messageSender, body: messageBody)
                                //добавляем модель в массив
                                self.messages.append(newMessage)
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    
                                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                }
                            }
                        }
                    }
                }
            }
    }
    
    private func setupView() {
        view.backgroundColor = .systemGray5
        textField.placeholder = "Enter your message"
        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.tintColor = .white
        tableView.backgroundColor = .white
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 5
        navigationItem.hidesBackButton = true
        title = "⚡️FlashChat"
        tableView.separatorStyle = .none
        view.addSubviews(textField, button, tableView)
    }
    
    private func setupConst() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            
            textField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -20),
            textField.heightAnchor.constraint(equalToConstant: 34),
            
            button.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            button.centerYAnchor.constraint(equalTo: textField.centerYAnchor)
            
        ])
    }
    
    @objc private func buttonAction() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    @objc private func sendMessage() {
        //проверяем что есть текст и отправиьель
        if let messageBody = textField.text, let messageSender = Auth.auth().currentUser?.email {
            //делаем коллекцию и добавляем в нее модель
            db.collection(K.FStore.collectionName).addDocument(data: [
                //Добавляем в коллекцию отправителя
                K.FStore.senderField: messageSender,
                //Добавляем в коллекцию сообщение
                K.FStore.bodyField: messageBody,
                //Добавляем в коллекцию дату сообщения
                K.FStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print("There was an issue saving data to firestore, \(e)")
                } else {
                    print("Successfully saved data.")
                    
                    DispatchQueue.main.async {
                        //Очищаем текстфилд после отправки
                        self.textField.text = ""
                    }
                }
            }
        }
    }
}



extension ChatController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.identifier, for: indexPath) as? MessageTableViewCell else { return UITableViewCell() }
        let message = messages[indexPath.row]
        if message.sender == Auth.auth().currentUser?.email {
            cell.config(with: message.body)
            cell.viewBackgroundColor(color: .purple)
            cell.textColor(color: UIColor(named: "BrandLightPurple")!)
            cell.hideYou(bool: true)
            cell.hideMe(bool: false)
        } else {
            cell.config(with: message.body)
            cell.viewBackgroundColor(color: UIColor(named: "BrandLightPurple")!)
            cell.textColor(color: .black)
            cell.hideMe(bool: true)
            cell.hideYou(bool: false)
        }
        return cell
    }
    
    
    
    
    
}



//MARK: - SwiftUI
import SwiftUI
struct Provider_ChatController : PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainterView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            return ChatController()
        }
        
        typealias UIViewControllerType = UIViewController
        
        
        let viewController = ChatController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<Provider_ChatController.ContainterView>) -> ChatController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: Provider_ChatController.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<Provider_ChatController.ContainterView>) {
            
        }
    }
    
}
