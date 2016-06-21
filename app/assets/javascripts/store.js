(function() {
  var Cart = modulejs.require('cart');
  var Loader = modulejs.require('loader');
  $(document).keyup(function (e) {
    if (e.keyCode == 27) {
      Cart.close();
    }
  });

  jQuery(document).ready(function($) {
  
    $(document).on('click', '.cart-trigger', function(event) {
      Cart.toggle();
      return false
    });
    
    $('.close-cart').on('click', function () {
      Cart.close();
      return false
    })
    

    Cart.initialize_variants();
    
    $('.cart-slice').on('click', '.increment-quantity', function () {
      Loader.start(true);
    });
    
    $('.cart-slice').on('click', '.decrement-quantity', function () {
      Loader.start(true);
    });
    
    
    $('#modal-overlay').on('click', function () {
      if (!$('body').hasClass('loading') && $('body').hasClass('cart-open')) Cart.close();
    })
  });
  
}());
