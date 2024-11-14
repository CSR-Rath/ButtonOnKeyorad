//
//  ViewController.swift
//  ButtonOnKeyborad
//
//  Created by Rath! on 14/11/24.
//

import UIKit

class ViewController: UIViewController {
    
    private var nsConstraint = NSLayoutConstraint()
    
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "Please input"
        textField.backgroundColor = .lightGray
        textField.tintColor = .white
        return textField
    }()

    lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Touch Me", for: .normal)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(didTouchMe), for: .touchUpInside)
        return button
    }()
    
    @objc func didTouchMe(){
        textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        
        view.setupKeyboardObservers()
    
        
        UIView.actionKeyboardWillShow = { [self] height in
            nsConstraint.constant = -height-10
            view.layoutIfNeeded()
        }
        
        UIView.actionKeyboardWillHide = { [self] in
            nsConstraint.constant = -30
            view.layoutIfNeeded()
        }
        

    }
        deinit {
            NotificationCenter.default.removeObserver(self)
        }

    
    
    private func setupUI(){
        
        view.addSubview(textField)
        view.addSubview(button)
        
        nsConstraint =  button.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -30)
        nsConstraint.isActive = true
        
        NSLayoutConstraint.activate([
        
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -100),
            textField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.heightAnchor.constraint(equalToConstant: 50),
            
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        
        ])
        
    }

}


extension UIView{
    //    deinit {
    //        NotificationCenter.default.removeObserver(self)
    //    }
    
    static var actionKeyboardWillShow: ((_ keyboardHeight: CGFloat)->())?
    static var actionKeyboardWillHide: (()->())?
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let  keyboardHeight = keyboardFrame.cgRectValue.height
            
            print("keyboardHeight ==> ",keyboardHeight)
            
            UIView.actionKeyboardWillShow?(keyboardHeight)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.actionKeyboardWillHide?()
    }
}
