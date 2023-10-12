//
//  MoviewDetailsViewController.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 12.10.2023.
//

import UIKit

class MoviewDetailsViewController: UIViewController {
  // MARK: - Properties
  weak var coordinator: AppCoordinator?
  var navTitle: String
  
  // MARK: - Life Cycle
  init(title: String) {
    self.navTitle = title
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationBar()
    // Do any additional setup after loading the view.
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}

extension MoviewDetailsViewController {
  func configureNavigationBar() {
    self.title = navTitle
  }
}
