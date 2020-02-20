import React from 'react'
import {fetchPeopleData} from '../actions/AsyncActions'
import styled from 'styled-components'

const FlexItem = styled.div`
  display: flex;
`;

//  component for PersonRow
class PersonRow extends React.Component {
  render() {
    const person = this.props;
    return (
      <tr>
        <td> {person.first_name} {person.last_name}</td>
        <td> {person.email_address}</td>
        <td> {person.title} </td>
      </tr>
    );
  }
}

//  component for PeopleTable
export const PeopleTable = (props) => {
  return (
    <table>
      <thead>
      <tr>
      <th>
        Name
      </th>
      <th>
        Email
      </th>
      <th>
        Title
      </th>
      </tr>
      </thead>
      <tbody>
        {props.people.map(person => <PersonRow key={person.id} {...person}/>)}
      </tbody>
    </table>
  );
};

// class component for DuplicateDisplay
export class PeopleDisplay extends React.Component {
  // initialize class variables
  constructor(props) {
    super(props);
    this.state = {people: []};
    this.addPeople = this.addPeople.bind(this);
  }

  // // function to set new state on function call
  addPeople(peopleData) {
    this.setState(prevState => ({
      people: [...prevState.people, ...peopleData],
    }));
  };

  // retrieve data on ComponentMount
  componentDidMount() {
    fetchPeopleData().then(resp => {
          console.log(resp);
          this.addPeople(resp.response_data.data);
        });
  }

  render() {
    return (
      <FlexItem>
          <PeopleTable people={this.state.people}/>
      </FlexItem>
    )
  }
};


