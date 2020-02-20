import React from 'react'
import styled from 'styled-components'

import { ConnectedNavBar } from '../containers/ConnectedNavBar'
import { PeopleDisplay } from './PeopleDisplay'
import { CharacterCountDisplay } from "./CharacterCountDisplay";
import { DuplicateDisplay } from "./DuplicateDisplay";


const Page = styled.div`
  display: grid;
  grid-template 46px 1fr / 1fr;
  height: 100%;
  width: 100%;
`;

const FlexContainer = styled.div`
  display: flex;
  align-items: baseline;
  flex-direction: row;
  justify-content: space-evenly;
  padding: 0;
  margin: 0;
  list-style: none;
`;

export const LandingPage = () => (
  <Page>
    <ConnectedNavBar />
    <FlexContainer>
      <PeopleDisplay />
      <CharacterCountDisplay />
      <DuplicateDisplay />
    </FlexContainer>
  </Page>
);
