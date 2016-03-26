Conf = require 'node-conf'

opts =
  name : "nodelog"
  dirs :
    "factory" : "#{__dirname}/.."

conf = Conf( opts )

module.exports = conf


