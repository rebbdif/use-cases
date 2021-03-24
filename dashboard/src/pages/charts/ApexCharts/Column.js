import React from "react";
import Chart from "react-apexcharts";
import { connect } from "react-redux";
import {map} from 'lodash';
import numeral from 'numeral'
const ColumnChart = ({ theme, recurringExpenditures }) => {

  const sourceData = recurringExpenditures ? recurringExpenditures : []
  const data = map(sourceData, (expenditure) => {
    return {
      name: expenditure.normalized_merchant_name,
      data: [expenditure.last_transaction_amount]
    }
  })
  
  const options = {
    plotOptions: {
      bar: {
        horizontal: false,
        columnWidth: "55%",
        borderRadius: 8,
      }
    },
    chart: {
      type: 'bar',
      stacked: true,
      toolbar: {
        show: true
      },
    },
    dataLabels: {
      enabled: false
    },
    stroke: {
      show: true,
      width: 2,
      colors: ["transparent"]
    },
    xaxis: {
      categories: [
        "Spending",
      ]
    },
    yaxis: {
      title: {
        text: "$"
      },
      labels: {
        formatter: function (value) {
          return numeral(value).format('$0,0.00a');
        }
      }
    },
    fill: {
      opacity: 1
    },
    tooltip: {
      y: {
        formatter: function(val) {
          return numeral(val).format('$0,0.00');
        }
      }
    },
    colors: [
      theme.primary,
      theme.success,
      theme.warning,
      theme.danger,
      theme.info
    ]
  };

  return (
    <div className="chart">
      <Chart options={options} series={data} type="bar" height="350" />
    </div>
  );
};

export default connect(store => ({
  theme: store.theme.currentTheme
}))(ColumnChart);
