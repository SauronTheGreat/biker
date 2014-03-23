Template.phase2.events
  'click #playPhase2':(e)->
    Router.go("phase2play");
    false
Template.tabContent.events
  'click #newBid':(e)->
    phaseTwoData.insert({user_id:Meteor.userId(),bid:$("#newBidVal").val(),bidcategory:"engine",bidTime:new Date()})
    false
    
Template.tabContent.previousBids = ()->
   phaseTwoData.find({}).fetch()
    
    
Template.tabContent.lastBid = ()->
  x = _.max(phaseTwoData.find({}).fetch(), (bids) ->
            bids.bidTime
            )
  x.bid