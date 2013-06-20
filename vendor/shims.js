// IE8 - Console polyfill
if (window.console == null) {
  window.console = {
    log: function() {},
    warn: function() {},
    info: function() {}
  };
}
// Request Animation Frame
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

// matchesSelector PolyFill
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

if(!HTMLElement.prototype.click){
  HTMLElement.prototype.click = function(){
    var event = document.createEvent("MouseEvent");
    event.initEvent('click', true, true);
    this.dispatchEvent(event);
    return event;
  };
}
Function.prototype.bind = Function.prototype.bind || function(to){
    // Make an array of our arguments, starting from second argument
  var partial = Array.prototype.splice.call(arguments, 1),
    // We'll need the original function.
    fn  = this;
  var bound = function (){
    // Join the already applied arguments to the now called ones (after converting to an array again).
    var args = partial.concat(Array.prototype.splice.call(arguments, 0));
    // If not being called as a constructor
    if (!(this instanceof bound)){
      // return the result of the function called bound to target and partially applied.
      return fn.apply(to, args);
    }
    // If being called as a constructor, apply the function bound to self.
    fn.apply(this, args);
  }
  // Attach the prototype of the function to our newly created function.
  bound.prototype = fn.prototype;
  return bound;
};

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

if (!('scrollY' in window)) {
  Object.defineProperty(window, 'scrollY', {
    get: function() {
      if (document.documentElement) {
        return document.documentElement.scrollTop;
      }
    }
  });
}

Element.prototype.getPosition = function() {
  var rect;
  rect = getComputedStyle(this);
  return new Point(parseInt(rect.left), parseInt(rect.top) + window.scrollY);
};

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