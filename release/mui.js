

/***  polyfills/bind  ***/

Function.prototype.bind = Function.prototype.bind || function(to){
  var partial = Array.prototype.splice.call(arguments, 1);
  var fn  = this;
  var bound = function (){
    var args = partial.concat(Array.prototype.splice.call(arguments, 0));
    if (!(this instanceof bound)){
      return fn.apply(to, args);
    }
    fn.apply(this, args);
  }
  bound.prototype = fn.prototype;
  return bound;
};


/***  polyfills/click  ***/

if(!HTMLElement.prototype.click){
  HTMLElement.prototype.click = function(){
    var event = document.createEvent("MouseEvent");
    event.initEvent('click', true, true);
    this.dispatchEvent(event);
    return event;
  };
}
;


/***  polyfills/console  ***/

if (window.console == null) {
  window.console = {
    log: function() {},
    warn: function() {},
    info: function() {}
  };
}
;


/***  polyfills/extensions  ***/

// Adds / Removes attribute

Element.prototype.toggleAttribute = function(attr, value) {
  var state;

  state = !this.hasAttribute(attr);
  if (value !== void 0) {
    state = !!value;
  }
  if (state) {
    return this.setAttribute(attr, 'true');
  } else {
    return this.removeAttribute(attr);
  }
};

// Get the parent ancestor by tagname
getParent = function(el, tagName) {
  if (el.tagName === tagName.toUpperCase()) {
    return el;
  }
  if (el.parentNode) {
    if (el.parentNode.tagName === tagName.toUpperCase()) {
      return el.parentNode;
    } else {
      return getParent(el.parentNode, tagName);
    }
  } else {
    return null;
  }
};

// Action event (click / touchend)
if(!HTMLElement.prototype.action){
  HTMLElement.prototype.action = function(){
    if(!!('ontouchstart' in window)){
      var event = document.createEvent("UIEvent");
      event.initEvent('touchend', true, true);
      this.dispatchEvent(event);
      return event;
    }else{
      this.click()
    }
  };
}

// Class setters / getters
Object.defineProperties(Function.prototype, {
  property: {
    value: function(property, descriptor) {
      descriptor.configurable = true;
      descriptor.enumerable = true;
      return Object.defineProperty(this.prototype, property, descriptor);
    }
  },
  get: {
    value: function(property, fn) {
      var descriptor;
      descriptor = Object.getOwnPropertyDescriptor(this.prototype, property);
      if (descriptor) {
        descriptor.get = fn;
      } else {
        descriptor = {
          get: fn
        };
      }
      return this.property(property, descriptor);
    }
  },
  set: {
    value: function(property, fn) {
      var descriptor;
      descriptor = Object.getOwnPropertyDescriptor(this.prototype, property);
      if (descriptor) {
        descriptor.set = fn;
      } else {
        descriptor = {
          set: fn
        };
      }
      return this.property(property, descriptor);
    }
  }
});

// Point class
Point = (function() {
  function Point(x, y) {
    this.x = x;
    this.y = y;
  }
  Point.prototype.diff = function(point) {
    return new Point(this.x - point.x, this.y - point.y);
  };
  return Point;
})();

// Gets the position as Point
Element.prototype.getPosition = function() {
  var rect;
  rect = getComputedStyle(this);
  return new Point(parseInt(rect.left), parseInt(rect.top) + window.scrollY);
};

// Limits the number between two bounds
Number.prototype.clamp = function(min, max) {
  var val;
  min = parseFloat(min);
  max = parseFloat(max);
  val = this.valueOf();
  if (val > max) {
    return max;
  } else if (val < min) {
    return min;
  } else {
    return val;
  }
};

// Limits the number between two bounds and returns remainder
Number.prototype.clampRange = function(min, max) {
  var val;
  min = parseFloat(min);
  max = parseFloat(max);
  val = this.valueOf();
  if (val > max) {
    return val % max;
  } else if (val < min) {
    return max - Math.abs(val % max);
  } else {
    return val;
  }
};


/***  polyfills/matches-selector  ***/

this.Element && function(ElementPrototype) {
  ElementPrototype.matchesSelector = ElementPrototype.matchesSelector ||
  ElementPrototype.mozMatchesSelector ||
  ElementPrototype.msMatchesSelector ||
  ElementPrototype.oMatchesSelector ||
  ElementPrototype.webkitMatchesSelector ||
  function (selector) {
    var node = this, nodes = (node.parentNode || node.document).querySelectorAll(selector), i = -1;
    while (nodes[++i] && nodes[i] != node);
    return !!nodes[i];
  };
}(Element.prototype);


/***  polyfills/request-animation-frame  ***/

(function() {
    var lastTime = 0;
    var vendors = ['webkit', 'moz'];
    for(var x = 0; x < vendors.length && !window.requestAnimationFrame; ++x) {
        window.requestAnimationFrame = window[vendors[x]+'RequestAnimationFrame'];
        window.cancelAnimationFrame =
          window[vendors[x]+'CancelAnimationFrame'] || window[vendors[x]+'CancelRequestAnimationFrame'];
    }

    if (!window.requestAnimationFrame)
        window.requestAnimationFrame = function(callback, element) {
            var currTime = new Date().getTime();
            var timeToCall = Math.max(0, 16 - (currTime - lastTime));
            var id = window.setTimeout(function() { callback(currTime + timeToCall); },
              timeToCall);
            lastTime = currTime + timeToCall;
            return id;
        };

    if (!window.cancelAnimationFrame)
        window.cancelAnimationFrame = function(id) {
            clearTimeout(id);
        };
}());


/***  polyfills/scroll-y  ***/

if (!('scrollY' in window)) {
  Object.defineProperty(window, 'scrollY', {
    get: function() {
      if (document.documentElement) {
        return document.documentElement.scrollTop;
      }
    }
  });
}
;


/***  core/ui  ***/

var UI;

UI = {
  verbose: false,
  namespace: 'ui',
  version: '0.1.0-RC1',
  load: function(base) {
    var el, key, value, _i, _len, _ref;
    if (base == null) {
      base = document;
    }
    for (key in UI) {
      value = UI[key];
      if (value.SELECTOR) {
        _ref = base.querySelectorAll(value.SELECTOR());
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          el = _ref[_i];
          if (el._processed) {
            continue;
          }
          this.load(el);
          value.wrap(el);
        }
      }
    }
    return setTimeout(function() {
      return document.body.setAttribute('loaded', true);
    }, 1000);
  },
  initialize: function() {
    var _this = this;
    document.addEventListener('DOMNodeInserted', this._insert.bind(this));
    return window.addEventListener('load', function() {
      return _this.load();
    });
  },
  _insert: function(e) {
    var tag, tagName, _base;
    if (!e.target.tagName) {
      return;
    }
    tagName = e.target.tagName;
    if (!tagName.match(/^UI-/)) {
      return;
    }
    tag = tagName.split("-").pop().toLowerCase().replace(/^\w|\s\w/g, function(match) {
      return match.toUpperCase();
    });
    if (!this[tag]) {
      return;
    }
    if (!e.target._processed) {
      return this[tag].wrap(e.target);
    } else {
      return typeof (_base = e.target).onAdded === "function" ? _base.onAdded() : void 0;
    }
  },
  _geather: function(obj) {
    var desc, key, proto, ret, _i, _len, _ref, _ref1;
    ret = {};
    _ref = Object.keys(obj);
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      key = _ref[_i];
      ret[key] = Object.getOwnPropertyDescriptor(obj, key);
    }
    if ((proto = Object.getPrototypeOf(obj)) !== Object.prototype) {
      _ref1 = this._geather(proto);
      for (key in _ref1) {
        desc = _ref1[key];
        if (ret[key] == null) {
          ret[key] = desc;
        }
      }
    }
    return ret;
  }
};

