var Cart = modulejs.require('cart');
$(document).keyup(function (e) {
  if (e.keyCode == 27) {
    Cart.close();
  }
});

jQuery(document).ready(function($) {
  
  $('header.front-header').on('click', '#cart-trigger', function(event) {
    Cart.open();
  });

  
});
