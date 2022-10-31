//
//  ViewController.swift
//  SeSACWeek1617
//
//  Created by Carki on 2022/10/18.
//

import UIKit

class SimpleTableViewController: UITableViewController {
    
    
    let list = ["슈비버거", "프랭크", "자갈치", "고래밥"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.backgroundColor = .white
        
        var content = cell.defaultContentConfiguration()
        content.text = list[indexPath.row] //textLabel대체
        content.secondaryText = "안녕하세요" //detailTextLabel
        
        cell.contentConfiguration = content
        
        return cell
    }

}

