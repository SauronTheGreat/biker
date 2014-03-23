Template.admin.phase1Init = ()->
  Meteor.call "phase1Play",(err,result)->
    if !result 
      $(".currentTask").html(Template.startPhase1());
    else
      $(".currentTask").html(Template.stopPhase1());
      
Template.admin.events 
  'click .startPhase1':(e)->
      console.log "init"
      Meteor.call "initPhase1"
      $(".currentTask").html(Template.stopPhase1());
      false

Template.admin.events       
  'click .stopPhase1':(e)->
      Meteor.call "stopPhase1"
       