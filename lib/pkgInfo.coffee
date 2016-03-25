path = require( 'path' )
fs = require( 'fs' )
Q = require 'q'

find = ( pmodule, dir, defer ) ->
  dir = path.dirname( pmodule.filename or pmodule.id ) unless dir?

  defer = Q.defer() unless defer?
  defer.reject new Error( "Could not find package.json up from " + (pmodule.filename or pmodule.id) ) if dir is path.sep
  defer.reject new Error( 'Cannot find package.json from unspecified directory' ) if !dir or dir is "."

  filePath = path.join( dir, 'package.json' )
  fs.stat filePath, ( err, stats ) ->
    if stats and stats.isFile()
      try
        contents = require filePath
      catch error
        defer.reject error

      defer.resolve pkgInfo : contents, pkgInfoDir : dir
    else
      find pmodule, path.dirname( dir ), defer

  defer.promise

module.exports = ( pmodule, dir ) ->
  find pmodule, dir
