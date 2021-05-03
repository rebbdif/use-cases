import UIKit


protocol ExpensesDashboardView {
	func updateData()
	func showError(_ error: Error)
}


class ExpensesViewController: UIViewController, ExpensesDashboardView {
	
	enum Sections: Int, RawRepresentable, CaseIterable {
		case graph = 0
		case bills = 1
		case subscriptions = 2
		
		var reuseId: String {
			return "reuse_id_\(self.rawValue)"
		}
	}
		
	private lazy var presenter: DashboardPresenterProtocol = ExpensesDashboardPresenter(expensesView: self)
	
	// MARK: - UI

	private lazy var tableView: UITableView = {
		let t = UITableView(frame: .zero)
		t.translatesAutoresizingMaskIntoConstraints = false
		t.register(ExpenditureCell.self, forCellReuseIdentifier: Sections.bills.reuseId)
		t.register(ExpenditureCell.self, forCellReuseIdentifier: Sections.subscriptions.reuseId)
		return t
	}()
	
	private lazy var loader: UIActivityIndicatorView = {
		let loader = UIActivityIndicatorView()
		return loader
	}()
	
	var refreshControl = UIRefreshControl()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(tableView)
		tableView.dataSource = self
		tableView.delegate = self
		
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
			tableView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
		])
		
		refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
		refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
		tableView.addSubview(refreshControl)
		
		tableView.addSubview(loader)
		loader.center = view.center
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		loader.startAnimating()
		presenter.getExpenses(for: Date())
	}
	
	@objc func refresh(_ sender: AnyObject) {
		refreshControl.endRefreshing()
		tableView.reloadData()
	}
	
	// MARK: - ExpensesDashboardView
	
	func updateData() {
		DispatchQueue.main.async {
			self.loader.stopAnimating()
			self.tableView.reloadData()
		}
	}
	
	func showError(_ error: Error) {
		DispatchQueue.main.async {
			self.loader.stopAnimating()
			let errorText: String? = {
				if let error = error as? ErrorWithDescription {
					return error.errorDescription
				} else {
					return error.localizedDescription
				}
			}()
			let alert = UIAlertController(title: "Error", message: errorText, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
				self.presenter.getExpenses(for: Date())
			}))
			self.present(alert, animated: true, completion: nil)
		}
	}
}


extension ExpensesViewController: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return Sections.allCases.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case Sections.graph.rawValue:
			return 1
		case Sections.bills.rawValue:
			return presenter.currentMonthExpenses.bills.count
		case Sections.subscriptions.rawValue:
			return presenter.currentMonthExpenses.subscriptions.count
		default:
			fatalError("Section \(section) not implemented")
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.section {
		case Sections.graph.rawValue:
			let cell = GraphCell()
			cell.setValuesForGraph([presenter.previousMonthExpenses, presenter.currentMonthExpenses])
			cell.setTitle(presenter.currentMonthExpenses.total.string())
			return cell
		case Sections.bills.rawValue:
			let item = presenter.currentMonthExpenses.bills[indexPath.row]
			let cell = tableView.dequeueReusableCell(withIdentifier: Sections.bills.reuseId, for: indexPath) as! ExpenditureCell
			configureCell(cell, with: item)
			return cell
		case Sections.subscriptions.rawValue:
			let item = presenter.currentMonthExpenses.subscriptions[indexPath.row]
			let cell = tableView.dequeueReusableCell(withIdentifier: Sections.subscriptions.reuseId, for: indexPath) as! ExpenditureCell
			configureCell(cell, with: item)
			return cell
		default:
			fatalError("Section \(indexPath.section) not implemented")
		}
	}
	
	private func configureCell(_ cell: ExpenditureCell, with model: Expenditure) {
		cell.setMerchant(model.merchantName)
		cell.setAmount(model.lastTransactionAmount)
		cell.setLastDeltaAmount(model.transactionDeltaAmount)
		cell.setImage(model.merchantNameAbbreviation.image())
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch indexPath.section {
		case Sections.graph.rawValue:
			return 220
		default:
			return 70
		}
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case Sections.bills.rawValue:
			return "Bills"
		case Sections.subscriptions.rawValue:
			return "Subscriptions"
		default:
			return nil
		}
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if indexPath.section == Sections.graph.rawValue,
		   let cell = cell as? GraphCell {
			addChild(cell.dashboardViewController)
			cell.dashboardViewController.didMove(toParent: self)
		}
	}
	
	func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if indexPath.section == Sections.graph.rawValue,
		   let cell = cell as? GraphCell {
			cell.dashboardViewController.willMove(toParent: nil)
			cell.dashboardViewController.removeFromParent()
		}
	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		if section == 2 {
			return UIView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.width, height: 0)))
		}
		return nil
	}
}

