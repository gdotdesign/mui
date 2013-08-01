

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


/***  polyfills/class-list  ***/

/*
 * classList.js: Cross-browser full element.classList implementation.
 * 2012-11-15
 *
 * By Eli Grey, http://eligrey.com
 * Public Domain.
 * NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.
 */

/*global self, document, DOMException */

/*! @source http://purl.eligrey.com/github/classList.js/blob/master/classList.js*/


if (typeof document !== "undefined" && !("classList" in document.documentElement)) {

(function (view) {

"use strict";

if (!('HTMLElement' in view) && !('Element' in view)) return;

var
	  classListProp = "classList"
	, protoProp = "prototype"
	, elemCtrProto = (view.HTMLElement || view.Element)[protoProp]
	, objCtr = Object
	, strTrim = String[protoProp].trim || function () {
		return this.replace(/^\s+|\s+$/g, "");
	}
	, arrIndexOf = Array[protoProp].indexOf || function (item) {
		var
			  i = 0
			, len = this.length
		;
		for (; i < len; i++) {
			if (i in this && this[i] === item) {
				return i;
			}
		}
		return -1;
	}
	// Vendors: please allow content code to instantiate DOMExceptions
	, DOMEx = function (type, message) {
		this.name = type;
		this.code = DOMException[type];
		this.message = message;
	}
	, checkTokenAndGetIndex = function (classList, token) {
		if (token === "") {
			throw new DOMEx(
				  "SYNTAX_ERR"
				, "An invalid or illegal string was specified"
			);
		}
		if (/\s/.test(token)) {
			throw new DOMEx(
				  "INVALID_CHARACTER_ERR"
				, "String contains an invalid character"
			);
		}
		return arrIndexOf.call(classList, token);
	}
	, ClassList = function (elem) {
		var
			  trimmedClasses = strTrim.call(elem.className)
			, classes = trimmedClasses ? trimmedClasses.split(/\s+/) : []
			, i = 0
			, len = classes.length
		;
		for (; i < len; i++) {
			this.push(classes[i]);
		}
		this._updateClassName = function () {
			elem.className = this.toString();
		};
	}
	, classListProto = ClassList[protoProp] = []
	, classListGetter = function () {
		return new ClassList(this);
	}
;
// Most DOMException implementations don't allow calling DOMException's toString()
// on non-DOMExceptions. Error's toString() is sufficient here.
DOMEx[protoProp] = Error[protoProp];
classListProto.item = function (i) {
	return this[i] || null;
};
classListProto.contains = function (token) {
	token += "";
	return checkTokenAndGetIndex(this, token) !== -1;
};
classListProto.add = function () {
	var
		  tokens = arguments
		, i = 0
		, l = tokens.length
		, token
		, updated = false
	;
	do {
		token = tokens[i] + "";
		if (checkTokenAndGetIndex(this, token) === -1) {
			this.push(token);
			updated = true;
		}
	}
	while (++i < l);

	if (updated) {
		this._updateClassName();
	}
};
classListProto.remove = function () {
	var
		  tokens = arguments
		, i = 0
		, l = tokens.length
		, token
		, updated = false
	;
	do {
		token = tokens[i] + "";
		var index = checkTokenAndGetIndex(this, token);
		if (index !== -1) {
			this.splice(index, 1);
			updated = true;
		}
	}
	while (++i < l);

	if (updated) {
		this._updateClassName();
	}
};
classListProto.toggle = function (token, forse) {
	token += "";

	var
		  result = this.contains(token)
		, method = result ?
			forse !== true && "remove"
		:
			forse !== false && "add"
	;

	if (method) {
		this[method](token);
	}

	return !result;
};
classListProto.toString = function () {
	return this.join(" ");
};

if (objCtr.defineProperty) {
	var classListPropDesc = {
		  get: classListGetter
		, enumerable: true
		, configurable: true
	};
	try {
		objCtr.defineProperty(elemCtrProto, classListProp, classListPropDesc);
	} catch (ex) { // IE 8 doesn't support enumerable:true
		if (ex.number === -0x7FF5EC54) {
			classListPropDesc.enumerable = false;
			objCtr.defineProperty(elemCtrProto, classListProp, classListPropDesc);
		}
	}
} else if (objCtr[protoProp].__defineGetter__) {
	elemCtrProto.__defineGetter__(classListProp, classListGetter);
}

}(self));

}
;


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

