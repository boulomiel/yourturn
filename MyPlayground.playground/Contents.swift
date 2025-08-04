import Foundation

public protocol DateStoreProtocol {
    func getDates(from first: Date, to second: Date, by adding: Calendar.Component, value: Int) -> [Date]
    func getAllDates(for month: Int, year: Int) -> [Date]
}

public struct DateStore: DateStoreProtocol {
    
    let calendar: Calendar
    
    public init(calendar: Calendar = .current) {
        self.calendar = calendar
    }
    
    
    /// Gets numbers from a specific date to another specific date, by adding a wanted componenent (day, hours, min ... )
    /// - Parameters:
    ///   - first: startDate
    ///   - second: destionation Date
    ///   - adding: Calendar.Component bump
    ///   - value: number of bumps at onces
    /// - Returns: arrays of dates
    public func getDates(from first: Date, to second: Date, by adding: Calendar.Component, value: Int) -> [Date] {
        guard second > first else { return [] }
        var results: [Date] = []
        let roundedSecond = calendar.date(from: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: second))!
        var copy = calendar.date(from: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: first))!
        print(roundedSecond.formatted(), "-" ,copy.formatted())
        while copy < roundedSecond, let date = calendar.date(byAdding: adding, value: value, to: copy) {
            copy = date
            results.append(date)
        }
        return results
    }
    
    public func getAllDates(for month: Int, year: Int) -> [Date] {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1

        guard let startOfMonth = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: startOfMonth) else {
            return []
        }

        return range.compactMap { day -> Date? in
            var dateComponents = components
            dateComponents.day = day
            return calendar.date(from: dateComponents)
        }
    }
    
    
    /// Returns the week in week day that includes the base date
    /// - Parameter from: The date we want to find the week which contains it
    /// - Returns: An array of week day from sunday to saturday including the base date
    public func getWeek(from base:  Date) -> [Date] {
        
        // Makes the date clean
        guard let midDayDate = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: base) else {
            return []
        }
        
        let days = Calendar.current.component(.day, from: midDayDate)
        print(days)
        return []
    }
}


let dataStore = DateStore()
_ = dataStore.getWeek(from: .now)

struct Message {
    
}

class Chat {
     nonisolated(unsafe) static let shared: Chat = .init()
    
    var onMessage: (Message) -> Void = { _ in }
}

AsyncStream<Message> { continuation in
    Chat.shared.onMessage = {
        continuation.yield($0)
    }
}


