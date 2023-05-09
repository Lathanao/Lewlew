cells.map( cell => 


  Object.values(cell).forEach(element => `
      
      <tr>${element}</tr>
      
      `)


    
  ).join('\n')




  Object.values(cell).forEach(element => {
      
    let a = 5;
    console.log(a);
    return `
     
      <td>${a}</td>
      
      `})

  