import Foundation


/// Use this struct for money
struct MoneyAmount: Equatable, Comparable {
	enum MoneyError: Error {
		case differentCurrencies
	}
		
	var currency: Currency
	var amount: Double
	
	func string(showSign: Bool = false) -> String {
		if amount >= 0 {
			var result = "\(currency.sign)\(String(format: "%.2f", amount))"
			if showSign {
				result = "+" + result
			}
			return result
		} else {
			return "-\(currency.sign)\(String(format: "%.2f", -amount))"
		}
	}
	
	static var zero: MoneyAmount = MoneyAmount(currency: .unknown, amount: 0)
	
	static func == (lhs: MoneyAmount, rhs: MoneyAmount) -> Bool {
		if lhs.currency == rhs.currency {
			return fabs(lhs.amount - rhs.amount) <= 0.01 // floats are equal if they differ by less than 0.01.
		}
		return false
	}
	
	static func < (lhs: MoneyAmount, rhs: MoneyAmount) -> Bool {
		if lhs == rhs {
			return false
		}
		return lhs.amount < rhs.amount
	}
	
	static func +(lhs: MoneyAmount, rhs: MoneyAmount) throws -> MoneyAmount {
		if lhs == zero {
			return rhs
		} else if rhs == zero {
			return lhs
		}
		
		if lhs.currency == rhs.currency {
			return MoneyAmount(currency: lhs.currency, amount: lhs.amount + rhs.amount)
		} else {
			throw MoneyError.differentCurrencies
		}
	}
	
	static func +=(lhs: inout MoneyAmount, rhs: MoneyAmount) throws {
		lhs = try lhs + rhs
	}
}


func doubleEqual(_ a: Double, _ b: Double) -> Bool {
	return fabs(a - b) < Double.ulpOfOne
}

struct Currency: Equatable {
	var code: String
	var sign: String {
		switch self.code {
		case "USD":
			return "$"
		case "EUR":
			return "€"
		default:
			return code
		}
	}
	
	static let unknown = Currency(code: "")
}


