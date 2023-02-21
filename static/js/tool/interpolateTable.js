/* eslint-disable no-new-func */
/**
 * Interpolate a tagged template literal from the inputs
 *
 * @param {*} template the template literal string
 * @param {*} [tags] the tagged values in the template
 * @returns the template output with the tagged literals applied
 */
 export function interpolateTable (template, datas = {}, column) {

  const keys = Object.keys(datas)
  const values = Object.values(datas)
  const headers = datas[0]
  const thvalues = []
  const trvalues = []
  const th = 'header'
  const tr = 'cells'

  // console.log('headers')
  // console.log(datas[0])
  // console.log(headers)



  // console.log('column')
  // console.log(column)

  // console.log('thvalues')
  // console.log(thvalues)

  datas.forEach(row => {
    for (var k in row) (column.indexOf(k) > -1) || delete row[k];
    trvalues.push(row)
  })

  Object.keys(datas[0]).forEach(key => {
    thvalues.push(key.charAt(0).toUpperCase() + key.slice(1))
  })

  try {
    return new Function(th, tr, `return \`${template}\`;`)(thvalues, trvalues)
  } catch (e) {
    throw new TemplateException(template, datas, e)
  }
}

/**
 * @private
 */
class TemplateException extends Error {
  constructor (template, datas, message) {
    super()
    this.name = 'TemplateError'
    let msg = '\n------------------\n'
    msg += `Template: \`${template}\``
    msg += '\n------------------\n'
    msg += `Datas: ${JSON.stringify(datas, null, 2)}`
    msg += '\n------------------\n'
    msg += message
    this.message = msg
  }
}