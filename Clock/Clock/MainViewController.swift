//
//  MainViewController.swift
//  Clock
//
//  Created by olddevil on 2023/3/1.
//

import UIKit

class MainViewController: UIViewController {
    lazy var model: Model = {
        let model = Model { [weak self] refreshInfo in
            guard let `self` = self else { return }
            self.totalDay.text = refreshInfo.totalDaysInfo
            self.totalCount.text = refreshInfo.totalCountInfo
            self.maxContinueDays.text = refreshInfo.maxContinueDaysInfo
            self.currentContinueDays.text = refreshInfo.currentContinueDaysInfo
        }
        return model
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(calendar)
        view.addSubview(clock)
        view.addSubview(record)
        view.addSubview(totalDay)
        view.addSubview(totalCount)
        view.addSubview(maxContinueDays)
        view.addSubview(currentContinueDays)
    }
    
    @objc func clockClicked() {
        model.insertRecord()
    }
    
    @objc func recordClicked() {
        if let records = model.getRecord(day: model.selectedDay) {
            let record = RecordViewController()
            record.records = records
            record.removeClourse = { index in
                self.model.remove(index: index)
            }
            self.navigationController?.pushViewController(record, animated: true)
        } else {
            print("暂无打卡信息")
        }
    }
    
    lazy var clock: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: Constants.kScreenHeight - 80, width: Constants.kScreenWidth / 2, height: 40)
        btn.setTitle("打卡", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(clockClicked), for: .touchUpInside)
        return btn
    }()
    
    lazy var record: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: clock.frame.maxX, y: Constants.kScreenHeight - 80, width: Constants.kScreenWidth / 2, height: 40)
        btn.setTitle("记录", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(recordClicked), for: .touchUpInside)
        return btn
    }()
    
    lazy var calendar: CalendarView = {
        let date = Date()
        let calendarView = CalendarView.instance(baseDate: date, selectedDate: date)
        calendarView.frame = CGRect(x: (Constants.kScreenWidth - 300) / 2, y: 80, width: 300, height: 300)
        calendarView.delegate = self
        return calendarView
    }()
    
    // 总打卡天数
    lazy var totalDay: UILabel = {
        let l = UILabel()
        l.frame = CGRect(x: 20, y: calendar.frame.maxY + 50, width: 300, height: 20)
        l.textColor = .black
        return l
    }()
    
    // 总打卡次数
    lazy var totalCount: UILabel = {
        let l = UILabel()
        l.frame = CGRect(x: 20, y: totalDay.frame.maxY + 10, width: 300, height: 20)
        l.textColor = .black
        return l
    }()
    
    // 最大打卡连续天数
    lazy var maxContinueDays: UILabel = {
        let l = UILabel()
        l.frame = CGRect(x: 20, y: totalCount.frame.maxY + 10, width: 300, height: 20)
        l.textColor = .black
        return l
    }()
    
    // 当前打卡连续天数
    lazy var currentContinueDays: UILabel = {
        let l = UILabel()
        l.frame = CGRect(x: 20, y: maxContinueDays.frame.maxY + 10, width: 300, height: 20)
        l.textColor = .black
        return l
    }()
}

extension MainViewController: CalendarViewDelegate {
    func didSelectDate(date: Date) {
        let dateStr = model.formatter.string(from: date)
        model.selectedDay = dateStr.components(separatedBy: "_").first!
        model.isAdd = model.selectedDay != model.currentDay
        clock.setTitle(model.isAdd ? "补卡" : "打卡", for: .normal)
    }
}
