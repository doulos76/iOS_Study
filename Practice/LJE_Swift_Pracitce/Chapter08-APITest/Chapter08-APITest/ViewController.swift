//
//  ViewController.swift
//  Chapter08-APITest
//
//  Created by dave on 08/10/2018.
//  Copyright © 2018 dave. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

  // MARK:- Outlets
  @IBOutlet weak var currentTime: UILabel!
  @IBOutlet weak var responseView: UITextView!
  @IBOutlet weak var userId: UITextField!
  @IBOutlet weak var name: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    let url = "http://swiftapi.rubypaper.co.kr:2029/practice/currentTime"
    Alamofire.request(url).responseString { response in
      print("성공여부: \(response.result.isSuccess)")
      print("결과값:\(response.result.value!)")
    }
    
    let url1 = "http://swiftapi.rubypaper.co.kr:2029/practice/echo"
    let param: Parameters = [
      "userId": "squpro",
      "name": "재은 씨"
    ]

    let alamo = Alamofire.request(url1, method: .post, parameters: param, encoding: URLEncoding.httpBody)
    alamo.responseJSON() { response in
      print("JSON=\(response.result.value!)")
      if let jsonObject = response.result.value as? [String: Any] {
        print("userId = \(jsonObject["userId"]!)")
        print("name = \(jsonObject["name"]!)")
      }
    }
  }

  @IBAction func callCurrentTime(_ sender: Any) {
    do {
      // 1. URL 설정 및 GET 방식으로 API 호출
      let url = URL(string: "http://swiftapi.rubypaper.co.kr:2029/practice/currentTime")
      let response = try String(contentsOf: url!)
      
      // 2. 읽어온 값을 레이블에 표시
      self.currentTime.text = response
      self.currentTime.sizeToFit()
    } catch let e as NSError {
      print(e.localizedDescription)
    }
  }
  
  @IBAction func post(_ sender: Any) {
    // 전송할 값 준비
    let userId = (self.userId.text)!
    let name = (self.name.text)!
    let param = "userId=\(userId)&name=\(name)"
    let paramData = param.data(using: .utf8)
    
    // URL 객체 정의
    let url = URL(string: "http://swiftapi.rubypaper.co.kr:2029/practice/echo")
    
    // URLRequest 객체를 정의하고, 요청 내용을 담음
    var request = URLRequest(url: url!)
    request.httpMethod = "POST"
    request.httpBody = paramData
    
    // HTTP message header 설정
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.setValue(String(paramData!.count), forHTTPHeaderField: "Content-Length")
    
    // URLSession 객체를 통해 전송 및 응답값 처리 로직 처리
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
      print("Response Data=\(String(data: data!, encoding: .utf8)!)")
      // 서버가 응답이 없거나 통신이 실패했을 때
      if let e = error {
        NSLog("An error has occurred : \(e.localizedDescription)")
        return
      }
      // 응답 처리 로직
      DispatchQueue.main.async {
        do {
          let object = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
          guard let jsonObject = object else { return }
          
          let result = jsonObject["result"] as? String
          let timeStamp = jsonObject["timestamp"] as? String
          let userId = jsonObject["userId"] as? String
          let name = jsonObject["name"] as? String
          
          if result == "SUCCESS" {
            self.responseView.text = "아이디: \(userId!)" + "\n"
                                      + "이름 : \(name!)" + "\n"
                                      + "응답결과 : \(result!)" + "\n"
                                      + "응답시간 : \(timeStamp!)" + "\n"
                                      + "요청방식 : x-www-form-urlencoded"
          }
          
        } catch let e as NSError {
          print("An error has occurred while parsing JSONObject : \(e.localizedDescription)")
        }
      }
    }
    // POST 전송
    task.resume()
  }
  @IBAction func json(_ sender: Any) {
    // 전송할 값 준비
    let usrId = (self.userId.text)!
    let name = (self.name.text)!
    let param = ["userId": usrId, "name": name]
    let paramData = try! JSONSerialization.data(withJSONObject: param, options: [])

    // URL 객체 정의
    let url = URL(string: "http://swiftapi.rubypaper.co.kr:2029/practice/echoJSON")
    
    // URLRequest 개게 정의 및 요청 내용 담기
    var request = URLRequest(url: url!)
    request.httpMethod = "POST"
    request.httpBody = paramData

    // HTTP 메시지에 포할될 헤더 설정
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(String(paramData.count), forHTTPHeaderField: "Content-Length")

    // URLSession 객체를 통해 전송 및 응답값 처리 로직 작성
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
      if let err = error {
        NSLog("An error has occured: \(err.localizedDescription)")
//        print(err.localizedDescription)
//        debugPrint(err.localizedDescription)
        return
      }

      DispatchQueue.main.async {
        do {
          let object = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
          guard let jsonObject = object else { return }

          let result = jsonObject["result"] as? String
          let timeStamp = jsonObject["timestamp"] as? String
          let userId = jsonObject["userId"] as? String
          let name = jsonObject["name"] as? String

          if result == "SUCCESS" {
            self.responseView.text = "아이디: \(userId!)" + "\n"
              + "이름 : \(name!)" + "\n"
              + "응답결과 : \(result!)" + "\n"
              + "응답시간 : \(timeStamp!)" + "\n"
              + "요청방식 : application/json"
          }
        } catch let e as NSError {
          print("An error has occured while parsing JSONObject : \(e.localizedDescription)")
        }
      }
    }
    task.resume()
  }
}

