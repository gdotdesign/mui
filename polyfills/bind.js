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