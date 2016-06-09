jQuery(document).ready(function($) {
  var input_name = $('input[type="file"]').first().attr('name');
  var tags_input = $('.taggable');
  
  Dropzone.options.newPhoto = {
    paramName: input_name, // The name that will be used to transfer the file
    maxFilesize: 2, // MB
    drop: function (event) {
      tags_input[0].selectize.disable();
    },
    accept: function(file, done) {
      if (file.name == "justinbieber.jpg") {
        done("Naha, you don't.");
      }
      else { done(); }
    }
  };
});

