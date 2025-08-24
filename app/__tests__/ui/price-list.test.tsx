import React from 'react';
import { render } from '@testing-library/react-native';
import PriceList from '../../PriceList';

describe('Price List UI', () => {
  it('should render an empty view', () => {
    const { toJSON } = render(<PriceList />);
    expect(toJSON()).toMatchSnapshot();
  });
});