import React from 'react'
import {fetchDuplicatesData} from '../actions/AsyncActions'


// component for DuplicateButton
export const DuplicateButton = (props) => {
  // function to handleButton Click
  const handleClick = () => {
    fetchDuplicatesData().then(resp => {
      props.onClick(resp.response);
    })
  };
  return (
    <button onClick={handleClick} disabled={props.disabled}>Duplicate Count Button</button>
  );
};

// class component for DuplicateRow
class DuplicateRow extends React.Component {
  render() {
    const duplicate = this.props;
    return (
      <tr>
        <td> {duplicate.original_email.email_address}</td>
        <td> {duplicate.duplicate_email.email_address}</td>
      </tr>
    );
  }
}

// component for DuplicateTable
export const DuplicateTable = (props) => {
  return (
    <table>
      <thead>
      <tr>
        <th>
          Original Email
        </th>
        <th>
          Duplicate
        </th>
      </tr>
      </thead>
      <tbody>
      {props.duplicateArr.map(duplicate => <DuplicateRow id={duplicate.original_email.username} {...duplicate}/>)}
      </tbody>
    </table>
  );
};

// class component for DuplicateDisplay
export class DuplicateDisplay extends React.Component {

  // initialize class variables
  constructor(props) {
    super(props);
    this.state = {duplicateArr: []};
    this.addDuplicateData = this.addDuplicateData.bind(this);
  }

  // function to set new state on event
  addDuplicateData(DuplicateData){
    this.setState(prevState => ({
      duplicateArr: [...prevState.duplicateArr, ...DuplicateData],
    }));
  }

  render() {
    return (
      <div>
        <DuplicateButton onClick={this.addDuplicateData}/>
        <DuplicateTable duplicateArr={this.state.duplicateArr}/>
      </div>
    )
  }
};
