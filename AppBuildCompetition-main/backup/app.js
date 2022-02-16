// Create the app
var app = new Framework7({
    // App root element
    el: '#app',
    // App theme
    theme: 'ios',
    // App Name
    name: 'Student Manager',
    // App id
    id: 'com.sns.student',
});



//Hide the home screen of the app
var home = document.getElementById("homepage");
home.style.display = "none";



//global variables

var user;
// login function
function login() {
    var un = document.getElementById("username").value
    var pw = document.getElementById("password").value
    if (pw == "123" && un == "abc") {
        alert("You are logged in")
        user = un;
        showHome()
    }
    else {
        alert("Wrong Password")
    }

}



// this is the function to show home 
function showHome() {
    var home = document.getElementById("homepage");
    // block shows the home screen
    home.style.display = "block";


    var LoginScreen = document.getElementById("LoginScreen");

    LoginScreen.style.display = "none";


// for user's name
var greet = document.getElementById("greet");

greet.innerText=user;


}