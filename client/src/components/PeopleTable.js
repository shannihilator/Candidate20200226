import React from 'react'
import {fetchPeopleData } from '../actions/AsyncActions'

// PeopleButton Component
export const PeopleButton =  () => {
  // function to handleButton Click
  const handleClick = () => {
    fetchPeopleData().then(resp => {
      console.log(resp);
    })
  };
  return (
    <button onClick={handleClick}>People Button</button>
  );
};

