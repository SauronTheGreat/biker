Template.adminLogin.events
  'click #signin':(e)->
    e.preventDefault()
    email =  $("#email").val();
    pass = $("#passwordinput").val()
    Meteor.loginWithPassword(email, pass, (error)->
      if error
        alert(error)
        window.location = "/"
      else
        window.location = "/admin"
    )

Template.admin.phase1Init = ()->
  Meteor.call "phase1Play",(err,result)->
    if !result 
      $(".currentTask").html(Template.startPhase1());
    else
      $(".currentTask").html(Template.stopPhase1());


Template.admin.rendered = ->
  Meteor.call "checkPhase",(err,res)->
    if res
      $(".currentTask").html(Template.startPhase2());
    else
      $(".currentTask").html(Template.startPhase1());


Template.admin.events 
  'click .startPhase1':(e)->
      
      Meteor.call "initPhase1"
      $(".currentTask").html(Template.stopPhase1());
      false


  'click .stopPhase1':(e)->
      Meteor.call "stopPhase1"

      $(".currentTask").html(Template.startPhase2());
      Router.go("teamSelect")

        
  'click .startPhase2':(e)->
       Meteor.call "initPhase2"
       $(".currentTask").html(Template.stopPhase2());
       Router.go("activateBidding")
       false
        
  'click .stopPhase2':(e)->
      Meteor.call "stopPhase2"
    

      
Template.teamSelection.phase1results = ()->
  phaseOneData.find({}).fetch()
Template.teamSelection.getUserName = (user_id)->
  Meteor.users.findOne({_id:user_id}).profile.username

Template.teamSelection.avg = (val1, val2,val3)->
   avg = (val1+val2+val3)/3
   Math.round(avg)

Template.teamSelection.stddev = (v1,v2,v3,v4,v5,v6)->
  mean = (v1+v2+v3+v4+v5+v6)/6;
  squared_sum = (v1-mean)*(v1-mean)+ (v2-mean)*(v2-mean)+(v3-mean)*(v3-mean)+(v4-mean)*(v4-mean)+(v5-mean)*(v5-mean)+(v6-mean)*(v6-mean)
  mean_squared_sum = squared_sum/6;
  Math.round(Math.sqrt(mean_squared_sum))
nameArray = ["Engine", "Suspension", "Wheel", "Tire", "Style" ,"Frame" ]
Template.teamSelection.ratio = (v1,v2,v3,v4,v5,v6)->
  avg = (v1+v2+v3)/(v4+v5+v6)
  avg

Template.teamSelection.mostImp = (v1,v2,v3,v4,v5,v6)->
  avg = _.indexOf([v1,v2,v3,v4,v5,v6],_.max([v1,v2,v3,v4,v5,v6]))
  nameArray[avg]


Template.teamSelection.leastImp = (v1,v2,v3,v4,v5,v6)->
  avg = _.indexOf([v1,v2,v3,v4,v5,v6],_.min([v1,v2,v3,v4,v5,v6]))
  nameArray[avg]



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
      
       
#Template.phase2results.phase2data = ()->
#  console.log _.toArray(_.groupBy(phaseTwoData.find({}).fetch(),(obj)->obj.user_id))
#  final_array = []
#  teamsArray = _.toArray(_.groupBy(phaseTwoData.find({}).fetch(),(obj)->obj.user_id))
#  for t in teamsArray
#    if  t.user_id?
#      final_array.push {team:Meteor.users.findOne({_id: t.user_id}).profile.team,bid:t.bid,cat:t.bidcategory}
#  console.log final_array




Template.phase2results.getUserName = (user_id)->
  Meteor.users.findOne({_id:user_id}).profile.username
Template.phase2results.getTeamName = (user_id)->
  Meteor.users.findOne({_id:user_id}).profile.team
Template.phase2results.getData = (cat,v)->

  d  = phaseTwoData.find({bidcategory:cat.toString()}).fetch()
  if d.length > 0
    if v is 0
      if Meteor.users.findOne({_id:d[0].user_id}).profile.team is "Team A"
        return d[0].bid
      else
        return d[1].bid
    else
      if Meteor.users.findOne({_id:d[0].user_id}).profile.team is "Team A"
        return d[1].bid
      else
        return d[0].bid


Template.phase2results.getPoints = (cat,v)->

  d  = phaseTwoData.find({bidcategory:cat.toString()}).fetch()
  pts = 0
  points = _.each(phaseOneData.find({}).fetch(),(obj)->pts = pts+obj[cat])
  console.log pts

  if d.length > 0
    if d[0].bid > d[1].bid
      if v is 0
        if Meteor.users.findOne({_id:d[0].user_id}).profile.team is "Team A"
          return pts
        else
          return 0
      else
        if Meteor.users.findOne({_id:d[0].user_id}).profile.team is "Team B"
          return pts
        else
          return 0

    else
      if v is 0
        if Meteor.users.findOne({_id:d[1].user_id}).profile.team is "Team A"
          return pts
        else
          return 0
      else
        if Meteor.users.findOne({_id:d[1].user_id}).profile.team is "Team B"
          return pts
        else
          return 0



