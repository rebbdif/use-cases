import Foundation
import UIKit
import Charts


/// Cell that contains graph in it
class GraphCell: UITableViewCell {
	
	// MARK: - public
	
	func setValuesForGraph(_ values: [MonthExpenses]) {
		let bars = values.map { DashboardValue(barName: $0.monthName, barHeight: $0.total.amount) }
		self.dashboardViewController.setValues(bars)
	}
	
	func setTitle(_ title: String?) {
		self.dashboardViewController.titleLabel.text = title
	}
	
	lazy var dashboardViewController: DatedLineChartViewController = {
		let vc = DatedLineChartViewController()
		return vc
	}()
	
	// MARK: - lifecycle
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		let dashboardView = dashboardViewController.view!
		dashboardView.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(dashboardView)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override class var requiresConstraintBasedLayout: Bool {
		return true
	}
	
	override func updateConstraints() {
		let dashboardView = dashboardViewController.view!
		NSLayoutConstraint.activate([
			dashboardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
			dashboardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
			dashboardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
			dashboardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
		])
		super.updateConstraints()
	}
}
