should = require( "should" )
assert = require( "assert" )
hconf = require( "hconf" )( module : module, files : [ __dirname ] )
Log = require( '../index' )( module : module )

describe "log", ->

  it "create log entry", ( done ) ->
    Log.i "test"
    setTimeout done, 500

