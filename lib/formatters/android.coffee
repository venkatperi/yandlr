moment = require 'moment'
strRight = require "underscore.string/strRight"
strLeft = require "underscore.string/strLeft"
colors = require "colors/safe"
_colors = require "../utils/colors"
conf = require "../conf"

conf.get( "yandlr.colors" ).then ( c ) -> _colors = c

module.exports = ( format ) -> ( opt ) ->
  format = {} unless format?
  l = opt.level.substr( 0, 1 ).toUpperCase()

  timestamp = format.timestamp or "MM-DD-HH:mm:ss:SSS"
  ts = moment().format( timestamp )

  msg = opt.msg or opt.message
  msg = strLeft msg, "undefined"
  prefix = [ "#{l}/#{ts} " ]
  tag = opt.tag or opt.label

  if tag?
    prefix.push "[#{tag}]"
  else
    parts = msg.split "] "
    if parts.length > 1
      tag = parts[ 0 ]
      msg = parts[ 1..-1 ].join "] "
      prefix.push = "#{tag}]"
    else
      prefix.push "-"

  prefix = prefix.join ""

  line = []
  if opt.colorize
    color = _colors[ opt.level ]
    line.push colors[ color ]( prefix )
  else
    line.push prefix
  line.push " "
  line.push msg
 
  output = [ line.join "" ]

  #output.push "#{JSON.stringify( opt.meta, null, 2 )}" if opt.meta? and not _.isEmpty opt.meta

  output.join '\n'
