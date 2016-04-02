moment = require 'moment'
strRight = require "underscore.string/strRight"
strLeft = require "underscore.string/strLeft"
colors = require "colors/safe"
_colors = require "../utils/colors"

module.exports = ( opt ) ->
  l = opt.level.substr( 0, 1 ).toUpperCase()
  ts = moment().format( "MM-DD-HH:mm:ss:SSS" )
  msg = strLeft opt.msg, "undefined"
  prefix = [ "#{l}/#{ts} " ]
  if opt.tag?
    prefix.push = "[#{opt.tag}]"
  else
    parts = msg.split "] "
    if parts.length > 1
      tag = parts[ 0 ]
      msg = parts[ 1..-1 ].join "] "
      prefix.push = "#{tag}]"
    else
      prefix.push "-"

  prefix = prefix.join ""

  color = _colors[ opt.level ]
  line = [ colors[ color ]( prefix ), " ", msg ]
  output = [ line.join "" ]

  output.push "#{JSON.stringify( opt.meta, null, 2 )}" if opt.meta? and not _.isEmpty opt.meta

  output.join '\n'
