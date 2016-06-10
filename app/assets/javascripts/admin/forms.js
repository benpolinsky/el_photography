$(document).ready(function() {
  var loader = modulejs.require('loader');
  $('form.patience').on('submit', function(event) {
    if (typeof submitting == 'undefined') {
      loader.start();
      submitting = true;
      $(this).submit();
      return false      
    } else {
      delete submitting;
    }
  });
  
  $(".best_in_place").best_in_place();
});
