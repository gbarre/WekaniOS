//
//  ViewBoards
//  Wekan
//
//  Created by Guillaume on 31/01/2018.
//  Copyright © 2018 Guillaume. All rights reserved.
//

import UIKit

class ViewBoards: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var bearer = ""
    var rootURL: String = ""
    var id = ""
    var boardId = ""
    var boardTitle = ""
    
    var boardsDict = [Int: Board]()
    var boardsIndex = [Int: String]()
    
    var listsDict = [Int: List]()
    var listsIndex = [Int: String]()

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func disconnect(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set("1970-01-01T11:46:24.452Z", forKey: "tokenExpires")
        defaults.set("", forKey: "token")
        defaults.set("", forKey: "url")
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boardsDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "boardCell") as UITableViewCell!
        cell.selectionStyle = .none
        cell.textLabel?.text = (boardsDict[indexPath.row]?.title)!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath)
        boardId = (boardsIndex[indexPath.row])!
        boardTitle = (boardsDict[indexPath.row]?.title)!
        goToLists(sender: cell!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "boardSelected" {
            let controller: ViewLists = segue.destination as! ViewLists
            controller.bearer = self.bearer
            controller.rootURL = self.rootURL
            controller.boardId = self.boardId
            controller.boardTitle = self.boardTitle
            controller.listsDict = self.listsDict
            controller.listsIndex = self.listsIndex
        }
    }
    
    func goToLists(sender: UITableViewCell) {
        var request = URLRequest(url: URL(string: "\(rootURL)/api/boards/\(boardId)/lists")!)
        request.httpMethod = "GET"
        request.addValue("Bearer \(bearer)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let lists = try JSONSerialization.jsonObject(with: data!) as! [NSDictionary]
                self.listsDict = [Int: List]()
                self.listsIndex = [Int: String]()
                var i = 0
                for list in lists {
                    let listId = "\(list["_id"]!)"
                    let listTitle = "\(list["title"]!)"
                    self.listsDict[i] = List(id: listId, title: listTitle)
                    self.listsIndex[i] = listId
                    i = i + 1
                }
                OperationQueue.main.addOperation {
                    self.performSegue(withIdentifier: "boardSelected", sender: sender)
                }
            } catch {
                print("error")
            }
        })
        task.resume()
    }
}

