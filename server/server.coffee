
status = new Meteor.Collection("status");

Meteor.startup ->
    
    
  if status.find().fetch().length isnt 1
    status.remove({});
    status.insert({phase1:false,phase2:false})
  if  Meteor.users.find({profile:{admin:true}}).fetch().length is 0
    #creat an admin user only if it doesnt exist!!!
    createAdmin()
  return

createAdmin = ()->
  #this creates an admin user
   Accounts.createUser({email:"admin@ptotem.com",password:"password",profile:{admin:true}});

Meteor.methods
  phase1Play: () ->
    status.findOne().phase1
     
  initPhase1:()->
    console.log "init"
    if Meteor.users.findOne({_id:this.userId}).profile.admin
      s = status.findOne();
      status.update({_id:s._id},{$set:{phase1:true}})
  
  stopPhase1:()->
    if Meteor.users.findOne({_id:this.userId}).profile.admin
      s = status.findOne();
      status.update({_id:s._id},{$set:{phase1:false,completed:"phase1"}})
    
