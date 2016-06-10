$(document).ready(function() {
  var loader = require("./loader");
  window.loader = loader;
  $('form.patience').on('submit', function(event) {
    if (typeof submitting == 'undefined') {
      loader.start();
      submitting = true;
      $(this).submit();
      return false      
    } else {
      submitting = undefined;
    }
  });
});
