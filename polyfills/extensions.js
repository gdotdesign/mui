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
