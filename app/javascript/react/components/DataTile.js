import React, { useState, useEffect } from 'react'

const DataTile = props => {
let currentPrice;

  if (props.data.length > 1) {
    currentPrice = props.data[1].p
    currentPrice.toFixed(2)
  }

  return (
    <div>
      Current Price:
      <h1>$ {currentPrice}</h1>
    </div>
  )
}

export default DataTile
