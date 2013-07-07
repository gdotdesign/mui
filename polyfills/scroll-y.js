if (!('scrollY' in window)) {
  Object.defineProperty(window, 'scrollY', {
    get: function() {
      if (document.documentElement) {
        return document.documentElement.scrollTop;
      }
    }
  });
}