//
//  ViewController.swift
//  DailyAlgorithm
//
//  Created by zhang on 2023/12/19.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
    }
    
    lazy var titles: [String] = {
        return ["1.两数之和", "2.最大数", "3.最后一个单词的长度", "4.加一", "最长公共前缀"]
    }()

    lazy var tableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = .clear
        tableView.bounces = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 80, right: 0)
        return tableView
    }()
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ALGTableViewCell
        if cell == nil {
            cell = ALGTableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.messageLabel.text = titles[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let title = titles[indexPath.row]
        return ALGTableViewCell.cellHeight(title: title)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let obj = Algorithms.shared
        switch (indexPath.row + 1) {
        case 1: obj.day1()
        case 2: obj.day2()
        case 3: obj.day3()
        case 4: obj.day4()
        case 5: obj.day5()
        default: break
        }
    }
}
