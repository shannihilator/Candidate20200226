import React from 'react'
import {fetchCharacterCountData} from '../actions/AsyncActions'

// component for CharacterCountButton
export const CharacterCountButton = (props) => {
  const handleClick = () => {
    fetchCharacterCountData().then(resp => {
      console.log(resp);
      props.onClick(resp.response);
    })
  };
  return (
    <button onClick={handleClick}>Character Count Button</button>
  );
};

// class component for CharacterCountRow
class CharacterCountRow extends React.Component {
  render() {
    const character = this.props;
    return (
      <tr>
        <td> {character.letter}</td>
        <td> {character.count}</td>
      </tr>
    );
  }
}

// component for CharacterCountTable
export const CharacterCountTable = (props) => {
  return (
    <table>
      <thead>
      <tr>
        <th>
          Character
        </th>
        <th>
          Count
        </th>
      </tr>
      </thead>
      <tbody>
      {props.characterCountArr.map(character => <CharacterCountRow id={character.letter} {...character}/>)}
      </tbody>
    </table>
  );
};

// class component for CharacterCountTable
export class CharacterCountDisplay extends React.Component {
  // initialize class variables
  constructor(props) {
    super(props);
    this.state = { characterCountArr: [] };
    this.addCharacterCount = this.addCharacterCount.bind(this);
  }

  // function to set new state on event
  addCharacterCount(characterCountData){
    this.setState(prevState => ({
      characterCountArr: [...prevState.characterCountArr, ...characterCountData],
    }));
  }

  render() {
    return (
        <div>
          <CharacterCountButton onClick={this.addCharacterCount} />
          <CharacterCountTable characterCountArr={this.state.characterCountArr}/>
        </div>
    )
  }
};