// Fireevent

Element.prototype.fireEvent = function(type, data) {
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

Function.prototype.once = function(){
  var fn = this;
  var called = false;
  return function(){
    if(called) return
    called = true
    fn()
  }
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

Element.prototype.index = function(){
  return Array.prototype.slice.call(this.parentNode.children).indexOf(this)
}

Object.defineProperty(Node.prototype, 'delegateEventListener', {
  value: function(event, selector, listener, useCapture) {
    return this.addEventListener(event, function(e) {
      var target;
      target = e.relatedTarget || e.target;
      if (target.matchesSelector(selector)) {
        return listener(e);
      }
    }, true);
  }
});

elm = document.createElement('div')
window.animationSupport = false
var animationstring = 'animation',
    keyframeprefix = '',
    domPrefixes = 'Webkit Moz O ms Khtml'.split(' '),
    pfx  = '';

if( elm.style.animationName ) { window.animationSupport = true; }
if( window.animationSupport === false ) {
  for( var i = 0; i < domPrefixes.length; i++ ) {
    if( elm.style[ domPrefixes[i] + 'AnimationName' ] !== undefined ) {
      pfx = domPrefixes[ i ];
      animationstring = pfx + 'Animation';
      keyframeprefix = '-' + pfx.toLowerCase() + '-';
      window.animationSupport = true;
      break;
    }
  }
}
;


/***  polyfills/matches-selector  ***/

this.Element && function(ElementPrototype) {
  ElementPrototype.matchesSelector = ElementPrototype.matchesSelector ||
  ElementPrototype.mozMatchesSelector ||
  ElementPrototype.msMatchesSelector ||
  ElementPrototype.oMatchesSelector ||
  ElementPrototype.webkitMatchesSelector ||
  function (selector) {
    var node = this, nodes = (node.parentNode || node.document).querySelectorAll(selector), i = -1;
    while (nodes[++i] && nodes[i] != node){};
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
  version: '0.2.0-RC1',
  validators: {
    required: {
      condition: function() {
        return this.required;
      },
      validate: function() {
        return !!this.value;
      },
      message: 'This field is required!'
    },
    maxlength: {
      condition: function() {
        return this.maxlength !== Infinity;
      },
      validate: function() {
        return this.maxlength >= this.value.toString().length;
      },
      message: function() {
        return 'Length cannot be bigger then ' + this.maxlength + "!";
      }
    },
    pattern: {
      condition: function() {
        if (!this.pattern) {
          return false;
        }
        return this.pattern.toString() !== "/^.*$/";
      },
      validate: function() {
        if (!this.pattern) {
          return false;
        }
        return this.pattern.test(this.value.toString());
      },
      message: 'Value must match the provided pattern!'
    },
    email: {
      condition: function() {
        return this.required;
      },
      validate: function() {
        return /^[a-z0-9!#$%&'"*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])$/.test(this.value.toString());
      },
      message: 'Must be an email address!'
    }
  },
  _wrapPassword: function(el) {
    var desc, key, originDesc, _ref;
    if (el._processed) {
      return;
    }
    if (el.validators == null) {
      el.validators = UI.Text.prototype.validators;
    }
    _ref = UI._geather(UI.iValidable.prototype);
    for (key in _ref) {
      desc = _ref[key];
      if (key === 'initialize' || key === 'constructor') {
        continue;
      }
      originDesc = Object.getOwnPropertyDescriptor(el, key);
      if (originDesc && !originDesc.configurable) {
        continue;
      }
      Object.defineProperty(el, key, desc);
    }
    UI.iValidable.prototype.initialize.call(el);
    return el._processed = true;
  },
  load: function(base) {
    var el, key, value, _i, _len, _ref, _results;
    if (base == null) {
      base = document;
    }
    _ref = base.querySelectorAll('input[type=password]');
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      el = _ref[_i];
      if (el._processed) {
        return;
      }
      this._wrapPassword(el);
    }
    _results = [];
    for (key in UI) {
      value = UI[key];
      if (value.SELECTOR) {
        _results.push((function() {
          var _j, _len1, _ref1, _results1;
          _ref1 = base.querySelectorAll(value.SELECTOR());
          _results1 = [];
          for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
            el = _ref1[_j];
            if (el._processed) {
              continue;
            }
            this.load(el);
            value.wrap(el);
            _results1.push(typeof el.onAdded === "function" ? el.onAdded() : void 0);
          }
          return _results1;
        }).call(this));
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  },
  initialize: function() {
    var _this = this;
    document.addEventListener('DOMNodeInserted', this._insert.bind(this), true);
    return window.addEventListener('load', function() {
      if (typeof UI.onBeforeLoad === "function") {
        UI.onBeforeLoad();
      }
      _this.load();
      return setTimeout(function() {
        document.body.setAttribute('loaded', true);
        return typeof UI.onLoad === "function" ? UI.onLoad() : void 0;
      }, 1000);
    });
  },
  promiseElement: function(tag, attributes, children) {
    if (attributes == null) {
      attributes = {};
    }
    if (children == null) {
      children = [];
    }
    return function(parent) {
      var el, key, value;
      if (typeof tag !== 'string') {
        throw "Illegal tagname";
      }
      if (typeof attributes !== 'object') {
        throw "Illegal attributes";
      }
      el = document.createElement(tag);
      for (key in attributes) {
        value = attributes[key];
        el.setAttribute(key, value);
      }
      if (children) {
        if (!(children instanceof Array)) {
          throw "Illegal children";
        }
        UI._build.call(el, children, parent);
      }
      return el;
    };
  },
  _build: function(children, parent) {
    var el, key, node, prom, promise, _i, _len, _results;
    if (!children) {
      return;
    }
    _results = [];
    for (_i = 0, _len = children.length; _i < _len; _i++) {
      promise = children[_i];
      if (typeof promise === 'string') {
        node = document.createTextNode(promise);
        _results.push(this.appendChild(node));
      } else if (promise instanceof Function) {
        _results.push(this.appendChild(promise(parent)));
      } else {
        _results.push((function() {
          var _results1;
          _results1 = [];
          for (key in promise) {
            prom = promise[key];
            el = prom(parent);
            this.appendChild(el);
            _results1.push(parent[key] = el);
          }
          return _results1;
        }).call(this));
      }
    }
    return _results;
  },
  _insert: function(e) {
    var tag, tagName, _base;
    if (!e.target.tagName) {
      return;
    }
    tagName = e.target.tagName;
    if (tagName === 'INPUT' && e.target.getAttribute('type') === 'password') {
      this._wrapPassword(e.target);
    }
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
    var d, desc, k, key, object, proto, ret, _i, _j, _len, _len1, _ref, _ref1, _ref2, _ref3;
    ret = {};
    _ref = Object.keys(obj);
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      key = _ref[_i];
      if (key === 'implements') {
        _ref1 = obj[key];
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          object = _ref1[_j];
          _ref2 = this._geather(object.prototype);
          for (k in _ref2) {
            d = _ref2[k];
            if (ret[k] == null) {
              ret[k] = d;
            }
          }
        }
      } else {
        ret[key] = Object.getOwnPropertyDescriptor(obj, key);
      }
    }
    if ((proto = Object.getPrototypeOf(obj)) !== Object.prototype) {
      _ref3 = this._geather(proto);
      for (key in _ref3) {
        desc = _ref3[key];
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
    var cls, desc, key, _i, _len, _ref, _ref1, _ref2, _results;
    _ref = UI._geather(this.prototype);
    for (key in _ref) {
      desc = _ref[key];
      if (key === 'initialize' || key === 'constructor') {
        continue;
      }
      Object.defineProperty(el, key, desc);
    }
    if (this.TABABLE) {
      el.setAttribute('tabindex', 0);
    }
    el._processed = true;
    if ((_ref1 = this.prototype.initialize) != null) {
      _ref1.call(el);
    }
    if (!this.prototype["implements"]) {
      return;
    }
    _ref2 = this.prototype["implements"];
    _results = [];
    for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
      cls = _ref2[_i];
      _results.push(cls.prototype.initialize.call(el));
    }
    return _results;
  };

  Abstract.create = function(attributes) {
    var base, key, value;
    base = document.createElement(this.SELECTOR());
    if (this.MARKUP) {
      UI._build.call(base, this.MARKUP, base);
    }
    if (attributes) {
      if (typeof attributes !== 'object') {
        throw "Illegal attributes";
      }
      for (key in attributes) {
        value = attributes[key];
        base.setAttribute(key, value);
      }
    }
    this.wrap(base);
    return base;
  };

  Abstract.promise = function(attributes, children) {
    var _this = this;
    if (attributes == null) {
      attributes = {};
    }
    return function(parent) {
      var el;
      el = _this.create(attributes);
      UI._build.call(el, children, parent);
      return el;
    };
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

  Button.TABABLE = true;

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

  Button.prototype._keydown = function(e) {
    if (e.keyCode === 13) {
      e.preventDefault();
      return this.fireEvent(UI.Events.action);
    }
  };

  Button.prototype.initialize = function() {
    this.addEventListener(UI.Events.action, this._cancel);
    return this.addEventListener('keydown', this._keydown);
  };

  return Button;

})(UI.Abstract);


/***  core/i-validable  ***/

UI.iValidable = (function() {
  function iValidable() {}

  iValidable.get('required', function() {
    return this.hasAttribute('required');
  });

  iValidable.get('maxlength', function() {
    return parseInt(this.getAttribute('maxlength')) || Infinity;
  });

  iValidable.get('valid', function() {
    return this.hasAttribute('valid');
  });

  iValidable.get('invalid', function() {
    return this.hasAttribute('invalid');
  });

  iValidable.get('pattern', function() {
    var pattern;
    pattern = this.getAttribute('pattern') || ".*";
    try {
      return new RegExp("^" + pattern + "$");
    } catch (_error) {
      return /^.*$/;
    }
  });

  iValidable.prototype.validate = function() {
    var shouldValidate, validator, _i, _j, _len, _len1, _ref, _ref1;
    this.toggleAttribute('invalid', false);
    this.toggleAttribute('valid', false);
    shouldValidate = false;
    _ref = this.validators;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      validator = _ref[_i];
      if (validator.condition.call(this)) {
        shouldValidate = true;
        break;
      }
    }
    if (!shouldValidate) {
      return void 0;
    }
    _ref1 = this.validators;
    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
      validator = _ref1[_j];
      if (!validator.condition.call(this)) {
        continue;
      }
      if (!validator.validate.call(this)) {
        this.toggleAttribute('invalid', true);
        this.fireEvent('validate', {
          valid: false
        });
        return false;
      }
    }
    this.toggleAttribute('valid', true);
    this.fireEvent('validate', {
      valid: true
    });
    return true;
  };

  iValidable.prototype.initialize = function() {
    this.addEventListener('keyup', this.validate);
    this.addEventListener('change', this.validate);
    return this.validate();
  };

  return iValidable;

})();


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

  iCheckable.prototype["implements"] = [UI.iValidable];

  iCheckable.prototype.validators = [UI.validators.required];

  iCheckable.TABABLE = true;

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
    this.addEventListener(UI.Events.action, this._toggle);
    return this.addEventListener('keydown', function(e) {
      if (e.keyCode === 13) {
        return this._toggle();
      }
    });
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

  iInput.prototype["implements"] = [UI.iValidable];

  iInput.get('value', function() {
    return this.textContent;
  });

  iInput.set('value', function(value) {
    var lastValue;
    lastValue = this.textContent;
    this.textContent = value;
    if (lastValue !== value) {
      return this.fireEvent('change');
    }
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
    return this.addEventListener(UI.Events.blur, this.cleanup);
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

  Text.prototype.validators = [UI.validators.required, UI.validators.maxlength, UI.validators.pattern];

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
      if (picker) {
        return e.preventDefault();
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
    if (document.querySelector(':focus') === this) {
      ColorPicker.fromColor(value, false);
    }
    try {
      c = new color(value);
      this.style.backgroundColor = c.hex;
      this.style.color = c.lightness < 50 ? "#fff" : "#000";
      if (this.value !== last) {
        this.fireEvent('change');
      }
      return this.textContent = value.replace("#", '');
    } catch (_error) {}
  });

  Color.prototype._focus = function(e) {
    e.stopPropagation();
    if (this.disabled) {
      return;
    }
    return ColorPicker.show(this);
  };

  Color.prototype._keypress = function(e) {
    if ([39, 37, 8, 46, 9].indexOf(e.keyCode) !== -1) {
      return;
    }
    if (!/^[0-9A-Za-z]$/.test(String.fromCharCode(e.charCode))) {
      return e.preventDefault();
    }
    return this.value = this.textContent;
  };

  Color.prototype._keyup = function(e) {
    return this.value = this.textContent;
  };

  Color.prototype._blur = function() {
    ColorPicker.hide();
    return this.value = this.textContent;
  };

  Color.prototype.initialize = function() {
    if (window.ColorPicker == null) {
      window.ColorPicker = new picker;
    }
    this.setAttribute('contenteditable', true);
    this.setAttribute('spellcheck', false);
    this.addEventListener('focus', this._focus);
    this.addEventListener(UI.Events.keypress, this._keypress);
    this.addEventListener(UI.Events.keyup, this._keyup);
    this.addEventListener(UI.Events.blur, this._blur);
    return this.value = this.getAttribute('value') || '#fff';
  };

  return Color;

})(UI.Text);


