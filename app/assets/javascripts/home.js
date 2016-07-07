jQuery(document).ready(function() {
  $('select.change-photo-size').change(function(event) {
    var prefix = "changed_";
    var classes = $('.changeable-grid')[0].className.split(" ").filter(function(c) {
        return c.lastIndexOf(prefix, 0) !== 0;
    });
    $('.changeable-grid')[0].className = classes.join(" ").trim();
    $('.changeable-grid').addClass('changed_' + $(this).val());
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
    console.log('Modal is closing' + (e.reason ? ', reason: ' + e.reason : ''));
  });

});
