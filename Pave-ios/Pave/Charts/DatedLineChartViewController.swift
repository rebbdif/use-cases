import Charts
import UIKit


/// It's a struct that represents a value of dashboard
struct DashboardValue {
	var barName: String
	var barHeight: Double
}


/// View controller that manages graph
class DatedLineChartViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet var chartContainerView: UIView!
    @IBOutlet var chartView: LineChartView!
    @IBOutlet var titleLabel: UILabel!

    init() {
        super.init(nibName: "DatedLineChartViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		containerView.backgroundColor = .systemBackground
	}
	
	func setValues(_ bars: [DashboardValue]) {
		var dataEntry = [ChartDataEntry]()
		for i in 0..<bars.count {
			let entry = ChartDataEntry(x: Double(i), y: bars[i].barHeight)
			dataEntry.append(entry)
		}
		
		let line1 = LineChartDataSet(entries: dataEntry, label: "")
		line1.colors = [.red]
		line1.drawValuesEnabled = false
		line1.mode = .cubicBezier
		line1.circleRadius = 0
		line1.circleHoleRadius = 0
		line1.drawFilledEnabled = false
		line1.form = Legend.Form.none
		
		let data = LineChartData()
		data.addDataSet(line1)
		
		chartView.data = data
		
		let xaxis = chartView.xAxis
		xaxis.drawGridLinesEnabled = false
		xaxis.labelPosition = .bottom
		xaxis.labelCount = bars.count
		xaxis.valueFormatter = IndexAxisValueFormatter(values: bars.map {$0.barName})
		xaxis.granularity = 1.0
		xaxis.gridColor = .clear
		xaxis.forceLabelsEnabled = true
		xaxis.drawAxisLineEnabled = true
		
		chartView.leftAxis.drawGridLinesEnabled = false
		
		chartView.rightAxis.drawGridLinesEnabled = false
	}

}

