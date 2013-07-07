if(!HTMLElement.prototype.click){
  HTMLElement.prototype.click = function(){
    var event = document.createEvent("MouseEvent");
    event.initEvent('click', true, true);
    this.dispatchEvent(event);
    return event;
  };
}
