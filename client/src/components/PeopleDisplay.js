import React from 'react'
import {fetchPeopleData } from '../actions/AsyncActions'

// PeopleButton Component
export const PeopleButton =  (props) => {
  // function to handleButton Click
  const handleClick = () => {
    //event.preventDefault();
    fetchPeopleData().then(resp => {
      console.log(resp);
      props.onClick(resp.response.data);
    })
  };
  return (
    <button onClick={handleClick}>People Button</button>
  );
};

class Person extends React.Component {
  render() {
    const person = this.props;
    return (
        <div className="info">
          <div className="name">{person.first_name} {person.last_name}</div>
          <div className="email_address">{person.email_address}</div>
          <div className="job_title">{person.title}</div>
        </div>
    );
  }
}

export const PeopleList = (props) => {
  //const person = this.props;
  return (
    <div>
      {props.people.map(person => <Person key={person.id} {...person}/>)}
    </div>
  );
};

export class PeopleDisplay extends React.Component {
  constructor(props) {
    super(props);
    this.state = {people: []};
    this.addPeople = this.addPeople.bind(this);
  }
  addPeople(peopleData){
    this.setState(prevState => ({
      people: [...prevState.people, ...peopleData],
    }));
  };
   render() {
     return (
       <div>
         <PeopleButton onClick={this.addPeople} />
         <PeopleList people={this.state.people} />
       </div>
     )
   }
};


