Template.homepage.events
  'click #startGame':(e)->
    if Meteor.user()?
      Router.go("phase1")
    else
      Router.go("details")
    return false;