var colors, conf, moment, strLeft, strRight, _colors;

moment = require('moment');

strRight = require("underscore.string/strRight");

strLeft = require("underscore.string/strLeft");

colors = require("colors/safe");

_colors = require("../utils/colors");

conf = require("../conf");

conf.get("yandlr.colors").then(function(c) {
  return _colors = c;
});

module.exports = function(format) {
  return function(opt) {
    var color, l, line, msg, output, parts, prefix, tag, timestamp, ts;
    if (format == null) {
      format = {};
    }
    l = opt.level.substr(0, 1).toUpperCase();
    timestamp = format.timestamp || "MM-DD-HH:mm:ss:SSS";
    ts = moment().format(timestamp);
    msg = opt.msg || opt.message;
    msg = strLeft(msg, "undefined");
    prefix = ["" + l + "/" + ts + " "];
    tag = opt.tag || opt.label;
    if (tag != null) {
      prefix.push("[" + tag + "]");
    } else {
      parts = msg.split("] ");
      if (parts.length > 1) {
        tag = parts[0];
        msg = parts.slice(1).join("] ");
        prefix.push = "" + tag + "]";
      } else {
        prefix.push("-");
      }
    }
    prefix = prefix.join("");
    line = [];
    if (opt.colorize) {
      color = _colors[opt.level];
      line.push(colors[color](prefix));
    } else {
      line.push(prefix);
    }
    line.push(" ");
    line.push(msg);
    output = [line.join("")];
    return output.join('\n');
  };
};