window.UI = UI;

if (!!('ontouchstart' in window)) {
  UI.Events = {
    action: 'touchend',
    dragStart: 'touchstart',
    dragMove: 'touchmove',
    dragEnd: 'touchend',
    enter: 'touchstart',
    leave: 'touchend',
    input: 'input',
    beforeInput: 'keydown',
    blur: 'blur',
    keypress: 'keypress',
    keyup: 'keyup'
  };
} else {
  UI.Events = {
    action: 'click',
    dragStart: 'mousedown',
    dragMove: 'mousemove',
    dragEnd: 'mouseup',
    enter: 'mouseover',
    leave: 'mouseout',
    input: 'input',
    beforeInput: 'keydown',
    blur: 'blur',
    keypress: 'keypress',
    keyup: 'keyup'
  };
}
;


/***  core/abstract  ***/

UI.Abstract = (function() {
  function Abstract() {}

  Abstract.get('disabled', function() {
    return this.hasAttribute('disabled');
  });

  Abstract.set('disabled', function(value) {
    return this.toggleAttribute('disabled', !!value);
  });

  Abstract.SELECTOR = function() {
    return UI.namespace + "-" + this.TAGNAME;
  };

  Abstract.wrap = function(el) {
    var desc, key, _ref, _ref1;
    _ref = UI._geather(this.prototype);
    for (key in _ref) {
      desc = _ref[key];
      if (key === 'initialize' || key === 'constructor') {
        continue;
      }
      Object.defineProperty(el, key, desc);
    }
    el._processed = true;
    if ((_ref1 = this.prototype.initialize) != null) {
      _ref1.call(el);
    }
    if (el.parentNode) {
      return typeof el.onAdded === "function" ? el.onAdded() : void 0;
    }
  };

  Abstract.create = function() {
    var base;
    base = document.createElement(this.SELECTOR());
    this.wrap(base);
    return base;
  };

  Abstract.prototype.fireEvent = function(type, data) {
    var event, key, value;
    if (typeof type !== 'string') {
      throw "No type specified";
    }
    event = document.createEvent("HTMLEvents");
    event.initEvent(type, true, true);
    for (key in data) {
      value = data[key];
      event[key] = value;
    }
    this.dispatchEvent(event);
    return event;
  };

  Abstract.prototype.toString = function() {
    return "<" + (this.tagName.toLowerCase()) + ">";
  };

  return Abstract;

})();


/***  components/ui-button  ***/

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

