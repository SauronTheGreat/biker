Template.myDetails.events
  'click #register':(e)->
    #this is the function which registers a user
    username = $("#newUser").find("#name").val();
    console.log username
    profession = $("#newUser").find("#profession").val();
    age = $("#newUser").find("#age").val();
    Accounts.createUser({username : username,password : "password",profile:{username:username,profession:profession,age:age}},(error)->
        if error
          console.log error
        else
           Router.go("phase1")
      )

