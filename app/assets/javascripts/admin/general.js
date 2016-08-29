$(document).ready(function() {
  flatpickr('.elp-date-field');
  $('[data-toggle="tooltip"]').tooltip();
  $('.destroy.tooltip-disabled').on('click', function(event) {
    return false
  });
  $('.select-product-photo img').lazyload();
  // var els = document.getElementsByClassName('destroy');
  // console.log(els);
  // [].forEach.call(document.getElementsByClassName('destroy'), function (el, index, a) {
 //    new Tooltip({
 //      target: el,
 //      position: "top left",
 //      content: "Can't delete a photo attached to a print!"
 //    });
 //  });
});


