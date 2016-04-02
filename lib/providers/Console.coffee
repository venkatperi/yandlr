Provider = require './Provider'
formatter = require "../formatters/android"

module.exports = class Console extends Provider
  constructor : ( opts = {} ) ->
    super opts

  add : ( opts ) =>

  log : ( opts ) =>
    console.log formatter(opts)
