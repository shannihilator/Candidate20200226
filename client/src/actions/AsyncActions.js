import * as actions from './Actions'

export const creds = { credentials: 'same-origin' };

export function fetchMe() {
  return dispatch => {
    return fetch('/api/me.json', creds).
      then(response => response.json()).
      then(me => dispatch(actions.receiveMe(me)));
  }
}

// export const fetchPeopleData = async() => {
//   const resp = await fetch('http://localhost:5000/api/v1/people');
//   const data = await resp.json();
//   console.log(data);
// };

// function that retrieves People Data Rails Api
export function fetchPeopleData() {
  return fetch('http://localhost:5000/api/v1/people', creds).
  then(resp => resp.json());
}
