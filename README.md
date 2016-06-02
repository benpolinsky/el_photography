## README / TODO
- adding tags with multiple photos problem..
- clear tag input after upload finished
- reorder tags
- quick way to add or remove tag
- and quick way to add/change caption for each

- shop: 
 - Wizard. 
 - parsley
 - Fill out totals, quantities, add js for quantities, etc (cart etc)
 - order id to uid to obfuscate id
 - variants to cart is no good...
 - boolean of whether or not quantity is being used
 - in the above vein(s), you'll have to test out all the quantity/cart/add_to_cart options
 - the checkout wizard should be reimplemented with json as opposed to erbs and partials, after.
 - Better storage of orders

- Payments: 
  - IPN + Webhooks
  

- friendly id with changeable/updateable w/ history slugs
- notices + errors both front and back end
- very basic dynamic css added
  - Perhaps lint or other safety check?
  - Clean up past stylesheets in public directory
  - namespace everything within a body tag, or at least add the theme to the body
  - test in production env
  - eventually extract theme into gem

- wysiwig - hopefully trix, medium also an option

### Qs

- How are you breaking down your navigation?

Distinct Shop: (with ability to link from photos, so ability to link a product to a photo):
- No tags in shop to start.
- List of photos with a few sizes and then each size would have to have a unique photo.
- So each photo must have a size
- PayPal to start then move to stripe

Products, Variants, Options, OptionValues, LineItems, Carts added to store

Need:
Order
Payment (see min+weisscoach)



Clean up Minerality's Order System:

Order Machine becomes Checkout - Handles the mixing of Orders/Payments/Carts etc (anything a checkout world)

CheckoutView, if I need it, will handle the front end of checkouts
CheckoutController will take the place of OrderWizard, moving most of the logic back into the Checkout Class
StateMachine stays on Order (bc it's the order's state)
