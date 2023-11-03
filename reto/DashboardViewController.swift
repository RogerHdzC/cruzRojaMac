//
//  DashboardViewController.swift
//  reto
//
//  Created by Administrador on 01/11/23.
//
import UIKit
import FirebaseAnalytics


class DashboardViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Analytics Event
        Analytics.logEvent("InitScreen", parameters: ["message": "Integración de Firebase completa"])
    }
}
