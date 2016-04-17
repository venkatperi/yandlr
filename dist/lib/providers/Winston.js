var Provider, Winston, addLogger, conf, container, formatter, winston, _, _loggers,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Provider = require('./Provider');

winston = require('winston');

formatter = require("../formatters/android");

_ = require("underscore");

_.mixin(require('underscore.deep'));

conf = require("../conf");

container = new winston.Container;

_loggers = void 0;

conf.get("yandlr.loggers").then(function(loggers) {
  _loggers = _.deepClone(loggers);
  return Object.keys(_loggers).forEach(function(k) {
    return addLogger(k);
  });
});

addLogger = function(id, name) {
  var e, logger;
  if (name == null) {
    name = id;
  }
  logger = _.deepClone(_loggers[id]);
  Object.keys(logger).forEach(function(l) {
    logger[l].formatter = formatter(logger[l]);
    return logger[l].label = name;
  });
  try {
    return container.add(name, logger);
  } catch (_error) {
    e = _error;
    console.log(e);
    throw e;
  }
};

module.exports = Winston = (function(_super) {
  __extends(Winston, _super);

  function Winston(opts) {
    if (opts == null) {
      opts = {};
    }
    this.getOrCreate = __bind(this.getOrCreate, this);
    this.log = __bind(this.log, this);
    this.get = __bind(this.get, this);
    this.add = __bind(this.add, this);
    Winston.__super__.constructor.call(this, opts);
  }

  Winston.prototype.add = function(name, opts) {
    return container.add(name, opts);
  };

  Winston.prototype.get = function(name) {
    return this.getOrCreate(name);
  };

  Winston.prototype.log = function(opts) {
    throw new Error("not implemented");
  };

  Winston.prototype.getOrCreate = function(name) {
    var match;
    if (container.has(name)) {
      return container.get(name);
    }
    match = void 0;
    Object.keys(_loggers).forEach(function(id) {
      if (name.indexOf(id) === 0 && (!match || id.length > match.length)) {
        return match = id;
      }
    });
    if (match == null) {
      match = "root";
    }
    return addLogger(match, name);
  };

  return Winston;

})(Provider);
