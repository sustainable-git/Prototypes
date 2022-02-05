//
//  MenuViewController.swift
//  FoodApp
//
//  Created by shin jae ung on 2022/01/01.
//

import UIKit

protocol Popable: AnyObject {
    func viewDidPop()
}

final class MenuViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    weak var popDelegate: Popable?
    var viewModel: MenuViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.label.text = viewModel?.foodEntity.title
    }
    
    deinit {
        self.popDelegate?.viewDidPop()
    }
}
