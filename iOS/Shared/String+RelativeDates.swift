import Foundation

public extension String {
    func parseDateFormatRelative() -> String? {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = dateFormatter.date(from: self) else {
            return nil
        }
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        formatter.doesRelativeDateFormatting = true
        return formatter.string(from: date)
    }
    
    func parseDateTimeFormatRelative() -> String? {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let now = Date()
        if let date = dateFormatter.date(from: self) {
            if date.distance(to: now).isLessThanOrEqualTo(60) {
                return "just now"
            } else if date.distance(to: now).isLessThanOrEqualTo(4 * 24 * 60 * 60)  {
                let formatter = RelativeDateTimeFormatter()
                formatter.unitsStyle = .full
                return formatter.localizedString(for: date, relativeTo: now)
            } else {
                let formatter = DateFormatter()
                if date.isInSameYear(as: now) {
                    formatter.setLocalizedDateFormatFromTemplate("dMMMM 'at' jjmm")
                } else {
                    formatter.dateStyle = .medium
                    formatter.timeStyle = .short
                }
                
                return formatter.string(from: date)
            }
        }
        return nil
    }
}

extension Date {
    
    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }
    
    func isInSameYear(as date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }
    func isInSameMonth(as date: Date) -> Bool { isEqual(to: date, toGranularity: .month) }
    func isInSameWeek(as date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) }
    
    func isInSameDay(as date: Date) -> Bool { Calendar.current.isDate(self, inSameDayAs: date) }
    
    var isInThisYear: Bool { isInSameYear(as: Date()) }
    var isInThisMonth: Bool { isInSameMonth(as: Date()) }
    var isInThisWeek: Bool { isInSameWeek(as: Date()) }
    
    var isInYesterday: Bool { Calendar.current.isDateInYesterday(self) }
    var isInToday: Bool { Calendar.current.isDateInToday(self) }
    var isInTomorrow: Bool { Calendar.current.isDateInTomorrow(self) }
    
    var isInTheFuture: Bool { self > Date() }
    var isInThePast: Bool { self < Date() }
}
