import Foundation


struct Expenditure {
	let category: ExpenditureCategory
	let merchantName: String
	
	let lastTransactionAmount: MoneyAmount
	let lastTransactionDescription: String
	let lastTransactionDate: Date
	
	let previousTransactionAmount: MoneyAmount
	let previousTransactionDate: Date
	
	let transactionDeltaAmount: MoneyAmount
	let transactionDeltaPercent: Double
	
	let avgAmount: MoneyAmount
	
	let transactionCount: Int
	let avgPeriodDays: Double
	
	let normalizedFrequency: ExpenditureFrequency
	
	static func fromDTO(_ dto: ExpenditureDTO) -> Expenditure {
		return Expenditure(
			category: dto.category,
			merchantName: dto.normalizedMerchantName,
			lastTransactionAmount: MoneyAmount(currency: Currency(code: dto.isoCurrencyCode), amount: dto.lastTransactionAmount),
			lastTransactionDescription: dto.lastTransactionDescription,
			lastTransactionDate: dto.lastTransactionDate,
			previousTransactionAmount: MoneyAmount(currency: Currency(code: dto.isoCurrencyCode), amount: dto.previousTransactionAmount),
			previousTransactionDate: dto.previousTransactionDate,
			transactionDeltaAmount: MoneyAmount(currency: Currency(code: dto.isoCurrencyCode), amount: dto.transactionDeltaAmount),
			transactionDeltaPercent: dto.transactionDeltaPercent,
			avgAmount: MoneyAmount(currency: Currency(code: dto.isoCurrencyCode), amount: dto.avgAmount),
			transactionCount: dto.transactionCount,
			avgPeriodDays: dto.avgPeriodDays,
			normalizedFrequency: dto.normalizedFrequency
		)
	}
}


extension Expenditure {
	var merchantNameAbbreviation: String {
		let words = merchantName.split(separator: " ").map { String($0) }
		
		var lettersArray = [String]()
		for string in words {
			if let letter = string.first {
				lettersArray.append(String(letter))
			}
		}
		
		switch lettersArray.count {
		case 0:
			return ""
		case 1:
			return lettersArray.first!
		default:
			return lettersArray.first! + lettersArray.last!
		}
	}
}

enum ExpenditureCategory: String, Decodable {
	case bill = "Bill"
	case utility = "Utility"
	case subscription = "Subscription"
	case rent = "Rent"
	case other = "Other"
}


enum ExpenditureFrequency: String, Decodable {
	case daily, weekly, biweekly, monthly, bimonthly, quarterly, annual
	case semiAnnual = "semi-annual"
}


