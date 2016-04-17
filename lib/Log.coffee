path = require 'path'
conf = require "./conf"
moduletag = require "moduletag"
Queue = require "node-observable-queue"
#Provider = require "./providers/Console"
Provider = require "./providers/Winston"
Q = require 'q'
levels = require "./utils/levels"

global.__yandlr = {} unless global.__yandlr?
global.__yandlr.provider = new Provider()

module.exports = class Log
  constructor : ->
    @provider = global.__yandlr.provider
    @queue = new Queue()
    @initLevels()

  log : ( level, msg, meta ) =>
    @initialized.then =>
      @queue.enqueue level : level, msg : msg, meta : meta, tag : @TAG

  init : ( opts ) =>
    opts = {} unless opts?
    @initialize = Q.defer()
    @initialized = @initialize.promise

    @createTag opts
    .then =>
      conf.get "yandlr"
    .then =>
      @logger = @provider.get @TAG
      @queue.on "enqueue", @processQueue
      @initialize.resolve true
      @processQueue()

  processQueue : =>
    while item = @queue.dequeue()
      do ( item ) =>
        @actualLog item

  actualLog : ( item ) =>
    @logger.log item.level, item.msg

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


