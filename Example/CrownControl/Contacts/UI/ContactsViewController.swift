//
//  ContactsViewController.swift
//  CrownControlDemo
//
//  Created by Daniel Huri on 11/11/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import UIKit
import CrownControl
import QuickLayout

class ContactsViewController: UIViewController {

    // MARK: - Properties
    
    private let contactManager = ContactManager()
    
    private var firstLetters: [Character] {
        return contactManager.firstLetters
    }
    
    private var crownViewController: CrownViewController!
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadData()
    }
    
    // MARK: - Setup
    
    private func setupTableView() {
        tableView.register(UINib(nibName: ContactTableViewCell.className, bundle: nil), forCellReuseIdentifier: ContactTableViewCell.className)
        tableView.register(ContactHeaderView.self, forHeaderFooterViewReuseIdentifier: ContactHeaderView.className)
        tableView.allowsSelection = false
    }
    
    private func setupCrownViewController() {
        let attributes = CrownAttributes(using: tableView)
        attributes.foregroundStyle.content = .color(color: .white)
        attributes.backgroundStyle.content = .gradient(gradient: .init(colors: [UIColor(rgb: 0x304352), UIColor(rgb: 0xd7d2cc)], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        attributes.backgroundStyle.border = .value(color: UIColor(rgb: 0x304352), width: 1)
        attributes.sizes.scrollRelation = round(tableView.contentSize.height / UIScreen.main.bounds.height)
        crownViewController = CrownIndicatorViewController(with: attributes, delegate: self)
        
        // Cling the bottom of the crown to the bottom of the web view with -50 offset
        let verticalConstraint = CrownAxisConstraint(crownEdge: .bottom, anchorView: tableView, anchorViewEdge: .bottom, offset: -50)
        
        // Cling the bottom of the crown to the bottom of its superview with -50 offset
        let horizontalConstraint = CrownAxisConstraint(crownEdge: .trailing, anchorView: tableView, anchorViewEdge: .trailing, offset: -50)
        
        crownViewController.layout(in: self, horizontalConstaint: horizontalConstraint, verticalConstraint: verticalConstraint)
    }
    
    private func loadData() {
        contactManager.requestAccess { [weak self] state in
            switch state {
            case .granted:
                self?.contactManager.loadContacts { [weak self] in
                    self?.tableView.reloadData()
                    self?.setupCrownViewController()
                }
            default:
                break
            }
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate

extension ContactsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return firstLetters.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactManager.numberOfContacts(with: firstLetters[section])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.className, for: indexPath) as! ContactTableViewCell
        cell.contactManager = contactManager
        cell.contact = contactManager.contact(by: firstLetters[indexPath.section], and: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ContactHeaderView.className) as! ContactHeaderView
        header.initial = firstLetters[section]
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = tableView.contentOffset.y / (tableView.contentSize.height - tableView.bounds.height)
        crownViewController?.spin(to: offsetY)
    }
}

// MARK: - CrownDelegate

extension ContactsViewController: CrownDelegate {
    func crown(_ crownViewController: CrownViewController, willUpdate progress: CGFloat) {}
    func crown(_ crownViewController: CrownViewController, didUpdate progress: CGFloat) {}
}
