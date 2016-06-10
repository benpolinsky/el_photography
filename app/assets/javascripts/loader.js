modulejs.define('loader', function () {
  var Loader = {
    start: function () {
      $('#modal-overlay').addClass('open');      
    },
    
    stop: function () {
      $('#modal-overlay').removeClass('open');
    }
  }
  return Loader
});