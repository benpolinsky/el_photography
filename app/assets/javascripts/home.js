jQuery(document).ready(function() {
  $('.grid-item-main-image').lazyload({
    threshold: 1000
  });

  
  
  // Photo Modals
  var inst = $('[data-remodal-id=modal]').remodal({
    hashTracking: false,
    closeOnOutsideClick: true
  });
  
  $('img.photo-modal-trigger').on('click', function(event) {
    $('.image-modal-container img').attr('src', $(this).data('original-image-url'));
    inst.open();
  });


  $(document).on('closing', '.remodal', function (e) {
    $('.image-modal-container img').attr('src', '');
  });

});
