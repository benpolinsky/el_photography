## README / TODO
- adding tags with multiple photos problem..
- clear tag input after upload finished
- reorder tags
- quick way to add or remove tag
- and quick way to add/change caption for each

- notices + errors front end?  Not sure if needed....

## The Store
 - Fill out totals, quantities, add js for quantities
 - variants to cart is no good...
 - in the above vein(s), you'll have to test out all the quantity/cart/add_to_cart options
 - cart not populating on first add
 - customer view order/receipt securely
 - validate order uid uniqueness

## Theming Support 
- very basic dynamic css added
  - Perhaps lint or other safety check?
  - Clean up past stylesheets in public directory
  - namespace everything within a body tag, or at least add the theme to the body
  - test in production env
  - eventually extract theme into gem

- wysiwig - hopefully trix, medium also an option


### Qs for el

- How are you breaking down your navigation?

# As a Gem.../ Refactoring

 - Organization, wise, any interaction between an Order and a Payment should probably occur through the checkout.  
   - Just think about it.
   - Orders don't initiate payments... even invoices don't initiate payments, they merely state how much, how, and by when it needs to be paid by
   - A Checkout initiates payments.  
   - A Checkout creates orders.
   - A Checkout updates orders with payments, etc

 - Breakdown Payment class into PaypalPayment and StripePayment subclasses so we can add many types of payment. 
 - move payment processesing to a background job 
   
 - Webhooks + IPNs aren't necessary for basic payments...
   - Subscriptions, yes they are. (both paypal and stripe)
   - eChecks(paypal)
   - disputes, etc (stripe)
   - So, it'd be a plugin, or perhaps there's one out there already. 
   
# On Live
