Template.admin.phase1Init = ()->
  Meteor.call "phase1Play",(err,result)->
    if !result 
      $(".currentTask").html(Template.startPhase1());
    else
      $(".currentTask").html(Template.stopPhase1());
      
Template.admin.events 
  'click .startPhase1':(e)->
      
      Meteor.call "initPhase1"
      $(".currentTask").html(Template.stopPhase1());
      false


  'click .stopPhase1':(e)->
      Meteor.call "stopPhase1"
      $(".currentTask").html(Template.startPhase2());
        
  'click .startPhase2':(e)->
       Meteor.call "initPhase2"
       $(".currentTask").html(Template.stopPhase2());
       Router.go("activateBidding")
       false
        
  'click .stopPhase2':(e)->
      Meteor.call "stopPhase2"
    

      
Template.teamSelection.phase1results = ()->
  phaseOneData.find({}).fetch()
  
Template.teamSelection.events
    'click #createTeams':(e)->
        teama  = []
        teamb = []
        $(".team").each (index,elm)->
            if $(elm).is(":checked")
              if $(elm).val() is "a"
                teama.push $(elm).attr("name")
              
                Meteor.call "updateUserTeam",$(elm).attr("name"),"Team A"
              
              else
                teamb.push $(elm).attr("name")
                Meteor.call "updateUserTeam",$(elm).attr("name"),"Team B"
        
        teamOne.insert({users:teama})
        teamTwo.insert({users:teamb})
        Router.go("admin") 
        
Template.activateBidding.events
    'click .activateBid':(e)->
        
        Meteor.call "changeBidItem",$(e.currentTarget).attr("id")
        $(e.currentTarget).hide()
      
       
      