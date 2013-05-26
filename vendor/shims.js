// IE8 - Console polyfill
if (window.console == null) {
  window.console = {
    log: function() {},
    warn: function() {},
    info: function() {}
  };
}

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
    if(isTouch){
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