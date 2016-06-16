(function() {
  var Cart = modulejs.require('cart');
  var Loader = modulejs.require('loader');
  $(document).keyup(function (e) {
    if (e.keyCode == 27) {
      Cart.close();
    }
  });

  jQuery(document).ready(function($) {
  
    $('header.front-header').on('click', '.cart-trigger', function(event) {
      Cart.open();
      return false
    });
    
    $('.close-cart').on('click', function () {
      Cart.close();
      return false
    })

    Cart.initialize_variants();
    
    $('.cart-slice').on('click', '.increment-quantity', function () {
      Loader.start();
    });
    
    $('.cart-slice').on('click', '.decrement-quantity', function () {
      Loader.start();
    });
  });
  
}());
