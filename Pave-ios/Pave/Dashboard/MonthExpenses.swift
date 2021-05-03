import Foundation


struct MonthExpenses {
	var monthDate: Date
	
	var total: MoneyAmount = .zero
	
	var allExpenditures = [Expenditure]()
	
	var bills = [Expenditure]()
	var subscriptions = [Expenditure]()
	
	var monthName: String {
		if monthDate.thisMonth {
			return "This month"
		}
		if monthDate.previousMonth {
			return "Last month"
		}
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMM, yyyy"
		return dateFormatter.string(from: self.monthDate)
	}
}
