//
//  ViewController.swift
//  engmyan
//
//  Created by Win Than Htike on 9/1/17.
//  Copyright © 2017 Soe Minn Minn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    var searchResults : [DictionaryItem] = []
    var suggestWordResults : [DictionaryItem] = []
    var isSearched = false

    override func viewDidLoad() {
        super.viewDidLoad()

        searchTableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0,right: 0)
        suggestWordResults = DBManager.shared.querySuggestWord()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier!.elementsEqual("actionShowDetail") {
            if let destination = segue.destination as? DetailViewController {
                destination.recId = (sender as! UITableViewCell).tag
            }
        }
    }

}

extension ViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

//        searchResults = []
//        if let searchWord = searchBar.text {
//            if searchWord != "" {
//                searchResults.append(contentsOf: DBManager.shared.queryWord(searchWord: searchWord))
//            }
//        }
//
//        hasSearched = true
//        searchTableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchResults = []
        
        if let searchWord = searchBar.text {
            if searchWord != "" {
                searchResults.append(contentsOf: DBManager.shared.queryWord(constraint: searchWord))
                isSearched = true
            }
        }
        
        searchTableView.reloadData()
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

extension ViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isSearched {
            return suggestWordResults.count
        } else {
            return searchResults.count
        }
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "SearchResultCell")
        }
        
        var item : DictionaryItem
        if !isSearched {
            item = suggestWordResults[indexPath.row]
        } else {
            item = searchResults[indexPath.row]
        }
        
        cell.textLabel!.text = item.word
        cell.tag = item.id

        return cell
    }
}

extension ViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath) {
            performSegue(withIdentifier: "actionShowDetail", sender: cell)
        }
    }
}
