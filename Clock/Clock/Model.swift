//
//  Model.swift
//  Clock
//
//  Created by olddevil on 2023/3/1.
//

import Foundation

class Model {
    
    typealias RefreshClourse = (ShowInfo) -> Void
    
    // 数据元
    private var data: [String: [Record]] = [:]
    // 当前日期（yyyy.MM.dd）
    var currentDay: String = ""
    // 选中日期（yyyy.MM.dd）
    var selectedDay: String = ""
    // 是否为补卡
    var isAdd = false
    // 打卡记录变化后，刷新UI回调
    var refreshClourse: RefreshClourse?
    
    init(refreshClourse: @escaping RefreshClourse) {
        self.refreshClourse = refreshClourse
        self.currentDay = ymdFormatter.string(from: Date())
    }
    
    // 插入打卡记录
    func insertRecord() {
        let date = Date()
        
        let str = formatter.string(from: date)
        let record = Record(recordTime: str, isAdd: isAdd)
        
        if data.keys.contains(selectedDay) {
            var v = data[selectedDay]
            v?.append(record)
            data[selectedDay] = v
        } else {
            data[selectedDay] = [record]
        }
        
        statistics()
    }
    
    // 删除打卡记录
    func remove(index: Int) {
        var records = data[selectedDay]
        records?.remove(at: index)
        if records?.isEmpty ?? true {
            data.removeValue(forKey: selectedDay)
        } else {
            data[selectedDay] = records
        }
        
        statistics()
    }
    
    // 统计主页展示数据
    func statistics() {
        let count = data.values.reduce(0) { $0 + $1.count }
        let (max, current) = statisticsContinueDays()
        
        let totalDaysInfo = "总打卡天数：\(data.keys.count)天"
        let totalCountInfo = "总打卡次数：\(count)次"
        let maxContinueDaysInfo = "历史最高连续打卡天数：\(max)天"
        let currentContinueDaysInfo = "当前连续打卡天数：\(current)天"
        
        let showInfo = ShowInfo(totalDaysInfo: totalDaysInfo, totalCountInfo: totalCountInfo, maxContinueDaysInfo: maxContinueDaysInfo, currentContinueDaysInfo: currentContinueDaysInfo)
        refreshClourse?(showInfo)
    }
    
    // 统计历史最高连续打卡天数和当前连续打卡天数
    func statisticsContinueDays() -> (Int, Int) {
        let keys = data.keys
        if keys.count == 0 { return (0, 0) }
        if keys.count == 1 {
            if keys.first! == currentDay {
                return (1, 1)
            }
            return (1, 0)
        }
        
        var currentContinueDays = 0
        var maxContinueDays = 0
        var continueDays = 0
        var cursorDay: Date?
        let oneDayInterval: TimeInterval = 24 * 3600
        
        let days = keys.sorted(by: { $1 > $0 })
        for i in 0..<days.count {
            let iterateDate = ymdFormatter.date(from: days[i])
            if cursorDay == nil {
                cursorDay = iterateDate
                continueDays += 1
            } else {
                if (iterateDate!.timeIntervalSince1970 - cursorDay!.timeIntervalSince1970) <= oneDayInterval {
                    continueDays += 1
                    if i == keys.count - 1 {
                        maxContinueDays = maxContinueDays > continueDays ? maxContinueDays : continueDays
                        if days[i] == currentDay {
                            currentContinueDays = continueDays
                        }
                    }
                } else {
                    maxContinueDays = maxContinueDays > continueDays ? maxContinueDays : continueDays
                    if days[i] == currentDay {
                        currentContinueDays = 1
                    }
                    continueDays = 1
                }
                cursorDay = iterateDate
            }
        }
            
        return (maxContinueDays, currentContinueDays)
    }
    
    // 获取打卡列表记录
    func getRecord(day: String) -> [Record]? {
        return data[day]
    }
    
    lazy var formatter: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "yyyy.MM.dd_HH:mm:ss"
        return format
    }()
    
    lazy var ymdFormatter: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "yyyy.MM.dd"
        return format
    }()
}

struct Record {
    let recordTime: String
    let isAdd: Bool
}

struct ShowInfo {
    let totalDaysInfo: String
    let totalCountInfo: String
    let maxContinueDaysInfo: String
    let currentContinueDaysInfo: String
}
