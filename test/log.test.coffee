should = require( "should" )
assert = require( "assert" )
hconf = require( "hconf" )( module : module, files : [ __dirname ] )

describe "log", ->

  it "create log entry", ( done ) ->
    hconf.then ->
      Log = require( '../index' )( module : module )
      Log.then ->
        Log.i "test"
        setTimeout done, 10
    .fail done
    .done()

