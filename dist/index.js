var Log, f, l, levels, log, logger, _i, _j, _len, _len1, _ref;

Log = require("./lib/Log");

levels = require("./lib/utils/levels");

logger = new Log();

log = function(opts) {
  logger.init(opts);
  return log;
};

_ref = ["log"];
for (_i = 0, _len = _ref.length; _i < _len; _i++) {
  f = _ref[_i];
  log[f] = logger[f];
}

for (_j = 0, _len1 = levels.length; _j < _len1; _j++) {
  l = levels[_j];
  log[l] = logger[f];
  log[l[0]] = logger[l[0]];
}

module.exports = log;
