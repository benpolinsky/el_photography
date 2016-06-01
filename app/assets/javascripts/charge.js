$(document).ready(function() {
  // $('#exp-year').hide();
  // $('#exp-month').hide();

  $('#card_month').change(function () {
    var month = $(this).val();
    $('#exp-month').val(month);
  });

  $('#card_year').change(function () {
    var year = $(this).val();
    $('#exp-year').val(year);
  });
  
  $('form#submit-payment').submit(function (event) {
    var $form = $(this);
    $form.find('input[type="submit"]').prop('disabled', true);
    $form.find('input[type="submit"]').attr('data-disable-with', '<i class="fa fa-spinner fa-spin"></i>Paying…');
    Stripe.createToken($form, stripeResponseHandler);
    return false;
  });
  
  
  $('input[name="paypal"]').on('click', function(event) {
    event.preventDefault();
    $('form#submit-payment').append($("<input type='hidden' name='paypal' />").val('true'));
    $('form#submit-payment').get(0).submit();
    return false;
  });
  // $('.country-field').chosen({
  //  disable_search: false,
  //  width: '100%'
  // });
});


var stripeResponseHandler = function (status, response) {
  var $form = $('form#submit-payment');
  if (response.error) {
    $form.find(".payment-errors").text(response.error.message);
    $form.find('input[type="submit"]').prop('disabled', false);
  }else {
    var token = response.id;
    $form.data("remote", 'true');
    $form.append($("<input type='hidden' name='stripeToken' />").val(token));
    $form.get(0).submit();
  }
}
