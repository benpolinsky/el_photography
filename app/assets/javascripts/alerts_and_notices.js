jQuery(document).ready(function($) {
  $('span.close').on('click', function() {
    $('#alerts_and_notices.active').removeClass('active');
  });
});
