${fullstat
  .map( column => {

      let list_header = ''
      let list_table = ''

      Object.keys(column).forEach(field => {
        list_header += ${field} + ' '
      })

      Object.values(column).forEach(field => {
        Object.keys(field).forEach(key => {
          list_table += ${key} + ' ' + ${element[key]};
        })
      }) 
    
      return list_header + ' ' + list_table
      
    }
  )
  .join('\n')}