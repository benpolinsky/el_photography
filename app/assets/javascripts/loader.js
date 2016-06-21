modulejs.define('loader', function () {
  var Loader = {
    start: function (spinner, opacity) {
      
      if (typeof spinner == undefined) var spinner = true;
      if (typeof opacity == undefined) var opacity = 0.8;
      
      if (spinner == false) {
        $('#modal-overlay .loader').addClass('hidden');
        $('#modal-overlay #load-spin').addClass('hidden');
      } else {
        $('#modal-overlay .loader').removeClass('hidden');
        $('#modal-overlay #load-spin').removeClass('hidden');
      }
      
      $('#modal-overlay').addClass('open');          
    },
    
    stop: function (spinner) {
      if (typeof spinner == undefined) var spinner = false;
      
      // only remove spinner, leave greyout if true
      if (spinner == true) {
        $('#modal-overlay .loader').addClass('hidden');
        $('#modal-overlay #load-spin').addClass('hidden');
      } else {
        $('#modal-overlay').removeClass('open');  
      }
      
    }
  }
  return Loader
});