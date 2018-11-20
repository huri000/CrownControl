//
//  SamplesViewController.swift
//  CrownControlDemo
//
//  Created by Daniel Huri on 11/9/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import UIKit
import QuickLayout

class SamplesViewController: UIViewController {

    // MARK: - Properties
    
    private lazy var dataSource: [SampleData] = {
        var array: [SampleData] = []
        array.append(SampleData(title: "Contact List", action: navigateToContactsViewController))
        array.append(SampleData(title: "Photo Collection", action: navigateToPhotoCollectionView))
        array.append(SampleData(title: "PDF Displayer", action: navigateToPDFViewController))
        return array
    }()
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "CrownControl Demo"
        navigationController?.navigationBar.tintColor = .blueGray
        tableView.register(SampleTableViewCell.self, forCellReuseIdentifier: SampleTableViewCell.className)
        tableView.tableFooterView = UIView()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SamplesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SampleTableViewCell.className, for: indexPath) as! SampleTableViewCell
        cell.textLabel?.text = dataSource[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dataSource[indexPath.row].action()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    private func navigateToPDFViewController() {
        let vc = UIStoryboard.main.instantiateViewController(withIdentifier: PDFViewController.className) as! PDFViewController
        navigationController!.pushViewController(vc, animated: true)
    }
    
    private func navigateToPhotoCollectionView() {
        let vc = UIStoryboard.main.instantiateViewController(withIdentifier: PhotoCollectionViewController.className) as! PhotoCollectionViewController
        navigationController!.pushViewController(vc, animated: true)
    }
    
    private func navigateToContactsViewController() {
        let vc = UIStoryboard.main.instantiateViewController(withIdentifier: ContactsViewController.className) as! ContactsViewController
        navigationController!.pushViewController(vc, animated: true)
    }
}
