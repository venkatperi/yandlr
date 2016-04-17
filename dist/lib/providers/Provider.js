var Provider,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

module.exports = Provider = (function() {
  function Provider(opts) {
    if (opts == null) {
      opts = {};
    }
    this.log = __bind(this.log, this);
    this.get = __bind(this.get, this);
    this.add = __bind(this.add, this);
  }

  Provider.prototype.add = function(opts) {
    throw new Error("virtual function called");
  };

  Provider.prototype.get = function(name) {
    return this;
  };

  Provider.prototype.log = function(opts) {
    throw new Error("virtual function called");
  };

  return Provider;

})();
