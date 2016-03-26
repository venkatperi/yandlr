winston = require( "winston" )
path = require 'path'
moment = require 'moment'
strRight = require "underscore.string/strRight"
strLeft = require "underscore.string/strLeft"
conf = require "./conf"
pkgInfo = require "./pkgInfo"
Q = require 'q'
colors = require "colors/safe"


class Log

  constructor : ( @callingModule, @level = "info", @subTag ) ->
    @ready = @makeTag()
    @ready.then ( tag ) =>
      @TAG = tag
      @TAG += "-#{@subTag}" if @subTag?

  global : ( opts = {} ) =>
    conf.overrides opts

  init : ( opt = {} ) ->
    @level = opt.level if opt.level?
    transports = [ new winston.transports.Console( colorize : true ) ]
    @logger = new winston.Logger
      transports : transports
      level : @level or conf.get( "logger:level" )

  makeTag : =>
    defer = Q.defer()
    pkgInfo( @callingModule ).then ( pkg ) =>
      filename = @callingModule.filename
      basePath = pkg.pkgInfoDir
      dir = path.dirname filename
      baseName = path.parse( filename ).name
      tag = path.join dir, baseName
      tag = strRight tag, basePath
      tag = strRight tag, '/'
      defer.resolve "#{pkg.pkgInfo.name}:#{tag}"
    .fail ( err ) =>
      defer.reject err

    defer.promise

  log : ( level, msg, meta ) =>
    @ready.then =>
      @init() unless logger?
      @logger.log level, "[#{@TAG}] #{msg}", meta

  v : ( msg, meta ) => @log 'verbose', msg, meta
  verbose : ( msg, meta ) => @log 'verbose', msg, meta
  d : ( msg, meta ) => @log 'debug', msg, meta
  debug : ( msg, meta ) => @log 'debug', msg, meta
  i : ( msg, meta ) => @log 'info', msg, meta
  info : ( msg, meta ) => @log 'info', msg, meta
  e : ( msg, meta ) => @log 'error', msg, meta
  error : ( msg, meta ) => @log 'error', msg, meta
  w : ( msg, meta ) => @log 'warn', msg, meta
  warn : ( msg, meta ) => @log 'warn', msg, meta
  f : ( msg, meta ) => @log 'fatal', msg, meta
  fatal : ( msg, meta ) => @log 'fatal', msg, meta

winston.transports.Console.prototype.log = ( level, msg, meta, callback ) ->
  return callback( null, true )  if @silent
  self = this
  l = level.substr( 0, 1 ).toUpperCase()
  ts = moment().format( "MM-DD-HH:mm:ss:SSS" )
  msg = strLeft msg, "undefined"
  parts = msg.split "] "
  tag = parts[ 0 ]
  msg = parts[ 1..-1 ].join "] "
  prefix = "#{l}/#{ts} #{tag}]"

  _colors = conf.get "logger:colors"
  color = _colors[ level ]
  line = [ colors[ color ]( prefix ), " ", msg ]
  output = [ line.join "" ]

  #  if options.logMeta
  #    output.push "#{JSON.stringify( meta, null, 2 )}" if meta? and not _.isEmpty meta

  output = output.join '\n'
  console.log output

  self.emit "logged"
  callback null, true

module.exports = ( module, level, subTag ) -> new Log( module, level, subTag )


