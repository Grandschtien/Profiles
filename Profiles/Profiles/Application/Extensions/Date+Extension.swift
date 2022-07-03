//
//  Date+Extension.swift
//  Profiles
//
//  Created by Егор Шкарин on 30.06.2022.
//

import Foundation

extension DateFormatter {
    static let ddMMyy: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "dd.MM.yy"
        return formatter
    }()
}

extension Date {
    func formatToString(using formatter: DateFormatter) -> String {
        return formatter.string(from: self)
    }
    func getTime(withOffset offset: String = "0:00") -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        if offset == "0:00" {
            let timeNow = formatter.string(from: now)
            return timeNow
        } else {
            let str = formatter.string(from: now)
            guard let dateNow = formatter.date(from: str) else {
                fatalError("Cannot pase date now")
            }
            let unsignOffset = String(offset.dropFirst())
            guard let offsetInTime = formatter.date(from: unsignOffset) else {
                fatalError("Cannot parse offset in time")
            }
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: offsetInTime)
            let minutes = calendar.component(.minute, from: offsetInTime)
            let timeInterval = TimeInterval(hour * 60 * 60 + minutes * 60)
            if let sign = offset.first {
                switch sign {
                case "+":
                    let newDate = dateNow.addingTimeInterval(timeInterval)
                    let resultDate = formatter.string(from: newDate)
                    return resultDate
                case "-":
                    let newDate = dateNow.addingTimeInterval(-timeInterval)
                    let resultDate = formatter.string(from: newDate)
                    return resultDate
                default:
                    fatalError("Unknown sign in date")
                }
            }
        }
        fatalError("Unknown offset of time")
    }
}

extension String {
    func dateFromString() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.date(from: self)
        return date
    }
}
      
