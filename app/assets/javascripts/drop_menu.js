// drop-menu
$(document).ready(function() {
  $('.drop-menu-header').on('click', function() {
    $(this).parent().siblings('.drop-menu').removeClass('active') 
    $(this).parent().toggleClass('active');
  });
});

