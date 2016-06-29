jQuery(document).ready(function($) {
  $(".taggable").selectize({
    delimiter: ",",
    create: true,
    allowEmptyOption: true
  });
});

