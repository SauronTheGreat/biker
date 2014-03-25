Meteor.startup ->
  Accounts.ui.config
    passwordSignupFields: "USERNAME_AND_OPTIONAL_EMAIL"
  @currentBid = ""
  Meteor.subscribe("userData");


    
  