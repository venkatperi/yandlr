var Console, Provider, formatter,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Provider = require('./Provider');

formatter = require("../formatters/android");

module.exports = Console = (function(_super) {
  __extends(Console, _super);

  function Console(opts) {
    if (opts == null) {
      opts = {};
    }
    this.log = __bind(this.log, this);
    this.add = __bind(this.add, this);
    Console.__super__.constructor.call(this, opts);
  }

  Console.prototype.add = function(opts) {};

  Console.prototype.log = function(opts) {
    return console.log(formatter(opts));
  };

  return Console;

})(Provider);
