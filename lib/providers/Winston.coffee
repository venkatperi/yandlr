Provider = require './Provider'
winston = require 'winston'
formatter = require "../formatters/android"
_ = require "underscore"
_.mixin require 'underscore.deep'
conf = require "../conf"

container = new winston.Container

_loggers = undefined

conf.get "yandlr.loggers"
.then ( loggers ) ->
  _loggers = _.deepClone loggers
#  console.log JSON.stringify _loggers, null, 2
#  console.log loggers
  Object.keys( _loggers ).forEach ( k ) ->
    addLogger k

addLogger = ( id, name ) ->
  name = id unless name?
  logger = _.deepClone _loggers[ id ]
  Object.keys( logger ).forEach ( l ) ->
    logger[ l ].formatter = formatter logger[ l ]
    logger[ l ].label = name
  try
    container.add name, logger
  catch e
    console.log e
    throw e


module.exports = class Winston extends Provider

  constructor : ( opts = {} ) ->
    super opts

  add : ( name, opts ) =>
    container.add name, opts

  get : ( name ) =>
#    console.log "get logger: #{name}"
    @getOrCreate name

  log : ( opts ) =>
    throw new Error "not implemented"

  getOrCreate : ( name ) =>
    return container.get name if container.has name

    match = undefined
    Object.keys( _loggers ).forEach ( id ) ->
      if name.indexOf(id) is 0 and (!match or id.length > match.length)
        match = id

    match = "root" unless match?
#    console.log "matching #{name} -> #{match}"
    addLogger match, name

