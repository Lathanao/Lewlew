/* eslint-disable no-new-func */
/**
 * Interpolate a tagged template literal from the inputs
 *
 * @param {*} template the ES6 template literal string (https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals)
 * @param {*} Data Format must be:
      {"key_label": [
            {
                "attr1": "val1",
                "attr2": "val2"
            },
            {
                "attr1": "val3",
                "attr1": "val3"
            }
        ]
      }

 *   Easy to get with:
 *     app.json( map[string][]map[string]string ), 
 *   or with any structure maps like:
 *     app.json( map[string][]Struct{} ) 
 * 
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
