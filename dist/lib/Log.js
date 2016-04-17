var Log, Provider, Q, Queue, conf, levels, moduletag, path,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

path = require('path');

conf = require("./conf");

moduletag = require("moduletag");

Queue = require("node-observable-queue");

Provider = require("./providers/Winston");

Q = require('q');

levels = require("./utils/levels");

if (global.__yandlr == null) {
  global.__yandlr = {};
}

global.__yandlr.provider = new Provider();

module.exports = Log = (function() {
  function Log() {
    this.initLevels = __bind(this.initLevels, this);
    this.createTag = __bind(this.createTag, this);
    this.actualLog = __bind(this.actualLog, this);
    this.processQueue = __bind(this.processQueue, this);
    this.init = __bind(this.init, this);
    this.log = __bind(this.log, this);
    this.provider = global.__yandlr.provider;
    this.queue = new Queue();
    this.initLevels();
  }

  Log.prototype.log = function(level, msg, meta) {
    return this.initialized.then((function(_this) {
      return function() {
        return _this.queue.enqueue({
          level: level,
          msg: msg,
          meta: meta,
          tag: _this.TAG
        });
      };
    })(this));
  };

  Log.prototype.init = function(opts) {
    if (opts == null) {
      opts = {};
    }
    this.initialize = Q.defer();
    this.initialized = this.initialize.promise;
    return this.createTag(opts).then((function(_this) {
      return function() {
        return conf.get("yandlr");
      };
    })(this)).then((function(_this) {
      return function() {
        _this.logger = _this.provider.get(_this.TAG);
        _this.queue.on("enqueue", _this.processQueue);
        _this.initialize.resolve(true);
        return _this.processQueue();
      };
    })(this));
  };

  Log.prototype.processQueue = function() {
    var item, _results;
    _results = [];
    while (item = this.queue.dequeue()) {
      _results.push((function(_this) {
        return function(item) {
          return _this.actualLog(item);
        };
      })(this)(item));
    }
    return _results;
  };

  Log.prototype.actualLog = function(item) {
    return this.logger.log(item.level, item.msg);
  };

  Log.prototype.createTag = function(opts) {
    if (opts.module == null) {
      throw new Error("missing option: module");
    }
    return moduletag(opts.module).then((function(_this) {
      return function(tag) {
        _this.TAG = tag;
        if (opts.postfix != null) {
          return _this.TAG += "-" + opts.postfix;
        }
      };
    })(this));
  };

  Log.prototype.initLevels = function() {
    var l, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = levels.length; _i < _len; _i++) {
      l = levels[_i];
      _results.push((function(_this) {
        return function(l) {
          return _this[l[0]] = _this[l] = function(msg, meta) {
            return _this.log(l, msg, meta);
          };
        };
      })(this)(l));
    }
    return _results;
  };

  return Log;

})();
