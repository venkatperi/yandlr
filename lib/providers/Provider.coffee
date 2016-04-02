module.exports = class Provider
  constructor : ( opts = {} ) ->

  add : ( opts ) =>
    throw new Error "virtual function called"

  log : ( opts ) =>
    throw new Error "virtual function called"
    