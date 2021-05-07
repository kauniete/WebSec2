      
// Logout Open and Close
function openLogout(){
    var logoutBox = document.getElementById("LogoutModal");
        logoutBox.style.display = "grid";

    window.onclick = function(event) {
        if (event.target == logoutBox) {
            logoutBox.style.display = "none";
        }
    }
}

// Comments to Events
async function sendComment(){
    // console.log(event.target.parentNode)
    let form = new FormData(event.target.parentNode)
    let conn = await fetch('api/api-create-comment.php', {
      method : "POST",
      body : form
    })
    if( ! conn.ok ){ alert() }
    getLatestComments()
  }
  
  async function getLatestComments(){
    let conn = await fetch('api/api-get-latest-comments.php?iLatestCommentId='+iLatestCommentId, {
      headers:{
        'Cache-Control': 'no-cache'
      }
    })
    if( ! conn.ok ){ alert() }
    let ajComments = await conn.json()
    ajComments.forEach( jComment => {
      let sDivEvent = `
        <div class="event">
          <span>${jComment.commentText}</span>
        </div>`
      document.querySelector('#comments').insertAdjacentHTML('beforeend',sDivEvent) 
      iLatestCommentId = jComment.commentId
    } )
  }
  
  let iLatestCommentId = 0
  setInterval( () => { getLatestComments()  } , 1000 )


// Page Change
var Home = document.getElementById("home");
var btnHome = document.querySelector("#btnhome");
var Events = document.getElementById("events");
var btnEvents = document.querySelector("#btnevents");
var Users = document.getElementById("users");
var btnUsers = document.querySelector("#btnusers");
var Profile = document.getElementById("profile");
var btnProfile = document.querySelector("#btnprofile");
var Chat = document.getElementById("chat");
var btnChat = document.querySelector("#btnchat");
var Galery = document.getElementById("galery");
var btnGalery = document.querySelector("#btngalery");
var Calendar = document.getElementById("calendar");
var btnCalendar = document.querySelector("#btncalendar");


btnHome.onclick = function(){
    Home.style.display = "block";
    btnHome.classList.add("active");
    Events.style.display = "none";
    btnEvents.classList.remove("active");
    Users.style.display = "none";
    btnUsers.classList.remove("active");
    Profile.style.display = "none";
    btnProfile.classList.remove("active");
    Chat.style.display = "none";
    btnChat.classList.remove("active");
    Galery.style.display = "none";
    btnGalery.classList.remove("active");
    Calendar.style.display = "none";
    btnCalendar.classList.remove("active");
    
}

btnEvents.onclick = function(){
    Events.style.display = "block";
    btnEvents.classList.add("active");
    Home.style.display = "none";
    btnHome.classList.remove("active");
    Users.style.display = "none";
    btnUsers.classList.remove("active");
    Profile.style.display = "none";
    btnProfile.classList.remove("active");
    Chat.style.display = "none";
    btnChat.classList.remove("active");
    Galery.style.display = "none";
    btnGalery.classList.remove("active");
    Calendar.style.display = "none";
    btnCalendar.classList.remove("active");
    
}

btnUsers.onclick = function(){
    Users.style.display = "block";
    btnUsers.classList.add("active");
    Home.style.display = "none";
    btnHome.classList.remove("active");
    Events.style.display = "none";
    btnEvents.classList.remove("active");
    Profile.style.display = "none";
    btnProfile.classList.remove("active");
    Chat.style.display = "none";
    btnChat.classList.remove("active");
    Galery.style.display = "none";
    btnGalery.classList.remove("active");
    Calendar.style.display = "none";
    btnCalendar.classList.remove("active");
}

btnProfile.onclick = function(){
    Profile.style.display = "block";
    btnProfile.classList.add("active");
    Home.style.display = "none";
    btnHome.classList.remove("active");
    Events.style.display = "none";
    btnEvents.classList.remove("active");
    Users.style.display = "none";
    btnUsers.classList.remove("active");
    Chat.style.display = "none";
    btnChat.classList.remove("active");
    Galery.style.display = "none";
    btnGalery.classList.remove("active");
    Calendar.style.display = "none";
    btnCalendar.classList.remove("active");
}

btnChat.onclick = function(){
    Chat.style.display = "block";
    btnChat.classList.add("active");
    Home.style.display = "none";
    btnHome.classList.remove("active");
    Events.style.display = "none";
    btnEvents.classList.remove("active");
    Users.style.display = "none";
    btnUsers.classList.remove("active");
    Profile.style.display = "none";
    btnProfile.classList.remove("active");
    Galery.style.display = "none";
    btnGalery.classList.remove("active");
    Calendar.style.display = "none";
    btnCalendar.classList.remove("active");
}

btnGalery.onclick = function(){
    Galery.style.display = "block";
    btnGalery.classList.add("active");
    Home.style.display = "none";
    btnHome.classList.remove("active");
    Events.style.display = "none";
    btnEvents.classList.remove("active");
    Users.style.display = "none";
    btnUsers.classList.remove("active");
    Profile.style.display = "none";
    btnProfile.classList.remove("active");
    Chat.style.display = "none";
    btnChat.classList.remove("active");
    Calendar.style.display = "none";
    btnCalendar.classList.remove("active");
}

btnCalendar.onclick = function(){
    Calendar.style.display = "block";
    btnCalendar.classList.add("active");
    Home.style.display = "none";
    btnHome.classList.remove("active");
    Events.style.display = "none";
    btnEvents.classList.remove("active");
    Users.style.display = "none";
    btnUsers.classList.remove("active");
    Profile.style.display = "none";
    btnProfile.classList.remove("active");
    Chat.style.display = "none";
    btnChat.classList.remove("active");
    Galery.style.display = "none";
    btnGalery.classList.remove("active");
}


// Serch Icone Yellow
var serchField = document.getElementById("serchBar").firstElementChild;
var serchIcon = document.getElementById("serchBar").lastElementChild;

serchField.onfocus = function(){
    serchIcon.style.fill = "rgba(255, 223, 0, 1)";
}

serchField.addEventListener('focusout', (event) => {
    serchIcon.style.fill = "rgba(0, 0, 0, 0.5)";    
  });
