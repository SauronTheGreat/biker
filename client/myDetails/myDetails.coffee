Template.myDetails.events
  'click #register':(e)->
    #this is the function which registers a user
    username = $("#newUser").find("#name").val();
    
    profession = $("#newUser").find("#profession").val();
    age = $("#newUser").find("#age").val();
    Accounts.createUser({username : username,password : "password",profile:{username:username,profession:profession,age:age,wallet:100000}},(error)->
        if error
          console.log error
        else
           Router.go("phase1")
      )

    false
