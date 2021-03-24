import faker from 'faker';
import { map } from 'lodash';

  const tableData = map(new Array(60), () => {
      return {
        name: faker.fake("{{name.lastName}}, {{name.firstName}}"),
        position: faker.fake("{{name.jobTitle}}"),
        office: faker.fake("{{address.city}}"),
        age: faker.random.number({min:22, max: 65}),
        startDate: "2011/04/25",
        salary: faker.random.number({min:65000, max: 130000}),
      }
    })

const tableColumns = [
  {
    dataField: "name",
    text: "Name",
    sort: true
  },
];



export { tableData, tableColumns };
