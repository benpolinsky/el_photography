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
  var toolbarStates = {
    none: [],
    basic: ['bold', 'italic', 'underline', 'anchor', 'h2', 'h3', 'quote'],
    full: ['bold', 'italic', 'underline', 'strikethrough', 'superscript', 'subscript', 'orderedlist', 'unorderedlist', 'indent', 'outdent', 'justifyCenter', 'justifyLeft', 'justifyFull', 'justifyRight', 'anchor', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'quote', 'pre', 'removeFormat']
  }
  var editor = new MediumEditor('.medium-editor', {
    toolbar: {
      buttons: toolbarStates["basic"]
    }
  });  

});
$(document).ready(function() {

});
