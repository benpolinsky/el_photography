modulejs.define('cart', function () {
  var Cart = {
    close: function () {
      $('.cart-slice').removeClass('active');
    },
    
    open: function () {
      $('.cart-slice').addClass('active');
    },
    
    is_open: function () {
      return $('.cart-slice').hasClass('active');
    },
    
    is_closed: function () {
      return !this.is_open();
    },
    
    clear: function () {
      $(".item-slice").remove();
    },
    
    append_item_to_cart: function (cart_item_quantity, cart_item_id, item_partial, add_to_cart_partial, display_quantity_partial, cart_totals_partials) {
      $('.cart-checkout').removeClass('disabled');
      if (cart_item_quantity > 1) {
        this.change_quantity(cart_item_id, item_partial, add_to_cart_partial, display_quantity_partial, cart_totals_partial, cart_item_quantity);
      } else {
        $('.cart-line-items').append('<div class="item-slice slice" id="cart_item_'+cart_item_id+'"> ' + item_partial + ' </div>');
        this.update_counts_and_totals(cart_item_quantity, cart_totals_partial);
      }
    },
    
    update_counts_and_totals: function (cart_item_quantity, cart_totals_partial) {
      if (cart_item_quantity == 0) {
        $("#cart-totals").remove();
      } else{
        $('#total-slices').html(cart_totals_partial);
      }
    },
    
    change_quantity: function (item, cart_item_partial, add_to_cart_partial, display_quantity_partial, cart_totals_partial, cart_item_quantity) {
      $("#cart_item_" + item).html(cart_item_partial);
      $('.add-to-cart-container').html(add_to_cart_partial);
      $('.listing-quantity-container').html(display_quantity_partial);
      this.update_counts_and_totals(cart_item_quantity, cart_totals_partial);
    }
    
  }
  
  return Cart
});