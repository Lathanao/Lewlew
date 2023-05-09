/* eslint-disable no-new-func */
/**
 * Interpolate a tagged template literal from the inputs
 *
 * @param {*} template the template literal string
 * @param {*} [tags] the tagged values in the template
 * @returns the template output with the tagged literals applied
 */
export function interpolate(template, data = {}) {
  const keys = Object.keys(data)
  // const values = Object.values(data)
  // console.log("============= interpolate keys ==============")
  // console.log(keys)
  // console.log("============= interpolate data[keys] ==============")
  // console.log(data[keys])
  try {
    return new Function(keys, `return \`${template}\`;`)(data[keys])
  } catch (e) {
    throw new TemplateException(template, data[keys], e)
  }
}

/**
 * @private
 */
class TemplateException extends Error {
  constructor(template, data, message) {
    super()
    this.name = 'TemplateError'
    let msg = '\n------------------\n'
    msg += `Template: \`${template}\``
    msg += '\n------------------\n'
    msg += `Data: ${JSON.stringify(data, null, 2)}`
    msg += '\n------------------\n'
    msg += message
    this.message = msg
  }
}
