$(document).ready(function() {
  let Loader = require("loader");
  var new_loader = new Loader();
  var submitting = false;
  $('form.patience').on('submit', function(event) {
    if (submitting == false) {
      new_loader.start();
      submitting = true;
      $(this).submit();
      return false      
    } else {
      submitting = false;
    }
  });
});