UI.Button = (function(_super) {
  __extends(Button, _super);

  function Button() {
    _ref = Button.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Button.TAGNAME = 'button';

  Button.get('label', function() {
    return this.textContent;
  });

  Button.set('label', function(value) {
    return this.textContent = value;
  });

  Button.get('type', function() {
    return this.getAttribute('type') || 'default';
  });

  Button.set('type', function(value) {
    if (!value) {
      return this.removeAttribute('type');
    }
    return this.setAttribute('type', value);
  });

  Button.prototype._cancel = function(e) {
    if (!this.disabled) {
      return;
    }
    e.stopImmediatePropagation();
    return e.stopPropagation();
  };

  Button.prototype.initialize = function() {
    return this.addEventListener(UI.Events.action, this._cancel);
  };

  return Button;

})(UI.Abstract);


/***  core/i-checkable  ***/

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

UI.iCheckable = (function(_super) {
  __extends(iCheckable, _super);

  function iCheckable() {
    _ref = iCheckable.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  iCheckable.get('value', function() {
    return this.hasAttribute('checked');
  });

  iCheckable.set('value', function(value) {
    return this.checked = value;
  });

  iCheckable.get('checked', function() {
    return this.hasAttribute('checked');
  });

  iCheckable.set('checked', function(value) {
    if (this.checked === value) {
      return;
    }
    this.toggleAttribute('checked', !!value);
    return this.fireEvent('change');
  });

  iCheckable.prototype._toggle = function() {
    if (this.parentNode.hasAttribute('disabled') || this.disabled) {
      return;
    }
    return this.toggle();
  };

  iCheckable.prototype.toggle = function() {
    return this.checked = !this.checked;
  };

  iCheckable.prototype.initialize = function() {
    return this.addEventListener(UI.Events.action, this._toggle);
  };

  return iCheckable;

})(UI.Abstract);


/***  components/ui-checkbox  ***/

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

UI.Checkbox = (function(_super) {
  __extends(Checkbox, _super);

  function Checkbox() {
    _ref = Checkbox.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Checkbox.TAGNAME = 'checkbox';

  return Checkbox;

})(UI.iCheckable);


/***  core/i-input  ***/

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

UI.iInput = (function(_super) {
  __extends(iInput, _super);

  function iInput() {
    _ref = iInput.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  iInput.get('value', function() {
    return this.textContent;
  });

  iInput.set('value', function(value) {
    return this.textContent = value;
  });

  iInput.get('placeholder', function() {
    return this.getAttribute('placeholder');
  });

  iInput.set('placeholder', function(value) {
    return this.setAttribute('placeholder', value);
  });

  iInput.get('disabled', function() {
    return this.hasAttribute('disabled');
  });

  iInput.set('disabled', function(value) {
    this.toggleAttribute('disabled', !!value);
    return this.toggleAttribute('contenteditable', !value);
  });

  iInput.prototype.cleanup = function() {
    this.normalize();
    if (this.childNodes.length !== 1) {
      return;
    }
    if (this.childNodes[0].tagName === 'BR') {
      return this.removeChild(this.childNodes[0]);
    } else if (this.childNodes[0].nodeType === 3) {
      return this.childNodes[0].textContent = this.childNodes[0].textContent.trim();
    }
  };

  iInput.prototype.initialize = function() {
    this.setAttribute('contenteditable', true);
    return this.addEventListener(UI.Events.blur, this.cleanup.bind(this));
  };

  return iInput;

})(UI.Abstract);


/***  components/ui-text  ***/

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

UI.Text = (function(_super) {
  __extends(Text, _super);

  function Text() {
    _ref = Text.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Text.TAGNAME = 'text';

  Text.prototype._keydown = function(e) {
    if (e.keyCode === 13) {
      return e.preventDefault();
    }
  };

  Text.prototype.initialize = function() {
    Text.__super__.initialize.apply(this, arguments);
    return this.addEventListener(UI.Events.beforeInput, this._keydown);
  };

  return Text;

})(UI.iInput);


/***  core/color  ***/

var Color;

Color = (function() {
  Color.get('red', function() {
    return this._red;
  });

  Color.set('red', function(value) {
    this._red = parseInt(value).clamp(0, 255);
    return this._update('rgb');
  });

  Color.get('green', function() {
    return this._green;
  });

  Color.set('green', function(value) {
    this._green = parseInt(value).clamp(0, 255);
    return this._update('rgb');
  });

  Color.get('blue', function() {
    return this._blue;
  });

  Color.set('blue', function(value) {
    this._blue = parseInt(value).clamp(0, 255);
    return this._update('rgb');
  });

  Color.get('lightness', function() {
    return this._lightness;
  });

  Color.set('lightness', function(value) {
    this._lightness = parseInt(value).clamp(0, 100);
    return this._update('hsl');
  });

  Color.get('saturation', function() {
    return this._saturation;
  });

  Color.set('saturation', function(value) {
    this._saturation = parseInt(value).clamp(0, 100);
    return this._update('hsl');
  });

  Color.get('rgb', function() {
    return this.toString('rgb');
  });

  Color.get('rgba', function() {
    return this.toString('rgba');
  });

  Color.get('hsl', function() {
    return this.toString('hsl');
  });

  Color.get('hsla', function() {
    return this.toString('hsla');
  });

  Color.get('hex', function() {
    return "#" + this._hex;
  });

  Color.set('hex', function(value) {
    this._hex = value;
    return this._update('hex');
  });

  Color.get('hue', function() {
    return this._hue;
  });

  Color.set('hue', function(value) {
    this._hue = parseInt(value).clampRange(0, 360);
    return this._update('hsl');
  });

  Color.get('alpha', function() {
    return this._alpha;
  });

  Color.set('alpha', function(value) {
    return this._alpha = parseInt(value).clamp(0, 100);
  });

  function Color(color) {
    var hex, match;
    if (color == null) {
      color = "FFFFFF";
    }
    if (!color.trim()) {
      color = "FFFFFF";
    }
    if (color === 'transparent') {
      color = "rgba(0,0,0,0)";
    }
    color = color.trim().toString();
    color = color.replace(/\s/g, '');
    if ((match = color.match(/^#?([0-9a-f]{3}|[0-9a-f]{6})$/i))) {
      if (color.match(/^#/)) {
        hex = color.slice(1);
      } else {
        hex = color;
      }
      if (hex.length === 3) {
        hex = hex.replace(/([0-9a-f])/gi, '$1$1');
      }
      this.type = 'hex';
      this._hex = hex;
      this._alpha = 100;
      this._update('hex');
    } else if ((match = color.match(/^hsla?\((-?\d+),\s*(-?\d{1,3})%,\s*(-?\d{1,3})%(,\s*([01]?\.?\d*))?\)$/)) != null) {
      this.type = 'hsl';
      this._hue = parseInt(match[1]).clampRange(0, 360);
      this._saturation = parseInt(match[2]).clamp(0, 100);
      this._lightness = parseInt(match[3]).clamp(0, 100);
      this._alpha = parseInt(parseFloat(match[5]) * 100) || 100;
      this._alpha = this._alpha.clamp(0, 100);
      this.type += match[5] ? "a" : "";
      this._update('hsl');
    } else if ((match = color.match(/^rgba?\((\d{1,3}),\s*(\d{1,3}),\s*(\d{1,3})(,\s*([01]?\.?\d*))?\)$/)) != null) {
      this.type = 'rgb';
      this._red = parseInt(match[1]).clamp(0, 255);
      this._green = parseInt(match[2]).clamp(0, 255);
      this._blue = parseInt(match[3]).clamp(0, 255);
      this._alpha = parseInt(parseFloat(match[5]) * 100) || 100;
      this._alpha = this._alpha.clamp(0, 100);
      this.type += match[5] ? "a" : "";
      this._update('rgb');
    } else {
      throw 'Wrong color format!';
    }
  }

  Color.prototype.invert = function() {
    this._red = 255 - this._red;
    this._green = 255 - this._green;
    this._blue = 255 - this._blue;
    this._update('rgb');
    return this;
  };

  Color.prototype.mix = function(color2, alpha) {
    var c, item, _i, _len, _ref;
    if (alpha == null) {
      alpha = 50;
    }
    if (!(color2 instanceof Color)) {
      color2 = new Color(color2);
    }
    c = new Color();
    _ref = ['red', 'green', 'blue'];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      item = _ref[_i];
      c[item] = Math.round((color2[item] / 100 * (100 - alpha)) + (this[item] / 100 * alpha)).clamp(0, 255);
    }
    return c;
  };

  Color.prototype._hsl2rgb = function() {
    var h, i, l, rgb, s, t1, t2, t3, val;
    h = this._hue / 360;
    s = this._saturation / 100;
    l = this._lightness / 100;
    if (s === 0) {
      val = Math.round(l * 255);
      this._red = val;
      this._green = val;
      this._blue = val;
    }
    if (l < 0.5) {
      t2 = l * (1 + s);
    } else {
      t2 = l + s - l * s;
    }
    t1 = 2 * l - t2;
    rgb = [0, 0, 0];
    i = 0;
    while (i < 3) {
      t3 = h + 1 / 3 * -(i - 1);
      t3 < 0 && t3++;
      t3 > 1 && t3--;
      if (6 * t3 < 1) {
        val = t1 + (t2 - t1) * 6 * t3;
      } else if (2 * t3 < 1) {
        val = t2;
      } else if (3 * t3 < 2) {
        val = t1 + (t2 - t1) * (2 / 3 - t3) * 6;
      } else {
        val = t1;
      }
      rgb[i] = val * 255;
      i++;
    }
    this._red = Math.round(rgb[0]);
    this._green = Math.round(rgb[1]);
    return this._blue = Math.round(rgb[2]);
  };

  Color.prototype._hex2rgb = function() {
    var value;
    value = parseInt(this._hex, 16);
    this._red = value >> 16;
    this._green = (value >> 8) & 0xFF;
    return this._blue = value & 0xFF;
  };

  Color.prototype._rgb2hex = function() {
    var value, x;
    value = this._red << 16 | (this._green << 8) & 0xffff | this._blue;
    x = value.toString(16);
    x = '000000'.substr(0, 6 - x.length) + x;
    return this._hex = x.toUpperCase();
  };

  Color.prototype._rgb2hsl = function() {
    var b, delta, g, h, l, max, min, r, s;
    r = this._red / 255;
    g = this._green / 255;
    b = this._blue / 255;
    min = Math.min(r, g, b);
    max = Math.max(r, g, b);
    delta = max - min;
    if (max === min) {
      h = 0;
    } else if (r === max) {
      h = (g - b) / delta;
    } else if (g === max) {
      h = 2 + (b - r) / delta;
    } else {
      if (b === max) {
        h = 4 + (r - g) / delta;
      }
    }
    h = Math.min(h * 60, 360);
    if (h < 0) {
      h += 360;
    }
    l = (min + max) / 2;
    if (max === min) {
      s = 0;
    } else if (l <= 0.5) {
      s = delta / (max + min);
    } else {
      s = delta / (2 - max - min);
    }
    this._hue = h;
    this._saturation = s * 100;
    return this._lightness = l * 100;
  };

  Color.prototype._update = function(type) {
    switch (type) {
      case 'rgb':
        this._rgb2hsl();
        return this._rgb2hex();
      case 'hsl':
        this._hsl2rgb();
        return this._rgb2hex();
      case 'hex':
        this._hex2rgb();
        return this._rgb2hsl();
    }
  };

  Color.prototype.toString = function(type) {
    if (type == null) {
      type = 'hex';
    }
    switch (type) {
      case "rgb":
        return "rgb(" + this._red + ", " + this._green + ", " + this._blue + ")";
      case "rgba":
        return "rgba(" + this._red + ", " + this._green + ", " + this._blue + ", " + (this.alpha / 100) + ")";
      case "hsl":
        return "hsl(" + this._hue + ", " + (Math.round(this._saturation)) + "%, " + (Math.round(this._lightness)) + "%)";
      case "hsla":
        return "hsla(" + this._hue + ", " + (Math.round(this._saturation)) + "%, " + (Math.round(this._lightness)) + "%, " + (this.alpha / 100) + ")";
      case "hex":
        return this.hex;
    }
  };

  return Color;

})();

window.ColorType = Color;


/***  components/ui-color  ***/

var color, picker, _ref,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

picker = (function() {
  function _Class() {
    this.dragCircle = __bind(this.dragCircle, this);
    this.dragTriangle = __bind(this.dragTriangle, this);
    var point, _i, _len, _ref,
      _this = this;
    this.el = document.createElement('picker');
    document.body.appendChild(this.el);
    document.addEventListener(UI.Events.action, function(e) {
      picker = getParent(e.target, 'picker');
      if (!picker) {
        return _this.hide();
      }
    });
    this.circleCanvas = document.createElement('canvas');
    this.triangle = document.createElement('triangle');
    this.triangle.appendChild(document.createElement('gradient'));
    this.triangle.style.background = 'red';
    this.circleCanvas.width = 160;
    this.circleCanvas.height = 160;
    this.drawHSLACone(160);
    _ref = ['point', 'point2'];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      point = _ref[_i];
      this[point] = document.createElement('point');
    }
    this.color = new Color("#ff0000");
    this.endColor = new Color("#ff0000");
    this.triangle.style.width = 82 + "px";
    this.triangle.style.height = 82 + "px";
    this.el.appendChild(this.triangle);
    this.el.appendChild(this.circleCanvas);
    this.triangle.appendChild(this.point);
    this.el.appendChild(this.point2);
    this.drag = new Drag(this.el);
    this.el.addEventListener('dragmove', function(e) {
      e.stopPropagation();
      _this.dragCircle(e);
      return _this.dragTriangle(e);
    });
    this.el.addEventListener('dragstart', function(e) {
      e.stopPropagation();
      _this.dragCircle(e);
      return _this.dragTriangle(e);
    });
  }

  _Class.prototype.fromColor = function(color, set) {
    var c, radius;
    if (set == null) {
      set = true;
    }
    try {
      c = new Color(color);
      radius = 69;
      this.angleRad = -c.hue * (Math.PI / 180);
      this.point2.style.top = radius * Math.sin(this.angleRad) + 85 + "px";
      this.point2.style.left = radius * Math.cos(this.angleRad) + 85 + "px";
      this.point.style.left = (c.saturation / 100) * 82 - 6 + "px";
      this.point.style.top = (Math.min((100 - c.lightness) / 100, 100 - c.saturation / 50) * 82) - 6 + "px";
      this.color.hue = c.hue;
      this.endColor = c;
      this.triangle.style.background = this.color.hex;
      if (set) {
        return this.setBoundValue();
      }
    } catch (_error) {}
  };

  _Class.prototype.dragTriangle = function(e) {
    var p, p1, rect;
    if (e._stop) {
      return;
    }
    rect = this.triangle.getBoundingClientRect(this.triangle);
    p1 = new Point(this.drag.position.x, this.drag.position.y);
    p = p1.diff(new Point(rect.left, rect.top + window.scrollY));
    this.point.style.top = (p.y - 6).clamp(-6, 76) + "px";
    this.point.style.left = (p.x - 6).clamp(-6, 76) + "px";
    this.endColor.lightness = Math.min(100 - Math.round((p.y / 82) * 100), 100 - (Math.round((p.x / 82) * 50)));
    this.endColor.saturation = Math.round((p.x / 82) * 100);
    return this.setBoundValue();
  };

  _Class.prototype.setBoundValue = function() {
    var _ref;
    return (_ref = this.bound) != null ? _ref.value = this.endColor.hex : void 0;
  };

  _Class.prototype.bind = function(input) {
    return this.bound = input;
  };

  _Class.prototype.dragCircle = function(e) {
    var left, p, p1, r, radius, rect, top;
    rect = this.circleCanvas.getBoundingClientRect();
    p = new Point(this.drag.position.x, this.drag.position.y);
    p1 = p.diff(new Point(rect.left, rect.top + window.scrollY));
    top = p1.y - 80;
    left = p1.x - 80;
    r = Math.sqrt(Math.pow(top, 2) + Math.pow(left, 2));
    radius = 69;
    if ((60 < r && r < 80)) {
      e._stop = true;
      this.angleRad = Math.atan2(top, left);
      this.angle = this.angleRad * (180 / Math.PI);
      this.point2.style.top = radius * Math.sin(this.angleRad) + 85 + "px";
      this.point2.style.left = radius * Math.cos(this.angleRad) + 85 + "px";
      this.endColor.hue = this.color.hue = 360 - this.angle;
      this.triangle.style.background = this.color.hex;
      return this.setBoundValue();
    }
  };

  _Class.prototype.drawHSLACone = function(width) {
    var ang, angle, c, ctx, i, w2, _i, _ref, _results;
    ctx = this.circleCanvas.getContext('2d');
    ctx.translate(width / 2, width / 2);
    w2 = -width / 2;
    ang = width / 50;
    angle = (1 / ang) * Math.PI / 180;
    i = 0;
    _results = [];
    for (i = _i = 0, _ref = 360. * ang - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
      c = new Color("#ff0000");
      c.hue = 360 - (i / ang);
      ctx.strokeStyle = c.hex;
      ctx.beginPath();
      ctx.moveTo(width / 2 - 20, 0);
      ctx.lineTo(width / 2, 0);
      ctx.stroke();
      _results.push(ctx.rotate(angle));
    }
    return _results;
  };

  _Class.prototype.hide = function() {
    if (getComputedStyle(this.el).display === 'block') {
      return this.el.style.display = 'none';
    }
  };

  _Class.prototype.show = function(el) {
    var rect;
    this.bind(el);
    this.startColor = el.value;
    rect = el.getBoundingClientRect();
    rect = {
      top: rect.top + window.scrollY,
      left: rect.left,
      height: rect.height,
      width: rect.width
    };
    this.fromColor(el.value);
    if (window.innerWidth < 180 + rect.left) {
      this.el.classList.remove('left');
      this.el.classList.add('right');
      this.el.style.left = rect.left - 180 + rect.width + "px";
    } else {
      this.el.style.left = rect.left + "px";
      this.el.classList.remove('right');
      this.el.classList.add('left');
    }
    if (window.innerHeight < 180 + rect.top) {
      this.el.style.top = rect.top - rect.height - 163 + "px";
      this.el.classList.remove('bottom');
      this.el.classList.add('top');
    } else {
      this.el.style.top = rect.top + rect.height + "px";
      this.el.classList.remove('top');
      this.el.classList.add('bottom');
    }
    return this.el.style.display = 'block';
  };

  return _Class;

})();

color = Color;

UI.Color = (function(_super) {
  __extends(Color, _super);

  function Color() {
    _ref = Color.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Color.TAGNAME = 'color';

  Color.get('value', function() {
    return new color(getComputedStyle(this).backgroundColor).hex;
  });

  Color.set('value', function(value) {
    var c, last;
    last = this.value;
    if (document.querySelector(':focus') !== this) {
      this.textContent = value.replace("#", '');
    } else {
      ColorPicker.fromColor(value, false);
    }
    try {
      c = new color(value);
      this.style.backgroundColor = c.hex;
      this.style.color = c.lightness < 50 ? "#fff" : "#000";
      if (this.value !== last) {
        return this.fireEvent('change');
      }
    } catch (_error) {}
  });

  Color.prototype.initialize = function() {
    if (window.ColorPicker == null) {
      window.ColorPicker = new picker;
    }
    this.setAttribute('contenteditable', true);
    this.setAttribute('spellcheck', false);
    this.addEventListener(UI.Events.action, function(e) {
      e.stopPropagation();
      if (this.disabled) {
        return;
      }
      return ColorPicker.show(this);
    });
    this.addEventListener(UI.Events.keypress, function(e) {
      if ([39, 37, 8, 46].indexOf(e.keyCode) !== -1) {
        return;
      }
      if (!/^[0-9A-Za-z]$/.test(String.fromCharCode(e.charCode))) {
        return e.preventDefault();
      }
      return this.value = this.textContent;
    });
    this.addEventListener(UI.Events.keyup, function(e) {
      return this.value = this.textContent;
    });
    this.addEventListener(UI.Events.blur, function() {
      return this.value = this.textContent;
    });
    return this.value = this.getAttribute('value') || '#fff';
  };

  return Color;

})(UI.Text);


/***  core/i-openable  ***/

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

UI.iOpenable = (function(_super) {
  __extends(iOpenable, _super);

  function iOpenable() {
    _ref = iOpenable.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  iOpenable.get('isOpen', function() {
    return this.hasAttribute('open');
  });

  iOpenable.get('direction', function() {
    var dir;
    dir = this.getAttribute('direction');
    if (this._directions.indexOf(dir) === -1) {
      return 'bottom';
    } else {
      return dir;
    }
  });

  iOpenable.set('direction', function(value) {
    if (this._directions.indexOf(value) === -1) {
      value = 'bottom';
    }
    if (value === 'bottom') {
      return this.removeAttribute('direction');
    } else {
      return this.setAttribute('direction', value);
    }
  });

  iOpenable.prototype.onAdded = function() {
    if (getComputedStyle(this.parentNode).position === 'static') {
      return this.parentNode.style.position = 'relative';
    }
  };

  iOpenable.prototype.open = function() {
    return this.setAttribute('open', true);
  };

  iOpenable.prototype.close = function() {
    return this.removeAttribute('open');
  };

  iOpenable.prototype.toggle = function() {
    return this.toggleAttribute('open');
  };

  iOpenable.prototype.initialize = function(_directions) {
    this._directions = _directions != null ? _directions : [];
  };

  return iOpenable;

})(UI.Abstract);


/***  components/ui-dropdown  ***/

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

UI.Dropdown = (function(_super) {
  __extends(Dropdown, _super);

  function Dropdown() {
    _ref = Dropdown.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Dropdown.TAGNAME = 'dropdown';

  Dropdown.prototype._toggle = function() {
    if (this.parentNode.hasAttribute('disabled') || this.disabled) {
      return;
    }
    return this.toggle();
  };

  Dropdown.prototype._close = function(e) {
    if (this.parentNode.hasAttribute('disabled') || this.disabled) {
      return;
    }
    if (getParent(e.target, UI.Dropdown.SELECTOR()) !== this && getParent(e.target, this.parentNode.tagName) !== this.parentNode) {
      return this.close();
    }
  };

  Dropdown.prototype.onAdded = function() {
    Dropdown.__super__.onAdded.apply(this, arguments);
    return this.parentNode.addEventListener(UI.Events.action, this._toggle.bind(this));
  };

  Dropdown.prototype.initialize = function() {
    Dropdown.__super__.initialize.call(this, ['top', 'bottom']);
    return document.addEventListener(UI.Events.action, this._close.bind(this));
  };

  return Dropdown;

})(UI.iOpenable);


/***  components/ui-email  ***/

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

UI.Email = (function(_super) {
  __extends(Email, _super);

  function Email() {
    _ref = Email.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Email.TAGNAME = 'email';

  return Email;

})(UI.Text);


/***  components/ui-form  ***/

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

UI.Form = (function(_super) {
  __extends(Form, _super);

  function Form() {
    _ref = Form.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Form.TAGNAME = 'form';

  Form.get('data', function() {
    var data, el, _i, _len, _ref1;
    data = {};
    _ref1 = this.querySelectorAll('[name]');
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      el = _ref1[_i];
      if (!el.value) {
        continue;
      }
      data[el.getAttribute('name')] = el.value;
    }
    return data;
  });

  Form.get('action', function() {
    return this.getAttribute('action');
  });

  Form.set('action', function(value) {
    return this.setAttribute('action', value);
  });

  Form.get('method', function() {
    var method;
    if (!this.hasAttribute('method')) {
      return 'get';
    }
    method = this.getAttribute('method').toLowerCase();
    if (['get', 'post', 'delete', 'patch', 'put'].indexOf(method) === -1) {
      return 'get';
    }
    return method;
  });

  Form.set('method', function(value) {
    if (['get', 'post', 'delete', 'patch', 'put'].indexOf(value.toLowerCase()) === -1) {
      value = "get";
    }
    return this.setAttribute('method', value.toLowerCase());
  });

  Form.prototype.submit = function(callback) {
    var event, oReq,
      _this = this;
    event = this.fireEvent('submit');
    if (event.defaultPrevented) {
      return;
    }
    oReq = new XMLHttpRequest();
    oReq.onreadystatechange = function() {
      var body, headers, status;
      if (oReq.readyState === 4) {
        headers = {};
        oReq.getAllResponseHeaders().split("\n").map(function(item) {
          var key, value, _ref1;
          _ref1 = item.split(": "), key = _ref1[0], value = _ref1[1];
          if (key && value) {
            return headers[key] = value;
          }
        });
        body = oReq.response;
        status = oReq.status;
        return _this.fireEvent('complete', {
          response: {
            headers: headers,
            body: body,
            status: status
          }
        });
      }
    };
    oReq.open(this.method.toUpperCase(), this.action);
    return oReq.send(this.data);
  };

  return Form;

})(UI.Abstract);


/***  components/ui-grid  ***/

var _ref, _ref1, _ref2,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

UI.Cell = (function(_super) {
  __extends(Cell, _super);

  function Cell() {
    _ref = Cell.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Cell.TAGNAME = 'cell';

  return Cell;

})(UI.Abstract);

UI.Placeholder = (function(_super) {
  __extends(Placeholder, _super);

  function Placeholder() {
    _ref1 = Placeholder.__super__.constructor.apply(this, arguments);
    return _ref1;
  }

  Placeholder.TAGNAME = 'placeholder';

  return Placeholder;

})(UI.Abstract);

UI.Grid = (function(_super) {
  __extends(Grid, _super);

  function Grid() {
    _ref2 = Grid.__super__.constructor.apply(this, arguments);
    return _ref2;
  }

  Grid.TAGNAME = 'grid';

  Grid.get('columns', function() {
    return parseInt(this.getAttribute('columns'));
  });

  Grid.set('columns', function(value) {
    this.setAttribute('columns', parseInt(value));
    this._updating = true;
    return this._update();
  });

  Grid.prototype._update = function() {
    var cells, diff, el, i, _i, _j, _len, _ref3;
    _ref3 = Array.prototype.slice.call(this.querySelectorAll(UI.Placeholder.SELECTOR()));
    for (_i = 0, _len = _ref3.length; _i < _len; _i++) {
      el = _ref3[_i];
      el.parentNode.removeChild(el);
    }
    this.normalize();
    cells = this.querySelectorAll(UI.Cell.SELECTOR()).length;
    diff = this.columns - cells % this.columns;
    if (diff !== this.columns) {
      for (i = _j = 1; 1 <= diff ? _j <= diff : _j >= diff; i = 1 <= diff ? ++_j : --_j) {
        this.appendChild(document.createTextNode('\u0020'));
        this.appendChild(document.createElement(UI.Placeholder.SELECTOR()));
      }
      this.normalize();
    }
    return this._updating = false;
  };

  Grid.prototype.initialize = function() {
    var cell, _i, _len, _ref3, _results,
      _this = this;
    this._update();
    this.addEventListener('DOMNodeRemoved', function() {
      if (_this._updating) {
        return;
      }
      _this._updating = true;
      return setTimeout(_this._update.bind(_this));
    });
    this.addEventListener('DOMNodeInserted', function() {
      if (_this._updating) {
        return;
      }
      _this._updating = true;
      return _this._update();
    });
    _ref3 = this.querySelectorAll('ui-cell');
    _results = [];
    for (_i = 0, _len = _ref3.length; _i < _len; _i++) {
      cell = _ref3[_i];
      _results.push(this.insertBefore(document.createTextNode('\u0020'), cell));
    }
    return _results;
  };

  return Grid;

})(UI.Abstract);


/***  components/ui-label  ***/

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

UI.Label = (function(_super) {
  __extends(Label, _super);

  function Label() {
    _ref = Label.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Label.TAGNAME = 'label';

  Label.prototype._redirect = function() {
    var target;
    target = document.querySelector("[name='" + (this.getAttribute('for')) + "']");
    if (!target) {
      return;
    }
    target.focus();
    return target.action();
  };

  Label.prototype.initialize = function() {
    return this.addEventListener(UI.Events.action, this._redirect);
  };

  return Label;

})(UI.Abstract);


/***  components/ui-modal  ***/

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

UI.Modal = (function(_super) {
  __extends(Modal, _super);

  function Modal() {
    _ref = Modal.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Modal.TAGNAME = 'modal';

  Modal.get('isOpen', function() {
    return this.hasAttribute('open');
  });

  Modal.prototype.close = function() {
    if (this.disabled) {
      return;
    }
    return this.removeAttribute('open');
  };

  Modal.prototype.open = function() {
    if (this.disabled) {
      return;
    }
    return this.setAttribute('open', true);
  };

  Modal.prototype.toggle = function() {
    if (this.disabled) {
      return;
    }
    return this.toggleAttribute('open');
  };

  Modal.prototype.initialize = function() {
    return document.body.appendChild(this);
  };

  return Modal;

})(UI.Abstract);


/***  components/ui-option  ***/

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

UI.Option = (function(_super) {
  __extends(Option, _super);

  function Option() {
    _ref = Option.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Option.TAGNAME = 'option';

  Option.get('selected', function() {
    return this.hasAttribute('selected');
  });

  Option.set('selected', function(value) {
    return this.toggleAttribute('selected', !!value);
  });

  Option.create = function(value) {
    var el;
    el = Option.__super__.constructor.create.apply(this, arguments);
    el.setAttribute('value', value);
    el.textContent = value;
    return el;
  };

  return Option;

})(UI.Abstract);


/***  components/ui-page  ***/

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

UI.Page = (function(_super) {
  __extends(Page, _super);

  function Page() {
    _ref = Page.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Page.TAGNAME = 'page';

  Page.get('active', function() {
    return !!this.getAttribute('active');
  });

  Page.set('active', function(value) {
    return this.toggleAttribute('active', !!value);
  });

  return Page;

})(UI.Abstract);


/***  components/ui-pager  ***/

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

UI.Pager = (function(_super) {
  __extends(Pager, _super);

  function Pager() {
    _ref = Pager.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Pager.TAGNAME = 'pager';

  Pager.set('activePage', function(value) {
    return this.change(value);
  });

  Pager.get('activePage', function() {
    var child, _i, _len, _ref1;
    _ref1 = this.children;
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      child = _ref1[_i];
      if (child.matchesSelector(UI.Page.SELECTOR() + "[active]")) {
        return child;
      }
    }
  });

  Pager.prototype.next = function() {
    return this.change(this.activePage.nextElementSibling);
  };

  Pager.prototype.prev = function() {
    return this.change(this.activePage.previousElementSibling);
  };

  Pager.prototype.change = function(value) {
    var page, _ref1;
    if (value instanceof HTMLElement) {
      if (value.parentNode === this) {
        page = value;
      }
    } else {
      page = this.querySelector(UI.Page.SELECTOR() + ("[name='" + value + "']"));
    }
    if (!page) {
      return;
    }
    if (this.activePage === page) {
      return;
    }
    if ((_ref1 = this.activePage) != null) {
      _ref1.active = false;
    }
    page.active = true;
    return this.fireEvent('change');
  };

  return Pager;

})(UI.Abstract);


/***  components/ui-radio  ***/

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

UI.Radio = (function(_super) {
  __extends(Radio, _super);

  function Radio() {
    _ref = Radio.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Radio.TAGNAME = 'radio';

  Radio.get('checked', function() {
    return this.hasAttribute('checked');
  });

  Radio.set('checked', function(value) {
    var changed, next, radio, _i, _len, _ref1;
    value = !!value;
    if (this.checked === value) {
      return;
    }
    if (!value) {
      next = document.querySelector(UI.Radio.SELECTOR() + ("[name='" + (this.getAttribute('name')) + "']:not([checked])"));
      if (!next) {
        return;
      }
      changed = !next.checked;
      next.setAttribute('checked', true);
      if (changed) {
        next.fireEvent('change');
      }
    } else {
      _ref1 = document.querySelectorAll(UI.Radio.SELECTOR() + ("[name='" + (this.getAttribute('name')) + "']"));
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        radio = _ref1[_i];
        if (radio === this) {
          continue;
        }
        changed = radio.checked;
        radio.removeAttribute('checked');
        if (changed) {
          radio.fireEvent('change');
        }
      }
    }
    this.toggleAttribute('checked', value);
    return this.fireEvent('change');
  });

  Radio.prototype._toggle = function() {
    if (this.checked) {
      return;
    }
    return Radio.__super__._toggle.apply(this, arguments);
  };

  return Radio;

})(UI.iCheckable);


/***  core/drag  ***/

var Drag,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Drag = (function() {
  Drag.get('diff', function() {
    if (!(this.position instanceof Point) && !(this.startPosition instanceof Point)) {
      return null;
    }
    return this.startPosition.diff(this.position);
  });

  function Drag(base) {
    this.base = base != null ? base : document.body;
    this.up = __bind(this.up, this);
    this.pos = __bind(this.pos, this);
    this.move = __bind(this.move, this);
    this.start = __bind(this.start, this);
    this.reset();
    this.base.addEventListener(UI.Events.dragStart, this.start);
  }

  Drag.prototype.reset = function() {
    this.position = this.startPosition = null;
    return this.mouseIsDown = false;
  };

  Drag.prototype.getPosition = function(e) {
    if (e.touches) {
      return new Point(e.touches[0].pageX, e.touches[0].pageY);
    } else {
      return new Point(e.pageX, e.pageY);
    }
  };

  Drag.prototype.start = function(e) {
    var event;
    if (this.base.hasAttribute('disabled')) {
      return;
    }
    this.position = this.startPosition = this.getPosition(e);
    event = UI.Abstract.prototype.fireEvent.call(this.base, 'dragstart', {
      _target: e.target,
      shiftKey: e.shiftKey
    });
    if (event.stopped) {
      return;
    }
    this.mouseIsDown = true;
    document.addEventListener(UI.Events.dragMove, this.pos);
    document.addEventListener(UI.Events.dragEnd, this.up);
    return requestAnimationFrame(this.move);
  };

  Drag.prototype.move = function() {
    if (this.mouseIsDown) {
      requestAnimationFrame(this.move);
    }
    if (!this.position) {
      return;
    }
    return UI.Abstract.prototype.fireEvent.call(this.base, 'dragmove');
  };

  Drag.prototype.pos = function(e) {
    e.preventDefault();
    return this.position = this.getPosition(e);
  };

  Drag.prototype.up = function(e) {
    this.reset();
    document.removeEventListener(UI.Events.dragMove, this.pos);
    document.removeEventListener(UI.Events.dragEnd, this.up);
    return UI.Abstract.prototype.fireEvent.call(this.base, 'dragend');
  };

  return Drag;

})();


/***  components/ui-range  ***/

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

UI.Range = (function(_super) {
  __extends(Range, _super);

  function Range() {
    _ref = Range.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Range.TAGNAME = 'range';

  Range.get('range', function() {
    return Math.abs(this.min - this.max);
  });

  Range.get('_percent', function() {
    return Math.abs(this.min - this.value) / this.range;
  });

  Range.get('min', function() {
    return parseFloat(this.getAttribute('min'));
  });

  Range.set('min', function(value) {
    var percent;
    percent = this._percent;
    this.setAttribute('min', parseFloat(value));
    return this._setValue(percent);
  });

  Range.get('max', function() {
    return parseFloat(this.getAttribute('max'));
  });

  Range.set('max', function(value) {
    var percent;
    percent = this._percent;
    this.setAttribute('max', parseFloat(value));
    return this._setValue(percent);
  });

  Range.get('value', function() {
    var percent;
    percent = parseFloat(this.knob.style.left);
    return this.range * (percent / 100) + this.min;
  });

  Range.set('value', function(value) {
    var percent;
    value = parseFloat(value).clamp(this.min, this.max);
    if (this.value === value) {
      return;
    }
    percent = (Math.abs(this.min - value) / this.range) * 100;
    this.knob.style.left = percent + "%";
    this._setValue(percent / 100, false);
    this.fireEvent('change');
    return this.value;
  });

  Range.prototype._setValue = function(percent, set) {
    if (set == null) {
      set = true;
    }
    if (!set) {
      return;
    }
    return this.value = this.range * percent + this.min;
  };

  Range.prototype._start = function(e) {
    var knobRect, percent, rect;
    e.stopPropagation();
    rect = this.getBoundingClientRect();
    knobRect = this.knob.getBoundingClientRect();
    this.startPosition = this.drag.startPosition.diff(new Point(rect.left, rect.top));
    percent = this.startPosition.x / this.offsetWidth;
    return this._setValue(percent);
  };

  Range.prototype._move = function(e) {
    var current, diff, percent;
    e.stopPropagation();
    diff = this.startPosition.diff(this.drag.diff);
    current = diff.x.clamp(0, this.offsetWidth);
    percent = current / this.offsetWidth;
    return this._setValue(percent);
  };

  Range.prototype.initialize = function() {
    var knob, value;
    if (this.children.length === 0) {
      knob = document.createElement('div');
      knob.appendChild(document.createElement('div'));
      this.appendChild(knob);
    }
    this.knob = this.children[0];
    this.knob.style.left = 0;
    if (!this.min) {
      this.setAttribute('min', 0);
    }
    if (!this.max) {
      this.setAttribute('max', 100);
    }
    if (!isNaN(value = parseFloat(this.getAttribute('value')))) {
      value = value.clamp(this.min, this.max);
      this._setValue((value - this.min) / this.range);
    }
    this.drag = new Drag(this);
    this.addEventListener('dragstart', this._start.bind(this));
    return this.addEventListener('dragmove', this._move.bind(this));
  };

  return Range;

})(UI.Abstract);


/***  components/ui-select  ***/

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

UI.Select = (function(_super) {
  __extends(Select, _super);

  function Select() {
    _ref = Select.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Select.TAGNAME = 'select';

  Select.set('value', function(value) {
    return this.select(value);
  });

  Select.get('value', function() {
    if (!this.selectedOption) {
      return null;
    }
    return this.selectedOption.getAttribute('value');
  });

  Select.get('selectedOption', function() {
    return this.querySelector(UI.Option.SELECTOR() + "[selected]");
  });

  Select.set('selectedOption', function(value) {
    return this.select(value);
  });

  Select.prototype._nodeRemoved = function(e) {
    if (e.target.nodeType !== 1) {
      return;
    }
    if (!e.target.matchesSelector(UI.Option.SELECTOR()) && !e.target.hasAttribute('selected')) {
      return;
    }
    e.target.setAttribute('disposed', true);
    return this.selectDefault();
  };

  Select.prototype._nodeAdded = function(e) {
    if (e.target.nodeType === 1) {
      return this.selectDefault();
    }
  };

  Select.prototype._select = function(e) {
    if (this.disabled) {
      return;
    }
    if (!e.target.matchesSelector(UI.Option.SELECTOR())) {
      return;
    }
    this.select(e.target);
    return this.dropdown.close();
  };

  Select.prototype.initialize = function() {
    this.dropdown = this.querySelector(UI.Dropdown.SELECTOR());
    this.label = this.querySelector(UI.Label.SELECTOR());
    if (!this.dropdown) {
      this.dropdown = UI.Dropdown.create();
      this.insertBefore(this.dropdown, this.firstChild);
      this.dropdown.onAdded();
    }
    if (!this.label) {
      this.insertBefore((this.label = UI.Label.create()), this.firstChild);
    }
    this.name = this.getAttribute('name');
    this.addEventListener('DOMNodeRemoved', this._nodeRemoved);
    this.addEventListener('DOMNodeInserted', this._nodeAdded);
    this.addEventListener(UI.Events.action, this._select);
    return this.selectDefault();
  };

  Select.prototype.selectDefault = function() {
    var selected;
    selected = this.querySelector(UI.Option.SELECTOR() + "[selected]:not([disposed])");
    if (selected == null) {
      selected = this.querySelectorAll(UI.Option.SELECTOR() + ":not([disposed])")[0];
    }
    return this.select(selected);
  };

  Select.prototype.select = function(value) {
    var selected, _ref1, _ref2, _ref3;
    if (value instanceof HTMLElement) {
      selected = value;
    } else {
      selected = this.querySelector(UI.Option.SELECTOR() + ("[value='" + value + "']")) || null;
    }
    if (!selected) {
      if ((_ref1 = this.label) != null) {
        _ref1.textContent = "";
      }
      if (this.selectedOption) {
        this.selectedOption.selected = false;
      }
      this.fireEvent('change');
      return;
    }
    if (this.selectedOption === selected) {
      return;
    }
    if ((_ref2 = this.selectedOption) != null) {
      _ref2.selected = false;
    }
    selected.selected = true;
    if ((_ref3 = this.label) != null) {
      _ref3.textContent = this.selectedOption.textContent;
    }
    return this.fireEvent('change');
  };

  return Select;

})(UI.Abstract);


/***  components/ui-slider  ***/

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

UI.Slider = (function(_super) {
  __extends(Slider, _super);

  function Slider() {
    _ref = Slider.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Slider.TAGNAME = 'slider';

  Slider.prototype._setValue = function(percent) {
    Slider.__super__._setValue.apply(this, arguments);
    return this.style.backgroundSize = "" + (percent * 100) + "% 100%";
  };

  return Slider;

})(UI.Range);


/***  components/ui-textarea  ***/

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

UI.Textarea = (function(_super) {
  __extends(Textarea, _super);

  function Textarea() {
    _ref = Textarea.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Textarea.TAGNAME = 'textarea';

  return Textarea;

})(UI.iInput);


/***  components/ui-toggle  ***/

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

UI.Toggle = (function(_super) {
  __extends(Toggle, _super);

  function Toggle() {
    _ref = Toggle.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Toggle.TAGNAME = 'toggle';

  Toggle.create = function() {
    var el, separator, _off, _on;
    el = Toggle.__super__.constructor.create.apply(this, arguments);
    _on = document.createElement('div');
    _off = document.createElement('div');
    separator = document.createElement('div');
    _on.textContent = 'ON';
    _off.textContent = 'OFF';
    el.appendChild(_on);
    el.appendChild(separator);
    el.appendChild(_off);
    return el;
  };

  return Toggle;

})(UI.iCheckable);


/***  components/ui-tooltip  ***/

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

UI.Tooltip = (function(_super) {
  __extends(Tooltip, _super);

  function Tooltip() {
    _ref = Tooltip.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Tooltip.TAGNAME = 'tooltip';

  Tooltip.get('label', function() {
    return this.textContent;
  });

  Tooltip.set('label', function(value) {
    return this.textContent = value;
  });

  Tooltip.prototype._enter = function(e) {
    if (this.parentNode.hasAttribute('disabled') || this.disabled) {
      return;
    }
    if (getParent(e.target, UI.Tooltip.SELECTOR())) {
      return;
    }
    return this.setAttribute('open', true);
  };

  Tooltip.prototype._leave = function() {
    if (this.parentNode.hasAttribute('disabled') || this.disabled) {
      return;
    }
    return this.removeAttribute('open');
  };

  Tooltip.prototype.onAdded = function() {
    Tooltip.__super__.onAdded.apply(this, arguments);
    this.parentNode.addEventListener(UI.Events.enter, this._enter.bind(this));
    return this.parentNode.addEventListener(UI.Events.leave, this._leave.bind(this));
  };

  Tooltip.prototype.initialize = function() {
    return Tooltip.__super__.initialize.call(this, ['top', 'bottom', 'left', 'right']);
  };

  return Tooltip;

})(UI.iOpenable);


/***  core/mui  ***/

UI.initialize();
