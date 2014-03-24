get_total_points  = ()->
  total = 0
  $("input[type=number]").each (index,elm)->
           total = total + parseInt($(elm).val());
  total
  
get_data_hash = ()->
  final_data = {};
  $("input[type=number]").each (index,elm)->
           final_data[$(elm).attr("id").toString()] = parseInt($(elm).val());
  final_data["user_id"] = Meteor.userId();
  final_data["created_at"] = new Date();
  final_data

  
  
Template.phase1.events
  'click #playPhase1':(e)->
      Meteor.call "phase1Play",(err,result)->
              if result 
                 Router.go("phase1play");
              else
                 alert("wait");                      
      false
Template.phase1play.events
  'keypress input[type=number]':(e)->
    total = 0;
    setTimeout (->
                 $(".totalPoints").text(100-parseInt(get_total_points()))

                
    ), 100
    
  'click .submitPhase1':(e)->
    if get_total_points() isnt 100
      alert("total must be 100")
      return false
    else
      phaseOneData.insert(get_data_hash())
      alert("Recorded");
      Router.go("phase2")
    
      