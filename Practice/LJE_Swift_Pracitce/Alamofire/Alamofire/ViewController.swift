//
//  ViewController.swift
//  Alamofire
//
//  Created by dave on 08/10/2018.
//  Copyright © 2018 dave. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let url = "http://swiftapi.rubypaper.co.kr:2029/practice/currentTime"
    Alamofire.request(url).responseString() { response in
      print("성공여부: \(\response.result.isSuccess)")
      print("결과값: \(\response.result.value)")
    }
    
  }


}

