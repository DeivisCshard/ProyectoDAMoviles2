//
//  ViewController.swift
//  ProyectoMoviles2
//
//  Created by DESIGN on 15/12/25.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var bb: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func verProductos(_ sender: Any) {
        let productsVC = ProductsViewController()
                navigationController?.pushViewController(productsVC, animated: true)
    }



}

