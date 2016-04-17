module.exports = class Provider
  constructor : ( opts = {} ) ->

  add : ( opts ) =>
    throw new Error "virtual function called"
    
  get: (name) =>
    @

  log : ( opts ) =>
    throw new Error "virtual function called"
    