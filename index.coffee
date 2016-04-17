Log = require "./lib/Log"
levels = require "./lib/utils/levels"

logger = new Log()
log = ( opts ) ->
  logger.init opts
  log

#for f in [ "then", "promiseDispatch" ]
#  log[ f ] = logger.ready[ f ]

for f in [ "log" ]
  log[ f ] = logger[ f ]

for l in levels
  log[ l ] = logger[ f ]
  log[ l[ 0 ] ] = logger[ l[ 0 ] ]

module.exports = log

  
  
  