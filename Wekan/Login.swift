//
//  Login.swift
//  wekanBoardsiOS
//
//  Created by Guillaume on 31/01/2018.
//

import UIKit

class Login: UIViewController {
    
    var bearer = ""
    var id = ""
    
    var boardsDict = [Int: Board]()
    var boardsIndex = [Int: String]()

    @IBOutlet weak var rootURL: UITextField!
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBAction func getToken(_ sender: UIButton) {
        let params = ["username": "\(login.text!)", "password": "\(password.text!)"]
        var request = URLRequest(url: URL(string: "\(rootURL.text!)/users/login")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if data != nil {
                do {
                    let credentials = try JSONSerialization.jsonObject(with: data!) as! NSDictionary
                    self.bearer = "\(credentials["token"]!)"
                    self.id = "\(credentials["id"]!)"
                    let defaults = UserDefaults.standard
                    defaults.set("\(credentials["tokenExpires"]!)", forKey: "tokenExpires")
                    defaults.set("\(credentials["token"]!)", forKey: "token")
                    defaults.set("\(credentials["id"]!)", forKey: "id")
                    defaults.set("\(self.rootURL.text!)", forKey: "url")
                    
                    OperationQueue.main.addOperation {
                        self.goToBoards()
                    }
                } catch {
                    print("error")
                }
                
            }
        })
        task.resume()
    }
    
    override func viewDidLoad() {
        rootURL.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getCredentials()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginOK" {
            let controller: ViewBoards = segue.destination as! ViewBoards
            controller.bearer = self.bearer
            controller.rootURL = self.rootURL.text!
            controller.id = self.id
            controller.boardsDict = self.boardsDict
            controller.boardsIndex = self.boardsIndex
        }
    }
    
    func getCredentials() {
        let defaults = UserDefaults.standard
        
        if let tokenExpires = defaults.string(forKey: "tokenExpires") {
            let expireDay = "\(tokenExpires.prefix(tokenExpires.count - 5))"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss"
            
            guard let expireDate = dateFormatter.date(from: expireDay) else {
                fatalError("ERROR: Date conversion failed due to mismatched format.")
            }

            if Date() < expireDate {
                if let token = defaults.string(forKey: "token") {
                    self.bearer = token
                    self.rootURL.text = defaults.string(forKey: "url")
                    self.id = defaults.string(forKey: "id")!
                    goToBoards()
                }
            }
        }
    }
    
    
    
    func goToBoards() {
        var request = URLRequest(url: URL(string: "\(rootURL.text!)/api/users/\(id)/boards")!)
        request.httpMethod = "GET"
        request.addValue("Bearer \(bearer)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let boards = try JSONSerialization.jsonObject(with: data!) as! [NSDictionary]
                var i = 0
                for board in boards {
                    let boardId = "\(board["_id"]!)"
                    let boardTitle = "\(board["title"]!)"
                    self.boardsDict[i] = Board(id: boardId, title: boardTitle)
                    self.boardsIndex[i] = boardId
                    i = i + 1
                }
                OperationQueue.main.addOperation {
                    self.performSegue(withIdentifier: "loginOK", sender: self)
                }
            } catch {
                print("error")
            }
        })
        task.resume()
    }
    
}
