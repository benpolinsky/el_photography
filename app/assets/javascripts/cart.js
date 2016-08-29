modulejs.define('cart', function () {
  var Cart = {
    open: function () {
      var loader = modulejs.require('loader');
      loader.start(false);
      $('.cart-slice').addClass('active');
      $('body').addClass('cart-open');
    },
    
    close: function () {
      var loader = modulejs.require('loader');
      $('.cart-slice').removeClass('active');
      $('body').removeClass('cart-open');
      loader.stop();
    },
    
    is_open: function () {
      return $('.cart-slice').hasClass('active');
    },
    
    is_closed: function () {
      return !this.is_open();
    },
    
    toggle: function () {
      if (this.is_open()) {
        this.close();
      } else {
        this.open();
      }
    },
    
    clear: function () {
      $(".item-slice").remove();
    },
    
    line_items_count: function () {
      return $('.item-slice').length;
    },
    
    append_item_to_cart: function (cart_item_quantity, cart_item_id, item_partial, add_to_cart_partial, display_quantity_partial, cart_totals_partials) {
      $('.cart-checkout').removeClass('disabled');
      $('.nothing-here-container').remove();
      if (cart_item_quantity > 1) {
        this.change_quantity(cart_item_id, item_partial, add_to_cart_partial, display_quantity_partial, cart_totals_partial, cart_item_quantity);
      } else {
        $('.cart-line-items').append('<div class="item-slice slice" id="cart_item_'+cart_item_id+'"> ' + item_partial + ' </div>');
        this.update_counts_and_totals(cart_item_quantity, cart_totals_partial);
      }
    },
    
    update_counts_and_totals: function (cart_item_quantity, cart_totals_partial) {
      if (this.line_items_count() == 0) {
        $("#total-slices").remove();
      } else{
        $('#total-slices').html(cart_totals_partial);
      }
    },
    
    change_quantity: function (item, cart_item_partial, add_to_cart_partial, display_quantity_partial, cart_totals_partial, cart_item_quantity) {
      if (cart_item_quantity == 0) {
        $("#cart_item_" + item).remove();
      } else {
        $("#cart_item_" + item).html(cart_item_partial);        
      }
      $('.add-to-cart-container').html(add_to_cart_partial);
      $('.listing-quantity-container').html(display_quantity_partial);
      this.update_counts_and_totals(cart_item_quantity, cart_totals_partial);
      if (this.line_items_count() == 0) {
        this.close();        
      }

    },

    // I think the variant functionality deserves its own module/class
    // and also the drop menu
    initialize_variants: function () {
      $('input.add-to-cart.variant').prop('disabled', true);
      var that = this;
      $('.drop-menu-item').on('click', function(event) {
        that.select_variant_item(this);
      });
    },
    
    select_variant_item: function (el) {
      var item_name = $(el).data("item-name");
      var item_id = $(el).data("item-id");
      var header = $(el).parent().siblings('.drop-menu-header');
      var product_option_name = $(el).data("product-option");
      var hidden_field = '<input type="hidden" class="' + product_option_name + '" name="line_item[variant_option_values_ids][]" id="line_item_variant_option_values_ids_' + item_id + '" value="' + item_id + '">';

      // mark the option as selected
      $(el).addClass("selected");
    
      // remove any selected classes from sibling options
      $(el).siblings().removeClass('selected');
      header.addClass('selected');
      // change the select dropdown header text
      // header.text(product_option_name + ": " + item_name);
      

      
      // when we select an option we add it's value to the hidden field, if it exists
      // if not, we append the hidden field which we've already populated with our selected value
    
      if ($('input.' + product_option_name).length > 0) {
        $('input.' + product_option_name).val(item_id);
      } else{
        $('form.add-item-to-cart').append(hidden_field);      
      }

      // mark this drop down as selected if not already    
      if (!$(el).parent().parent().hasClass('selected')) {
        $(el).parent().parent().addClass('selected');
      }
      
      // enable the add-to-cart button and change the hidden select if all options selected
      var not_selected = $(el).parents('.item-quantity-and-options').children('.drop-menu.product-option:not(.selected)');
      if ($('.drop-menu.product-option:not(.selected)').length == 0) {
        var selected_unique_key = "";
        $('.item-quantity-and-options .drop-menu-item.selected').each(function(index) {
          if (index != 0) {selected_unique_key += "_"};
          selected_unique_key += $(this).data('item-id');
        });
        $('#line_item_variant_id option').prop("selected", false);
        $selected_option = $('option[data-unique-key=' + selected_unique_key + ']');
        if ($selected_option.length > 0){
          $selected_option.prop('selected', true);
          this.append_quantity($selected_option.attr('data-quantity'));
          this.append_price($selected_option.attr('data-price'));
          this.change_image($selected_option.attr('data-image'));
          $('input.add-to-cart.variant').prop('disabled',false);
        } else {
          this.reset_variants();
        }
        
      
      }
    
      $(el).parent().parent().removeClass('active');
    },
    
    append_quantity: function (quantity) {
      var quantity_text = quantity + ' left'
      $('.listing-quantity-container span.quantity').text(quantity_text);
    },
    
    append_price: function (price) {
      $('span.product-view-price').text(price);
    },
    
    change_image: function (image_src) {
      var $current_image = $('.grid-item-main-image');
      
      if (image_src !== $current_image.attr('src')) {
        $current_image.attr('src', image_src);        
      }
    },
    
    reset_variants: function () {

      $('.drop-menu.product-option').each(function () {
        $('.drop-menu.product-option').removeClass('selected');
        $menu_items = $(this).find('.drop-menu-item');
        $first_item = $menu_items.first();
        $menu_items.removeClass('selected');
        $first_item.addClass('selected');
        $(this).find('.drop-menu-heading').text($first_item.data('product-option'));
      });
    }
    
  }
  
  return Cart
});