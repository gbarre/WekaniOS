//
//  ViewLists.swift
//  Wekan
//
//  Created by Guillaume on 31/01/2018.
//  Copyright © 2018 Guillaume. All rights reserved.
//

import UIKit

class ViewLists: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var bearer = ""
    var rootURL: String = ""
    var boardId = ""
    var boardTitle = ""
    var listId = ""
    var listTitle = ""
    
    var listsDict = [Int: List]()
    var listsIndex = [Int: String]()
    
    var cardsDict = [Int: Card]()
    var cardsIndex = [Int: String]()
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        navBar.topItem?.title = boardTitle
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listsDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "listCell") as UITableViewCell!
        cell.selectionStyle = .none
        cell.textLabel?.text = (listsDict[indexPath.row]?.title)!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath)
        listId = (listsIndex[indexPath.row])!
        listTitle = (listsDict[indexPath.row]?.title)!
        goToLists(sender: cell!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listSelected" {
            let controller: ViewCards = segue.destination as! ViewCards
            controller.bearer = self.bearer
            controller.rootURL = self.rootURL
            controller.boardId = self.boardId
            controller.boardTitle = self.boardTitle
            controller.listId = self.listId
            controller.listTitle = self.listTitle
            controller.cardsDict = self.cardsDict
            controller.cardsIndex = self.cardsIndex
        }
    }
    
    func goToLists(sender: UITableViewCell) {
        var request = URLRequest(url: URL(string: "\(rootURL)/api/boards/\(boardId)/lists/\(listId)/cards")!)
        request.httpMethod = "GET"
        request.addValue("Bearer \(bearer)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                self.cardsDict = [Int: Card]()
                self.cardsIndex = [Int: String]()
                let cards = try JSONSerialization.jsonObject(with: data!) as! [NSDictionary]
                var i = 0
                for card in cards {
                    let cardId = "\(card["_id"]!)"
                    let cardTitle = "\(card["title"]!)"
                    let cardDesc = (card["description"] != nil) ? "\(card["description"]!)" : ""
                    self.cardsDict[i] = Card(id: cardId, title: cardTitle, desc: cardDesc)
                    self.cardsIndex[i] = cardId
                    i = i + 1
                }
                OperationQueue.main.addOperation {
                    self.performSegue(withIdentifier: "listSelected", sender: sender)
                }
            } catch {
                print("error")
            }
        })
        task.resume()
    }

}
