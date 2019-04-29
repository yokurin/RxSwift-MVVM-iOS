//
//  ViewController.swift
//  RxSwiftMVVM
//
//  Created by Tsubasa Hayashi on 2019/04/29.
//  Copyright © 2019 Tsubasa Hayashi. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    @IBAction func onListScreenAction(_ sender: Any) {
        let vc = ListViewController.make(with: ListViewModel(language: "RxSwift"))
        navigationController?.pushViewController(vc, animated: true)
    }

}

