modulejs.define('loader', function () {
  var Loader = {
    start: function () {
      $('span.loader').addClass('active');      
    },
    
    stop: function () {
      $('span.loader').removeClass('active');
    }
  }
  return Loader
})