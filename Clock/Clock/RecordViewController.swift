//
//  RecordViewController.swift
//  Clock
//
//  Created by olddevil on 2023/3/1.
//

import UIKit

class RecordViewController: UIViewController {

    var records: [Record] = []
    var removeClourse: ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "打卡记录"
        view.backgroundColor = .white
        view.addSubview(t)
    }
    
    deinit {
        print("released")
    }
    
    lazy var t: UITableView = {
        let t = UITableView(frame: view.bounds, style: .plain)
        t.registerCellClass(aClass: UITableViewCell.self)
        t.delegate = self
        t.dataSource = self
        return t
    }()
}

extension RecordViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let record = records[indexPath.row]
        let cell = tableView.dequeueReusableCell(aClass: UITableViewCell.self)
        cell.textLabel?.text = record.recordTime + (record.isAdd ? "补卡" : "打卡")
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "删除") { [weak self] action, view, handler in
            guard let `self` = self else { return }
            handler(true)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.records.remove(at: indexPath.row)
            tableView.endUpdates()
            self.removeClourse?(indexPath.row)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}
