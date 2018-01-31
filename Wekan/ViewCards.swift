//
//  ViewCards.swift
//  Wekan
//
//  Created by Guillaume on 31/01/2018.
//  Copyright © 2018 Guillaume. All rights reserved.
//

import UIKit

class ViewCards: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var bearer = ""
    var rootURL: String = ""
    var boardId = ""
    var boardTitle = ""
    var listId = ""
    var listTitle = ""
    
    var cardsDict = [Int: Card]()
    var cardsIndex = [Int: String]()
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func btnBoard(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        navBar.topItem?.title = listTitle
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardsDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cardCell") as UITableViewCell!
        cell.selectionStyle = .none
        cell.textLabel?.text = (cardsDict[indexPath.row]?.title)!
        cell.detailTextLabel?.text = (cardsDict[indexPath.row]?.desc)!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(cardsDict[indexPath.row]!.id)
        print(cardsDict[indexPath.row]!.title)
        print(cardsDict[indexPath.row]!.desc)
        //performSegue(withIdentifier: "listSelected", sender: tableView.cellForRow(at: indexPath))
    }

}
