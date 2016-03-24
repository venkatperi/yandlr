winston = require( "winston" )
path = require 'path'
moment = require 'moment'
strRight = require "underscore.string/strRight"
strLeft = require "underscore.string/strLeft"
conf = require "./conf"

globalOpts = {}

class Log

  constructor : ( fileName ) ->
#    @TAG = Log.makeTag fileName
    @TAG = path.basename fileName
    @level = "info"

  @global : ( opts = {} ) ->
    globalOpts = opts

  init : ( opt = {} ) ->
    @level = opt.level if opt.level?
    transports = [ new winston.transports.Console ]
    @logger = new winston.Logger
      transports : transports
      level : globalOpts.level or @level or "info"

  @makeTag : ( filename ) =>
    basePath = path.dirname __filename
    dir = path.dirname filename
    tag = path.join dir, path.basename( filename, '.coffee' )
    tag = strRight tag, basePath
    strRight tag, '/'

  log : ( level, msg, meta ) =>
    @init() unless logger?
    @logger.log level, "[#{@TAG}] #{msg}", meta

  v : ( msg, meta ) => @log 'verbose', msg, meta
  d : ( msg, meta ) => @log 'debug', msg, meta
  i : ( msg, meta ) => @log 'info', msg, meta
  e : ( msg, meta ) => @log 'error', msg, meta
  w : ( msg, meta ) => @log 'warn', msg, meta
  f : ( msg, meta ) => @log 'fatal', msg, meta

winston.transports.Console.prototype.log = ( level, msg, meta, callback ) ->
  return callback( null, true )  if @silent
  self = this
  l = level.substr( 0, 1 ).toUpperCase()
  ts = moment().format( "MM-DD-HH:mm:ss:SSS" )
  msg = strLeft msg, "undefined"
  output = [ "#{l}/#{ts} #{msg}" ]

  #  if options.logMeta
  #    output.push "#{JSON.stringify( meta, null, 2 )}" if meta? and not _.isEmpty meta

  output = output.join '\n'
  console.log output

  self.emit "logged"
  callback null, true

module.exports = ( filename ) -> new Log( filename )


