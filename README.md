
## README / TODO


- Templating:

- I need to make it so the page is not dynamic so that the magic that happens behind the scenes to
  select the resource for custom fields doesn't switch mid-edit.

- About/Contact bootstrap (abstract scaffold - custom fields)

- Show image if it exists in custom fields.

- abstract resources error (admin index)

- contact add form

- Css saving needs to be resilliant - think about a way to handle that.

#### Admin:


### on deploy
- custom css persistence - it's the first time saving after deploy... i dont know.. something liek that
- airbrake (production, working?) - will have to test
- corner update/saving thingy for ajax backend rather than big loader
- modal mobile fix
- faster typekit

# now
- smaller cart?
- foreign key photos product violation (probably better to warm el)
- ability to go back to addresses if on payment step in checkout..
- parsley maybe too much stuff?
- admin photos index - it would probably be a good idea to dynamically create each selectize as needed, otherwise you're calling tags a bazillion times.
- clean up checkout view -> checkoutviewmodel
- local loaders for cart + payment rather than the large loaders you are using...maybe buttons.
- test out of stock functionality

# Later
- admin product show -> up it to preview?
- add loader to caption editing?
- look into button loader... youve got it if you want it

## CSS
- Perhaps lint or other safety check?
- Clean up past stylesheets in public directory
- after deploy, the css file turns up a 404
- namespace everything within a body tag, or at least add the theme to the body
- test in production env
- css to aws

### Qs for el
- under product in indiviidual page?  maybe other prints?
- is there a different name you'd like used for 'products'  prints?



---


# As a Gem.../ Refactoring
- Now that you've got a few views, you can extract common logic to a parent class, probably abstract but maybe not.
- nicer parsley errors
- nicer localized slider (for cart etc)
- better null/stale_line_item and support for deleted variants
- continue to work on ProductView
- move payment processesing to a background job 
 
- Webhooks + IPNs aren't necessary for basic payments...
 - Subscriptions, yes they are. (both paypal and stripe)
 - eChecks(paypal)
 - disputes, etc (stripe)
 - So, it'd be a plugin, or perhaps there's one out there already. 
 
- Comparison to other gems:
 - ActiveMerchant is HUGE and OLD - this gem will never support 100+ gateways.  
   - I probably won't get past 5: a couple of paypal implementations, stripe, braintree, coinbase, maybe open source bitcoin API
   - it also has no dependencies on legacy code or gateways
 - ActiveMerchant doesn't support two-step payment gateways that require interaction from the user
   - i.e. bitcoin, or paypal pay on paypal site.

 - acts_as_shopping_cart's scope is too narrow