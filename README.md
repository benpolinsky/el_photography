- touch up about/contact
- 'choose a photo area' in admin lazily load images.
- better way of querying front photos
  - group_by perhaps
- lazily load images on main pages.
- google analytics
- stripe + paypal test 
- go live and test when el is ready
- emails/sidekiq make sure
- setup emails and prints@elliotpolinsky.com for support on store stuff
## README / TODO


- Templating:

- re: the select at the top: I need to make it so the page is not dynamic so that the magic that happens behind the scenes to
  select the resource for custom fields doesn't switch mid-edit. 

- contact add form

- Css saving needs to be resilliant - think about a way to handle that.

#### Admin:


### on deploy
- faster typekit?

# now
- smaller cart? (mobile)
- ability to go back to addresses if on payment step in checkout..
- parsley maybe too much stuff? - check out mobile
- clean up checkout view -> checkoutviewmodel
- local loaders for cart + payment rather than the large loaders you are using...maybe buttons.
- paper trail for css?


# Later
- admin product show -> up it to preview?
- add loader to caption editing?
- look into button loader... youve got it if you want it

---


# As a Gem.../ Refactoring
- gem ideas: either extend avdi's naught gem to handle rails errors
or
- is there a google analytics gem that imports basic reporting into your backend? 
  - i hate the GA dashboard - it sucks

- In general this seems like a basic enough portfolio-ecommerce site:
  _extract as much as possible__

- Think about if your 'views' are useful.
- nicer parsley errors
- better null/stale_line_item and support for deleted variants
- continue to work on ProductView - if you're keeping your views at all0
- test out of stock functionality
- move payment processesing to a background job 

- Webhooks + IPNs aren't necessary for basic payments...
 - Subscriptions, yes they are. (both paypal and stripe)
 - eChecks(paypal)
 - disputes, etc (stripe)
 - So, it'd be a plugin, or perhaps there's one out there already. 
