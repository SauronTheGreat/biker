Fiber = Npm.require('fibers');
status = new Meteor.Collection("status");
timeout = 0
create_timeout = ()->
  if timeout isnt 0
    clear_timeout();
  timeout = Meteor.setTimeout(->
    a = auctionDone.findOne()
    auctionDone.update({_id:a._id},{$set:{done:true}})
    
  , 60000)
  
  
clear_timeout = ()->
  Meteor.clearTimeout(timeout)
  
  

Meteor.startup ->
  currentBidItem.remove({})
  auctionDone.remove({})
  auctionDone.insert({done:false})
  if status.find().fetch().length isnt 1
    status.remove({});
    status.insert({phase1:false,phase2:false})
  if  Meteor.users.find({"profile.admin":true}).fetch().length is 0
    #creat an admin user only if it doesnt exist!!!
     createAdmin()
  return

createAdmin = ()->
  #this creates an admin user
   Accounts.createUser({email:"admin@ptotem.com",password:"password",profile:{admin:true}});

Meteor.methods
  phase1Play: () ->
    status.findOne().phase1
  phase2Play: () ->
    status.findOne().phase2
     
  initPhase1:()->

    if Meteor.users.findOne({_id:this.userId}).profile.admin
      s = status.findOne();
      status.update({_id:s._id},{$set:{phase1:true}})
  
  stopPhase1:()->
    if Meteor.users.findOne({_id:this.userId}).profile.admin
      s = status.findOne();
      status.update({_id:s._id},{$set:{phase1:false,completed:"phase1"}})
      
  initPhase2:()->
    
    if Meteor.users.findOne({_id:this.userId}).profile.admin
      s = status.findOne();
      status.update({_id:s._id},{$set:{phase2:true}})
  
  stopPhase2:()->
    if Meteor.users.findOne({_id:this.userId}).profile.admin
      s = status.findOne();
      status.update({_id:s._id},{$set:{phase2:false,completed:"phase2"}})    
      
  changeBidItem:(item)->
    currentBidItem.remove({});
    currentBidItem.insert({citem:item})
    a = auctionDone.findOne()
    auctionDone.update({_id:a._id},{$set:{done:false}})

    
  bidSubmitted:()->
    
  
    create_timeout();
    return true

    
Meteor.publish "userData", ->
    return Meteor.users.find({},{fields:{profile:1}})
   
