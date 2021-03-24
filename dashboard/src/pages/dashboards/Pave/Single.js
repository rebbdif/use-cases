import React, {useEffect, useState} from 'react';
import { connect } from "react-redux";
import numeral from 'numeral'
import { map } from 'lodash';
import {
  Card,
  CardBody,
  CardHeader,
  CardTitle,
  Col,
  Row,
} from "reactstrap";
import dayjs from 'dayjs'

import Loader from '../../../components/Loader';
import Column from '../../charts/ApexCharts/Column'
import Pie from '../../charts/ApexCharts/Pie'

import BootstrapTable from "react-bootstrap-table-next";
import paginationFactory from "react-bootstrap-table2-paginator";

import {fetchRecurringExpenditures} from '../../../redux/actions/apiActions'

const localizedFormat = require('dayjs/plugin/localizedFormat')
dayjs.extend(localizedFormat)

const ClientInfo = (props) => {
  return (
    <Card>
      <CardHeader>
        <h5 className="card-title mb-0">{props.title}</h5>
      </CardHeader>
      <CardBody className="my-2">
        <Row className="d-flex align-items-center mb-4">
          <Col xs="12">
            <h2 className="d-flex align-items-center mb-0 font-weight-light">
              {props.data}
            </h2>
          </Col>
        </Row>
      </CardBody>
    </Card>
  )
}

const ExpendituresTable = ({ recurringExpenditures, loading }) => {

  const [expenditureTableData, setExpenditureTableData] = useState([]);
  
  useEffect(() => {
   setExpenditureTableData(
     map(recurringExpenditures, (el, i) => {
        return {
          id: i,
          normalized_merchant_name: el.normalized_merchant_name,
          transaction_count: el.transaction_count,
          last_transaction_amount: el.last_transaction_amount,
          last_transaction_date: el.last_transaction_date,
          normalized_frequency: el.normalized_frequency,
        }
      }));
  }, [recurringExpenditures, loading]);


//   avg_period_days: 15.26
// iso_currency_code: "USD"
// last_transaction_amount: 110.87
// last_transaction_date: "2019-06-03"
// last_transaction_description: "USAA P&C EXT DES:AUTOPAY ID:XXXXX4284 INDN:O'BRIEN,SEAN,P CO ID:USAA-PC WEB"
// normalized_frequency: "biweekly"
// normalized_merchant_name: "USAA"
// previous_transaction_amount: 110.86
// previous_transaction_date: "2019-05-16"
// transaction_count: 40
// transaction_delta_amount: 0.010000000000005116
// transaction_delta_percent: 0.0001
  

const expenditureTableColumns = [
  {
    dataField: "id",
    text: "Transaction #",
    sort: true,
    hidden: true
  },
  {
    dataField: "normalized_merchant_name",
    text: "Merchant",
    sort: true
  },
  {
    dataField: "transaction_count",
    text: "Transaction Count",
    sort: true
  },
  {
    dataField: "last_transaction_date",
    text: "Last Date",
    sort: true,
    hidden: true
  },
  {
    dataField: "normalized_frequency",
    text: "Frequency",
    sort: true,
  },
  {
    dataField: "last_transaction_amount",
    text: "Last Transaction Amount",
    sort: true,
    align: 'right',
    headerAlign: 'right',
    formatter: (cell, row) => { return numeral(cell).format('$0,0.00')}
  },
  
]
  return (
      <BootstrapTable
        rowClasses="text-truncate"
        bootstrap4
        keyField="id"
        bordered={false}
        data={expenditureTableData}
        columns={ expenditureTableColumns }
        loading={loading}
        pagination={paginationFactory({
          sizePerPage: 10,
          sizePerPageList: [5, 10, 25, 50]
        })}
      />
  )
}

const Single = ({clientId, recurringExpenditures, dispatch}) => {
  useEffect(() => {
    if (clientId) {
      dispatch(fetchRecurringExpenditures(clientId))
    }
  }, [clientId, dispatch]);

  const loading = recurringExpenditures.isFetching;

  return (
    <>
    <Row>
      <Col lg="6" sm="6" xl="12" className="col-xxl-6">
        <ClientInfo title="First Transaction At" data={dayjs(recurringExpenditures.data.from).format("LL")}/>
      </Col>

      <Col lg="6" sm="6" xl="12" className="col-xxl-6">
        <ClientInfo title="Last Transaction At" data={dayjs(recurringExpenditures.data.to).format("LL")}/>
      </Col>
    </Row>
    <Card>
       <CardHeader>
        <CardTitle tag="h5">Expenditure Breakdown</CardTitle>
        <h6 className="card-subtitle text-muted">
          Cash Flow insights
        </h6>
      </CardHeader>

      <CardBody>
        
        {loading ? <Loader /> : (
        <>
        <Row>
          
          <Col lg="6">
            <Column 
              clientId={clientId}
              loading={loading}
              recurringExpenditures={recurringExpenditures.data.recurring_expenditures}
            />
          </Col>
          <Col lg="6">
            <Pie 
              clientId={clientId}
              loading={loading}
              recurringExpenditures={recurringExpenditures.data.recurring_expenditures}
            />
            
          </Col>
        </Row>
         <br />
         <br />
        <Row>
          <Col lg="12">
            <ExpendituresTable 
              clientId={clientId}
              loading={recurringExpenditures.isFetching}
              recurringExpenditures={recurringExpenditures.data.recurring_expenditures}
            />
          </Col>
        </Row>
        </>
        )}
    </CardBody>
    </Card>
    </>
  )
};

export default connect(store => ({
  recurringExpenditures: store.recurringExpenditures
}))(Single);