/***  components/ui-context  ***/

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

UI.Context = (function(_super) {
  __extends(Context, _super);

  function Context() {
    _ref = Context.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Context.TAGNAME = 'context';

  Context.prototype._open = function(e) {
    var pageX, pageY;
    if (this.disabled) {
      return;
    }
    e.stopPropagation();
    e.stopImmediatePropagation();
    e.preventDefault();
    pageX = e.pageX, pageY = e.pageY;
    return this.open(pageX, pageY);
  };

  Context.prototype._close = function(e) {
    if (e.button === 2) {
      return;
    }
    if (this.disabled) {
      return;
    }
    return this.close();
  };

  Context.prototype.open = function(left, top) {
    var _ref1;
    if (!left || !top) {
      _ref1 = this.parentNode.getBoundingClientRect(), left = _ref1.left, top = _ref1.top;
    }
    this.style.left = left + "px";
    this.style.top = top + "px";
    return this.setAttribute('open', true);
  };

  Context.prototype.close = function() {
    return this.removeAttribute('open');
  };

  Context.prototype.onAdded = function() {
    if (this.added) {
      return;
    }
    this.added = true;
    this._parentNode = this.parentNode;
    return this.parentNode.addEventListener('contextmenu', this.$open);
  };

  Context.prototype.initialize = function() {
    this.$close = this._close.bind(this);
    this.$open = this._open.bind(this);
    if (this.parentNode) {
      this.onAdded();
    }
    document.addEventListener(UI.Events.action, this.$close);
    document.addEventListener('contextmenu', this.$close);
    return document.body.appendChild(this);
  };

  return Context;

})(UI.Abstract);


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

  Dropdown.prototype._open = function(e) {
    if (this.parentNode.hasAttribute('disabled') || this.disabled) {
      return;
    }
    return this.open();
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
    if (this.$open == null) {
      this.$open = this._open.bind(this);
    }
    if (this.$toggle == null) {
      this.$toggle = this._toggle.bind(this);
    }
    if (this._parent) {
      this._parent.removeEventListener(UI.Events.action, this.$open);
      this._parent.removeEventListener(UI.Events.action, this.$toggle);
    }
    this._parent = this.parentNode;
    if (this._parent.tagName.toLowerCase() === UI.Select.SELECTOR()) {
      return this._parent.addEventListener(UI.Events.action, this.$open);
    } else {
      return this._parent.addEventListener(UI.Events.action, this.$toggle);
    }
  };

  Dropdown.prototype.initialize = function() {
    Dropdown.__super__.initialize.call(this, ['top', 'bottom', 'left', 'right']);
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

  Email.prototype.validators = UI.Text.prototype.validators.concat(UI.validators.email);

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

  Form.get('valid', function() {
    var el, _i, _len, _ref1;
    _ref1 = this.querySelectorAll("*");
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      el = _ref1[_i];
      if (el.hasAttribute('invalid')) {
        return false;
      }
    }
    return true;
  });

  Form.get('invalid', function() {
    return !this.valid;
  });

  Form.prototype.validate = function() {
    var input, _i, _len, _ref1;
    _ref1 = this.querySelectorAll('[name]');
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      input = _ref1[_i];
      if (typeof input.validate === "function") {
        input.validate();
      }
    }
    return this.valid;
  };

  Form.prototype.submit = function(callback) {
    var event, oReq,
      _this = this;
    if (this.invalid) {
      return false;
    }
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


/***  components/ui-notification  ***/

var _ref, _ref1,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

UI.Message = (function(_super) {
  __extends(Message, _super);

  function Message() {
    _ref = Message.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Message.TAGNAME = 'message';

  Message.MARKUP = [
    {
      content: UI.promiseElement('div')
    }
  ];

  return Message;

})(UI.Abstract);

UI.Notification = (function(_super) {
  __extends(Notification, _super);

  function Notification() {
    _ref1 = Notification.__super__.constructor.apply(this, arguments);
    return _ref1;
  }

  Notification.TAGNAME = 'notification';

  Notification.prototype.defaultTimeout = 5000;

  Notification.prototype.push = function(content, type) {
    var message, remove, _i, _len, _ref2, _results,
      _this = this;
    message = UI.Message.create({
      type: type
    });
    message.content.innerHTML = content;
    this.appendChild(message);
    remove = (function() {
      return _this.removeChild(message);
    }).once();
    if (window.animationSupport) {
      _ref2 = ['animationend', 'webkitAnimationEnd', 'oanimationend', 'MSAnimationEnd'];
      _results = [];
      for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
        type = _ref2[_i];
        _results.push(message.addEventListener(type, remove));
      }
      return _results;
    } else {
      return setTimeout(remove, this.defaultTimeout);
    }
  };

  return Notification;

})(UI.Abstract);


/***  components/ui-number  ***/

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

UI.Number = (function(_super) {
  __extends(Number, _super);

  function Number() {
    _ref = Number.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Number.prototype.validators = [UI.validators.required];

  Number.TAGNAME = 'number';

  Number.get('value', function() {
    var value;
    value = parseFloat(this.textContent);
    if (isNaN(value)) {
      return '';
    }
    return value;
  });

  Number.set('value', function(value) {
    value = parseFloat(value);
    if (isNaN(value)) {
      value = '';
    }
    return this.textContent = value;
  });

  Number.prototype._keypress = function(e) {
    if ([39, 37, 8, 46, 9].indexOf(e.keyCode) !== -1) {
      return;
    }
    if (!/^[0-9.]$/.test(String.fromCharCode(e.charCode))) {
      return e.preventDefault();
    }
  };

  Number.prototype._change = function() {
    return this.fireEvent('change');
  };

  Number.prototype.initialize = function() {
    Number.__super__.initialize.apply(this, arguments);
    this.addEventListener('keypress', this._keypress);
    this.addEventListener('keyup', this._change);
    return this.addEventListener('blur', this._change);
  };

  return Number;

})(UI.Text);


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


/***  components/ui-popover  ***/

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

UI.Popover = (function(_super) {
  __extends(Popover, _super);

  function Popover() {
    _ref = Popover.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Popover.TAGNAME = 'popover';

  Popover.prototype._toggle = function() {
    if (this.parentNode.hasAttribute('disabled') || this.disabled) {
      return;
    }
    return this.toggle();
  };

  Popover.prototype._close = function(e) {
    if (this.parentNode.hasAttribute('disabled') || this.disabled) {
      return;
    }
    if (getParent(e.target, this.parentNode.tagName) !== this.parentNode) {
      return this.close();
    }
  };

  Popover.prototype.onAdded = function() {
    var _this = this;
    Popover.__super__.onAdded.apply(this, arguments);
    this.parentNode.addEventListener(UI.Events.action, this._toggle.bind(this));
    return this.parentNode.addEventListener('keydown', function(e) {
      if (e.ctrlKey) {
        return _this._toggle();
      }
    });
  };

  Popover.prototype.initialize = function() {
    Popover.__super__.initialize.call(this, ['top', 'bottom', 'left', 'right']);
    return document.addEventListener(UI.Events.action, this._close.bind(this));
  };

  return Popover;

})(UI.iOpenable);


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

  Drag.prototype.destroy = function() {
    return this.base.removeEventListener(UI.Events.dragStart, this.start);
  };

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
    event = this.base.fireEvent('dragstart', {
      _target: e.target,
      shiftKey: e.shiftKey
    });
    if (event.stopped) {
      return;
    }
    this.mouseIsDown = true;
    e.preventDefault();
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
    return this.base.fireEvent('dragmove');
  };

  Drag.prototype.pos = function(e) {
    e.preventDefault();
    return this.position = this.getPosition(e);
  };

  Drag.prototype.up = function(e) {
    e.preventDefault();
    this.reset();
    document.removeEventListener(UI.Events.dragMove, this.pos);
    document.removeEventListener(UI.Events.dragEnd, this.up);
    return this.base.fireEvent('dragend');
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

  Range.TABABLE = true;

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
    this.focus();
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

  Range.prototype._keydown = function(e) {
    var percent;
    percent = this.range * (e.shiftKey ? 0.1 : 0.01);
    switch (e.keyCode) {
      case 37:
      case 38:
        return this.value -= percent;
      case 39:
      case 40:
        return this.value += percent;
    }
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
    this.addEventListener('dragstart', this._start);
    this.addEventListener('dragmove', this._move);
    return this.addEventListener('keydown', this._keydown);
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

  Select.prototype["implements"] = [UI.iValidable];

  Select.prototype.validators = [UI.validators.required];

  Select.TAGNAME = 'select';

  Select.TABABLE = true;

  Select.MARKUP = [UI.Label.promise(), UI.Dropdown.promise()];

  Select.get('dropdown', function() {
    return this.querySelector(UI.Dropdown.SELECTOR());
  });

  Select.get('label', function() {
    return this.querySelector(UI.Label.SELECTOR());
  });

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
    e.stopImmediatePropagation();
    e.stopPropagation();
    this.select(e.target);
    return this.blur();
  };

  Select.prototype._blur = function() {
    var _ref1;
    if (this.disabled) {
      return;
    }
    return (_ref1 = this.dropdown) != null ? _ref1.close() : void 0;
  };

  Select.prototype._focus = function() {
    var _ref1;
    if (this.disabled) {
      return;
    }
    return (_ref1 = this.dropdown) != null ? _ref1.open() : void 0;
  };

  Select.prototype._keydown = function(e) {
    var index, parent;
    if ([37, 38, 39, 40].indexOf(e.keyCode) === -1) {
      return;
    }
    parent = this.selectedOption.parentNode;
    index = this.selectedOption.index();
    switch (e.keyCode) {
      case 37:
      case 38:
        e.preventDefault();
        return this.select(parent.children[(--index).clamp(0, parent.children.length - 1)]);
      case 39:
      case 40:
        e.preventDefault();
        return this.select(parent.children[(++index).clamp(0, parent.children.length - 1)]);
    }
  };

  Select.prototype.initialize = function() {
    this.name = this.getAttribute('name');
    this.addEventListener('DOMNodeRemoved', this._nodeRemoved);
    this.addEventListener('DOMNodeInserted', this._nodeAdded);
    this.addEventListener(UI.Events.action, this._select);
    this.addEventListener('blur', this._blur);
    this.addEventListener('focus', this._focus);
    this.addEventListener('keydown', this._keydown);
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
    if (this.selectedOption === selected) {
      return;
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

  Textarea.prototype.validators = UI.Text.prototype.validators;

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

  Toggle.MARKUP = [UI.promiseElement('div', {}, ['ON']), UI.promiseElement('div'), UI.promiseElement('div', {}, ['OFF'])];

  Toggle.prototype._keydown = function(e) {
    if ([37, 38, 39, 40].indexOf(e.keyCode) === -1) {
      return;
    }
    switch (e.keyCode) {
      case 37:
      case 38:
        return this.checked = false;
      case 39:
      case 40:
        return this.checked = true;
    }
  };

  Toggle.prototype.initialize = function() {
    Toggle.__super__.initialize.apply(this, arguments);
    return this.addEventListener('keydown', this._keydown);
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
    return this.open();
  };

  Tooltip.prototype._leave = function() {
    if (this.parentNode.hasAttribute('disabled') || this.disabled) {
      return;
    }
    return this.close();
  };

  Tooltip.prototype._toggle = function() {
    if (this.parentNode.hasAttribute('disabled') || this.disabled) {
      return;
    }
    return this.toggle();
  };

  Tooltip.prototype.onAdded = function() {
    var _this = this;
    Tooltip.__super__.onAdded.apply(this, arguments);
    this.parentNode.addEventListener(UI.Events.enter, this._enter.bind(this));
    this.parentNode.addEventListener(UI.Events.leave, this._leave.bind(this));
    return this.parentNode.addEventListener('keydown', function(e) {
      if (e.altKey) {
        return _this._toggle();
      }
    });
  };

  Tooltip.prototype.initialize = function() {
    return Tooltip.__super__.initialize.call(this, ['top', 'bottom', 'left', 'right']);
  };

  return Tooltip;

})(UI.iOpenable);


/***  components/ui-view  ***/

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

UI.View = (function(_super) {
  __extends(View, _super);

  function View() {
    _ref = View.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  View.prototype._addEvents = function() {
    var method, selector, type, _ref1, _ref2, _results;
    _ref1 = this.events;
    _results = [];
    for (type in _ref1) {
      method = _ref1[type];
      if (type.match(/\s/)) {
        _ref2 = type.split(/\s/), type = _ref2[0], selector = _ref2[1];
        if (UI.Events[type]) {
          type = UI.Events[type];
        }
        _results.push(this.delegateEventListener(type, selector, this[method].bind(this)));
      } else {
        if (UI.Events[type]) {
          type = UI.Events[type];
        }
        _results.push(this.addEventListener(type, this[method].bind(this)));
      }
    }
    return _results;
  };

  View.prototype.initialize = function() {
    return this._addEvents();
  };

  return View;

})(UI.Abstract);


/***  core/mui  ***/

UI.initialize();
