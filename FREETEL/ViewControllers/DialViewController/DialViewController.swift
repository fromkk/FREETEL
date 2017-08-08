//
//  DialViewController.swift
//  FREETEL
//
//  Created by Kazuya Ueoka on 2017/08/08.
//  Copyright © 2017 fromKK. All rights reserved.
//

import UIKit

class DialViewController: UIViewController {
    
    private var buttonSize: CGFloat = (320.0 - (8.0 * 4.0)) / 3.0
    
    lazy var phoneNumberLabel: UILabel = { () -> UILabel in
        let label: UILabel = UILabel()
        label.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 48.0)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.3
        label.textAlignment = .center
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "*", "0", "#"]
    
    lazy var buttons: [UIButton] = self.numbers.map({ self.createButton(with: $0) })
    
    lazy var callButton: UIButton = { () -> UIButton in
        let button: UIButton = UIButton(type: .custom)
        button.setTitle("Call", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(DialViewController.handle(callButton:)), for: .touchUpInside)
        return button
    }()
    
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(self.phoneNumberLabel)
        self.layoutPhoneNumberLabel()
        
        self.buttons.enumerated().forEach { (args) in
            let offset = args.offset
            let button = args.element
            
            self.view.addSubview(button)
            self.layoutButton(with: offset, button: button)
        }
        
        self.view.addSubview(self.callButton)
        self.layoutCallButton()
    }
}

// MARK: - phoneNumberLabel
extension DialViewController {
    private func layoutPhoneNumberLabel() {
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.phoneNumberLabel, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: -32.0).priority(.defaultHigh),
            NSLayoutConstraint(item: self.phoneNumberLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 64.0),
            NSLayoutConstraint(item: self.phoneNumberLabel, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1.0, constant: 8.0),
            NSLayoutConstraint(item: self.phoneNumberLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
            ])
    }
}

// MARK: - number buttons
extension DialViewController {
    @objc private func handle(button: UIButton) {
        guard let index: Int = self.buttons.index(of: button) else {
            return
        }
        
        var text: String = self.phoneNumberLabel.text ?? ""
        text.append(self.numbers[index])
        self.phoneNumberLabel.text = text
    }
    
    private func createButton(with char: String) -> UIButton {
        let button: UIButton = UIButton(type: .custom)
        button.layer.borderColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        button.layer.borderWidth = 1.0
        button.layer.masksToBounds = true
        button.layer.cornerRadius = buttonSize / 2.0
        button.backgroundColor = .white
        button.setTitleColor(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 36.0)
        button.setTitle(char, for: .normal)
        button.addTarget(self, action: #selector(DialViewController.handle(button:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    private func layoutButton(with offset: Int, button: UIButton) {
        let cols = offset % 3
        let rows = offset / 3
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: buttonSize),
            NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: buttonSize),
            NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: CGFloat(cols + 1) * 0.5, constant: 0.0),
            NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: self.phoneNumberLabel, attribute: .bottom, multiplier: 1.0, constant: (buttonSize + 8.0) * CGFloat(rows))
            ])
    }
}

extension DialViewController {
    private func layoutCallButton() {
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.callButton, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.callButton, attribute: .bottom, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: -16.0),
            ])
    }
    
    @objc private func handle(callButton: UIButton) {
        guard let phoneNumber: String = self.phoneNumberLabel.text, !phoneNumber.isEmpty else { return }
        
        guard let url: URL = URL(string: "tel://\(Constants.prefix)\(phoneNumber)") else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
