getLastBid = ()->
  if currentBidItem.findOne()?
    x = _.max(phaseTwoData.find({bidcategory:currentBidItem.findOne().citem}).fetch(), (bids) ->
                bids.bidTime
                )
    return x
   else
      return -1
      
getTeamName = (user_id)->
  Meteor.users.findOne({_id:user_id}).profile.team
  
Template.tabContent.TeamName = (user_id)->
  getTeamName(user_id)
  

Template.phase2.events
  'click #playPhase2':(e)->
      Meteor.call "phase2Play",(err,result)->
              if result 
                 Router.go("phase2play");
              else
                 alert("wait");                      
      false
  

  
Template.phase2play.rendered = ->
  Session.set("walletRefresh",true)
  Deps.autorun ->

    if auctionDone.findOne()?
      if auctionDone.findOne().done
        $("#"+currentBidItem.findOne().citem).find(".bidVal").attr("disabled", "disabled"); 
        $("#"+currentBidItem.findOne().citem).find(".bidData").text(getTeamName(getLastBid().user_id)+" won!"); 
        
        if Meteor.userId() is getLastBid().user_id
          balanceMoney = Meteor.user().profile.wallet - getLastBid().bid
          Meteor.users.update({_id:Meteor.userId()},{$set:{"profile.wallet":balanceMoney}})
        
  
Template.phase2play.wallet = ()->

  if Meteor.user().profile.wallet?
    return Meteor.user().profile.wallet
  else
    return 100000
  
Template.phase2play.refreshWallet = ()->
  Session.equals("walletRefresh",true)
  
Template.tabContent.events
  'click #newBid':(e)->
     

      currentBid = parseInt($("#"+currentBidItem.findOne().citem).find(".bidVal").val())
      if getLastBid() is -1
        lastBid = 0
      else
        lastBid = getLastBid().bid
      balanceMoney =  parseInt($(".wallet").text())
      if  currentBid <= lastBid
        alert("You cant bid less than previous bid");
        return false
      if currentBid > balanceMoney
        alert("you cant bid more than what you have !")
        return false
      else
        phaseTwoData.insert({user_id:Meteor.userId(),bid: $("#"+currentBidItem.findOne().citem).find(".bidVal").val(),bidcategory:currentBidItem.findOne().citem,bidTime:new Date()})
        if Meteor.user().profile.wallet?
          balance = parseInt(Meteor.user().profile.wallet)-parseInt( $("#"+currentBidItem.findOne().citem).find(".bidVal").val()) 
        else
          balance = 100000-parseInt( $("#"+currentBidItem.findOne().citem).find(".bidVal").val()) 
          
        Meteor.call "bidSubmitted"
        $(".wallet").text(balance)
        false

Template.tabContent.previousBids = ()->
  if currentBidItem.findOne()?
    return phaseTwoData.find({bidcategory:currentBidItem.findOne().citem},{sort:{bidTime:-1}}).fetch() 
    
    
Template.tabContent.lastBid = ()->
  if parseInt(getLastBid()) is -1
     return 0
  else
     return getLastBid().bid
  



Template.tabContent.rendered = -> 
  
  Deps.autorun ->

  
    $(".tab-pane").removeClass("active");
    $(".tabHeader").removeClass("active");
    if currentBidItem.findOne()?
      $("#"+currentBidItem.findOne().citem).addClass("active"); 
      $("#header-"+currentBidItem.findOne().citem).addClass("active")
  