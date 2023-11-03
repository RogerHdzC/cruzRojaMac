//
//  AprobarUserViewController.swift
//  reto
//
//  Created by Administrador on 03/11/23.
//

import UIKit

struct Device {
    let title: String
    let imageName: String
}

class AprobarUserViewController: UIViewController{

    private var dataSource: TableViewDataSource?
    private var delegate: TableViewDelegate?

    override func loadView() {
        let tableView = UITableView()
        self.dataSource = TableViewDataSource(dataSource: allMyDevices)
        self.delegate = TableViewDelegate()
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        tableView.register(CustomCellTableViewCell.self, forCellReuseIdentifier: "CustomCellTableViewCell")
        view = tableView
    }

}
