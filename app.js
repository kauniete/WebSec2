
const localStates = {
    lastEventId: 0,
}


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


// Get Events
var showEvents = setInterval(async function(){ 
	var con = await fetch('api/api-get-events.php')
	if(con.status != 200){
		alert('Something is wrong in the system')
	  }
  let aEvents = await con.json()
	  aEvents.forEach( jEvent => {
    var articleEvent = `
      <article class="event"> 
        <div id="${jEvent.eventId}">
          <h2>${jEvent.eventName}</h2><span><p>created: ${jEvent.eventCreated}</p></span>
          <p>type: ${jEvent.eventType}</p>
          <img src="fotos_assets/${jEvent.eventImg}.jpg">
          <p>Event discription: ${jEvent.eventAbout}</p>
          <p>time: ${jEvent.eventTime}</p>
          <p>place: ${jEvent.eventPlace}</p>
          <div class="owner" id="${jEvent.userId}">
            <img src="fotos_assets/${jEvent.userAvatar}.jpg">
            <p>Created by_${jEvent.userName}</p>
          </div>
          <p>followees count: ${jEvent.eventTotalFollowees}</p>
          <p>comments count: ${jEvent.eventTotalComments}</p>
          <div id="comments"></div>
          <div>
            <form onsubmit="return false">
              <input id="eventId" name="eventId" value="${jEvent.eventId}" type="hidden">
              <input id="commentText" name="commentText" type="text">
              <button onclick="sendComment()">Send</button>
            </form>
          </div>
        </div>
      </article>`  
			document.querySelector('#events > header').insertAdjacentHTML('afterEnd', articleEvent)
  } ) 
}, 1000);

// clear interval
setTimeout(function () {
	clearInterval(showEvents);
	}, 1500);


// Create Comments to Events
async function sendComment(){
    let form = new FormData(event.target.parentNode);
    let conn = await fetch('api/api-create-comment.php', {
      method : "POST",
      body : form
    })
    if( ! conn.ok ){ alert() }
  
      getLatestComments()
  }

  
// Get Last Comments to Events
async function getLatestComments(){
  let conn = await fetch('api/api-get-latest-comments.php?iLatestCommentId='+iLatestCommentId, {
    headers:{
      'Cache-Control': 'no-cache'
    }
  })
  if( ! conn.ok ){ alert() }
  let ajComments = await conn.json()
  let articles = document.querySelectorAll('article.event > div')
  let commentBox = document.querySelectorAll('#comments')
    ajComments.forEach( jComment => {
      doAppendCommentByEventId(jComment);
      iLatestCommentId = jComment.commentId
    })
  }

async function getLatestEvents(){
    let conn = await fetch('api/api-get-latest-events.php?iLatestEventId='+localStates.lastEventId, {
        headers:{
            'Cache-Control': 'no-cache'
        }
    })
    if( ! conn.ok ){ alert() }
    let ajEvents = await conn.json()
    ajEvents.forEach( jEvent => {
        doAppendEvent(jEvent);
        localStates.lastEventId = jEvent.eventId;
    } )
}

  function doAppendCommentByEventId(comment) {
      const { eventId, commentText} = comment;
      const domEventEl = document.querySelector(`div.event[data-event-id="${eventId}"]`)
      if(!domEventEl) {
          console.error(`No DOM event element with id ${eventId}`)
          return;
      }
      let tmpCommentElem = `
        <div class="comment">
          <span>${commentText}</span>
          <div class="owner">
            <img src="fotos_assets/${userAvatar}.jpg">
            <p>Created by_${userName}</p>
          </div>
          <button onclick="deleteComment('${commentId}')" data-commentId='${commentId}'>Delete</button>
          <p>${commentText}</p>
        </div>`
      document.getElementById(`comments_${eventId}`).insertAdjacentHTML('beforeend',tmpCommentElem)
  }

function doAppendEvent(event) {
    const { eventId, eventName} = event;
    const eventsContainer = document.getElementById('events');
    const tmpEventElem = `
            <div id="event_${eventId}" class="event" data-event-id="${eventId}">
                <h2>${eventName}</h2>
                <div id="comments_${eventId}" class="comments"></div>
                <div>
                    <form onsubmit="return false;">
                        <input id="comment_input_${eventId}" name="comment" type="text">
                        <input value="${eventId}" name="eventId" type="hidden">
                        <button onclick="sendComment()">Send</button>
                    </form>
                </div>
            </div>`
    eventsContainer.insertAdjacentHTML('beforeend',tmpEventElem);
}
  
  let iLatestCommentId = 0
  setInterval( () => {
      getLatestEvents().then(() => {
          getLatestComments();
      })
  } , 1000 )


// Delete User Comments
async function deleteComment(commentId) {
	event.target.parentElement.remove();
	let con = await fetch('api/api-delete-comment.php?commentId='+commentId, {
    headers:{
      'Cache-Control': 'no-cache'
    }
  })
  if( ! con.ok ){ alert() }
	let response = await con.json();
	console.log(response);
  }


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
