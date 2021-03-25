import React, {useState} from "react";


import {
  Card,
  CardBody,
  CardHeader,
  CardTitle,
  Col,
  Container,
  Row,
} from "reactstrap";

import BootstrapTable from "react-bootstrap-table-next";
import paginationFactory from "react-bootstrap-table2-paginator";
import ToolkitProvider, { Search } from 'react-bootstrap-table2-toolkit';

import users from '../../../data/users.json';
import Single from './Single';

const tableColumns = [
  {
    dataField: "userId",
    text: "UserId",
    sort: true
  },
  {
    dataField: "name",
    text: "Name",
    sort: true
  },
];

const ClientsList = (props) => {
  const selectRow = {
    mode: "radio",
    clickToSelect: true,
    bgColor: "#f8f9fa",
    onSelect: (row, isSelect, rowIndex, e) => {
      props.onClientSelected(row.userId)
    }
  };
  const {SearchBar} = Search;

  return (
  
  <Card className="sticky-top">
    <CardHeader>
      <CardTitle tag="h5" className="mb-0">
        Clients
      </CardTitle>
    </CardHeader>
    <CardBody>
        <ToolkitProvider
          keyField="name"
          bootstrap4
          bordered={false}
          data={users}
          columns={tableColumns}
          search
        >
          {
            props => (
              <div>
                <SearchBar { ...props.searchProps } />
                <BootstrapTable
                  bootstrap4
                  bordered={false}
                  selectRow={selectRow}
                  pagination={paginationFactory({
                    sizePerPage: 10,
                    sizePerPageList: [5, 10, 25, 50]
                  })}
                  { ...props.baseProps }

                />
              </div>
            )
          }
        </ToolkitProvider>
    </CardBody>
  </Card>
  );
};


const Clients = () => {
  const [clientId, setClientId] = useState(0);

  const onClientSelected = (clientId) => {
    setClientId(clientId)
  }

  return (
    <Container fluid className="p-0">
      <Row>
        <Col xl="4">
          <ClientsList 
            onClientSelected={onClientSelected}
          />
        </Col>
        <Col xl="8">
          <Single 
            clientId={clientId}
          />
        </Col>
      </Row>
    </Container>
  )
};

export default Clients;
