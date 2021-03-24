import React from "react";
import { Container, Row, Col } from "reactstrap";

// import Header from "./Header";
import Clients from "./Clients";

const Pave = () => (
  <Container fluid className="p-0">
    {/* <Header /> */}
    <Row>
      <Col lg="12" className="d-flex">
        <Clients />
      </Col>
    </Row>
  </Container>
);

export default Pave;
