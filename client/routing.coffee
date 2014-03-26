Router.map ->
  @route "home",
    path:'/'
    template:"homepage"

  @route "admin",
    path:'/admin'
    template:"admin"
    before:()->
      if Meteor.user()?
        if Meteor.user().profile.admin
          this.template = "admin"
      else
        this.template ="adminLogin"
        
  @route "teamSelect",
    path:'/admin/selectTeams'
    template:"teamSelection"
    before:()->
      if Meteor.user()?
        if Meteor.user().profile.admin
          this.template = "teamSelection"
      else
        this.template ="adminLogin"
        
  @route "activateBidding",
    path:'/admin/activatebidding'
    template:"activateBidding"
    before:()->
      if Meteor.user()?
        if Meteor.user().profile.admin
          this.template = "activateBidding"
      else
        this.template ="adminLogin"


  @route "details",
    path:'/mydetails'
    template:"myDetails"
  @route "phase1",
    before:()->
      #This is to handle the case of user types in the url, a non authenticated user cannot enter the game!
      if !Meteor.user()?
        Router.go("home")
      else
        #now since a user is present, we check if she is admin or player
        this.template = "phase1"
          
    path:"/phase1"
    template:"phase1"
    
  @route "phase1play",
    before:()->
      #This is to handle the case of user types in the url, a non authenticated user cannot enter the game!
      if !Meteor.user()?
        Router.go("home")
      else
        #now since a user is present, we check if she is admin or player
        this.template = "phase1play"
          
    path:"/phase1play"
    template:"phase1play"
    
  @route "phase2",
    before:()->
      #This is to handle the case of user types in the url, a non authenticated user cannot enter the game!
      if !Meteor.user()?
        Router.go("home")
      else
        #now since a user is present, we check if she is admin or player
        this.template = "phase2"
          
    path:"/phase2"
    template:"phase2"
    
  @route "phase2play",
    before:()->
      #This is to handle the case of user types in the url, a non authenticated user cannot enter the game!
      if !Meteor.user()?
        Router.go("home")
      else
        #now since a user is present, we check if she is admin or player
        this.template = "phase2play"
          
    path:"/phase2play"
    template:"phase2play"

  @route "phase2results",
    path:"/admin/p2results"
    template:"phase2results"
    