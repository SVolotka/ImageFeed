//
//  DateFormatter.swift
//  ImageFeed
//
//  Created by Sergei Volotka on 17.07.2024.
//

import Foundation

class Formatter {
    private lazy var iso8601DateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }()
    
    func convertDate(from date: String?) -> String? {
        guard let date = date,
              let date = iso8601DateFormatter.date(from: date) else {
            return nil
        }
        let stringDate = dateFormatter.string(from: date)
        
        return stringDate
    }
}
