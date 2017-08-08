//
//  HistoryViewController.swift
//  FREETEL
//
//  Created by Kazuya Ueoka on 2017/08/05.
//  Copyright © 2017 fromKK. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import Contacts
import ContactsUI

class HistoryViewController: UIViewController {
    
    lazy var callButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(HistoryViewController.handle(callButton:)))
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(Cell.self, forCellReuseIdentifier: Cell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var token: NotificationToken?
    
    lazy var histories: Results<History> = {
        let histories = try! Realm().objects(History.self).sorted(byKeyPath: "createdAt", ascending: false)
        self.token = histories.addNotificationBlock({ (changes) in
            switch changes {
            case .initial:
                self.tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                self.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                self.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                self.tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        })
        return histories
    }()
    
    override func loadView() {
        super.loadView()
        
        self.title = "History"
        self.navigationItem.rightBarButtonItem = self.callButton
        
        self.view.addSubview(self.tableView)
        self.layoutTableView()
    }
    
    private func layoutTableView() {
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.tableView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.tableView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.tableView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.tableView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            ])
    }
    
    @objc func handle(callButton: UIBarButtonItem) {
        let pickerViewController = CNContactPickerViewController()
        pickerViewController.displayedPropertyKeys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey]
        pickerViewController.delegate = self
        self.present(pickerViewController, animated: true, completion: nil)
    }
    
}

extension HistoryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.histories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
        cell.nameLabel.text = self.histories[indexPath.row].name
        cell.phoneNumberLabel.text = self.histories[indexPath.row].phoneNumber
        return cell
    }
}

extension HistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: "tel://\(Constants.prefix)\(self.histories[indexPath.row].phoneNumber)"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54.0
    }
    
}

// MARK: - Views
extension HistoryViewController {
    
    class Cell: UITableViewCell {
        static let reuseIdentifier: String = "Cell"
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            self.setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            
            self.setup()
        }
        
        private var isSetuped: Bool = false
        private func setup() {
            guard !self.isSetuped else { return }
            defer { self.isSetuped = true }
            
            self.contentView.addSubview(self.nameLabel)
            self.contentView.addSubview(self.phoneNumberLabel)
            
            self.layoutNameLabel()
            self.layoutPhoneLabel()
        }
        
        lazy var nameLabel = { () -> UILabel in
            let label = UILabel()
            label.textColor = UIColor(named: "Main")
            label.font = UIFont.systemFont(ofSize: 14.0)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.setContentHuggingPriority(.defaultLow, for: .horizontal)
            label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            return label
        }()
        
        lazy var phoneNumberLabel = { () -> UILabel in
            let label = UILabel()
            label.textAlignment = .right
            label.textColor = UIColor(named: "Sub")
            label.font = UIFont.systemFont(ofSize: 14.0)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.setContentHuggingPriority(.defaultLow, for: .horizontal)
            label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            return label
        }()
        
        private func layoutNameLabel() {
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: self.nameLabel, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1.0, constant: 16.0),
                NSLayoutConstraint(item: self.nameLabel, attribute: .width, relatedBy: .lessThanOrEqual, toItem: self.contentView, attribute: .width, multiplier: 0.3, constant: -16.0).priority(.defaultHigh),
                NSLayoutConstraint(item: self.nameLabel, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1.0, constant: 8.0),
                NSLayoutConstraint(item: self.nameLabel, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: self.contentView, attribute: .bottom, multiplier: 1.0, constant: -8.0),
                ])
        }
        
        private func layoutPhoneLabel() {
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: self.phoneNumberLabel, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1.0, constant: -16.0),
                NSLayoutConstraint(item: self.phoneNumberLabel, attribute: .width, relatedBy: .lessThanOrEqual, toItem: self.contentView, attribute: .width, multiplier: 0.6, constant: -16.0).priority(.defaultHigh),
                NSLayoutConstraint(item: self.phoneNumberLabel, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1.0, constant: 8.0),
                NSLayoutConstraint(item: self.phoneNumberLabel, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: self.contentView, attribute: .bottom, multiplier: 1.0, constant: -8.0),
                ])
        }
    }
    
}
