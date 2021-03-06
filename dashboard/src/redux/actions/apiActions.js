import {RECEIVE_RECURRING_EXPENSES, FETCH_RECURRING_EXPENSES} from '../constants'
import fetch from 'isomorphic-fetch'

// WARNING THIS IS NOT SAFE FOR PRODUCTION LEVEL CODE
// YOUR API KEY WILL BE EXPOSED IN THE BROWSER
const { REACT_APP_API_KEY, REACT_APP_API_ENDPOINT } = process.env; 
function requestExpendituresActions() {
  return {
    type: FETCH_RECURRING_EXPENSES
  }
}

function receiveExpendituresActions(json) {
  return {
    type: RECEIVE_RECURRING_EXPENSES,
    data: json,
    receivedAt: new Date()
  }
}

export function fetchRecurringExpenditures(userId) {
  const url = `${REACT_APP_API_ENDPOINT}/users/${userId}/recurring_expenditures`;

  return function(dispatch) {
    dispatch(requestExpendituresActions())
    const options = {
      method: 'GET',
      headers: {'x-api-key': REACT_APP_API_KEY}
    }

    fetch(url, options)
      .then((res) => res.json())
      .then((json) => {
        dispatch(receiveExpendituresActions(json))
      })
      .catch((err) => {
        console.error(err); // eslint-disable-line
      });
  }
}
