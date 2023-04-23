/* eslint-disable no-new-func */
/**
 * Interpolate a tagged template literal from the inputs
 *
 * @param {*} template the template literal string
 * @param {*} [tags] the tagged values in the template
 * @returns the template output with the tagged literals applied
 */
export function interpolateRow(template, tags = {}) {
  const keys = Object.keys(tags);
  const values = Object.values(tags);
  console.log('------------ interpolateRow ----------------')
  console.log(values)
  console.log(template)
  const tr = "cells";

  try {
    return new Function(tr, `return \`${template}\`;`)(values);
  } catch (e) {
    throw new TemplateException(template, tags, e);
  }
}

/**
 * @private
 */
class TemplateException extends Error {
  constructor(template, tags, message) {
    super();
    this.name = "TemplateError";
    let msg = "\n------------------\n";
    msg += `Template: \`${template}\``;
    msg += "\n------------------\n";
    msg += `Tags: ${JSON.stringify(tags, null, 2)}`;
    msg += "\n------------------\n";
    msg += message;
    this.message = msg;
  }
}
