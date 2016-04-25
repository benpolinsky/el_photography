jQuery(document).ready(function($) {
  var input_name = $('input[type="file"]').first().attr('name');
  console.log(input_name);
  Dropzone.options.newPhoto = {
    paramName: input_name, // The name that will be used to transfer the file
    maxFilesize: 2, // MB
    accept: function(file, done) {
      if (file.name == "justinbieber.jpg") {
        done("Naha, you don't.");
      }
      else { done(); }
    }
  };
});
