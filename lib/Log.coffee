path = require 'path'
conf = require "./conf"
moduletag = require "moduletag"
Queue = require "node-observable-queue"
Provider = require "./providers/Console"
Q = require 'q'
levels = require "./utils/levels"

global.__yandlr = {} unless global.__yandlr?
global.__yandlr.provider = new Provider()

module.exports = class Log
  constructor : ->
    @ready = Q true
    @provider = global.__yandlr.provider
    @queue = new Queue()
    @initLevels()

  log : ( level, msg, meta ) =>
    @queue.enqueue level : level, msg : msg, meta : meta, tag : @TAG
    
  init : ( opts ) =>
    opts = {} unless opts?
    @ready = conf
    .then =>
      @createTag opts
    .then =>
      @queue.on "enqueue", @processQueue
      @processQueue()

  processQueue : =>
    while item = @queue.dequeue()
      do ( item ) =>
        @ready.then =>
          @actualLog item

  actualLog : ( item ) =>
    @provider.log item

  createTag : ( opts ) =>
    throw new Error "missing option: module" unless opts.module?
    moduletag opts.module
    .then ( tag ) =>
      @TAG = tag
      @TAG += "-#{opts.postfix}" if opts.postfix?

  initLevels : =>
    for l in levels
      do ( l ) =>
        @[ l[ 0 ] ] = @[ l ] = ( msg, meta ) => @log l, msg, meta


