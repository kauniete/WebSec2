
const localStates = {
  lastEventId: 0,
  iLatestCommentId: 0

}



// Create Comments to Events
async function sendComment(){
  let form = new FormData(event.target.parentNode);
  let conn = await fetch('api/api-create-comment.php', {
    method : "POST",
    body : form
  })
  if( ! conn.ok ){ doShowToastMessage('Failed to load the latest comments') }

    getLatestComments()
}


// Get Last Comments to Events
async function getLatestComments(){
let conn = await fetch('api/api-get-latest-comments.php?iLatestCommentId='+localStates.iLatestCommentId, {
  headers:{
    'Cache-Control': 'no-cache'
  }
})
if( ! conn.ok ){ doShowToastMessage('Failed to load the latest comments') }
let ajComments = await conn.json()
let articles = document.querySelectorAll('article.event > div')
let commentBox = document.querySelectorAll('#comments')
  ajComments.forEach( jComment => {
    doAppendCommentByEventId(jComment);
    localStates.iLatestCommentId = jComment.commentId
  })
}


// Get Last Event
async function getLatestEvents(){
  let conn = await fetch('api/api-get-latest-events.php?iLatestEventId='+localStates.lastEventId, {
      headers:{
          'Cache-Control': 'no-cache'
      }
  })
  if( ! conn.ok ){ doShowToastMessage('Failed to load the latest events') }
  let ajEvents;
  try {
    ajEvents = await conn.json()
  } catch (e) {
    console.log('Invalid JSON response on getLatestEvents')
    console.log(`Message: ${e.message}`);
    return;
  }
  ajEvents.forEach( jEvent => {
      doAppendEvent(jEvent);
      localStates.lastEventId = jEvent.eventId;
  })
}

function doAppendCommentByEventId(comment) {
    const { eventId, commentText, userAvatar, userName, commentId} = comment;
    const domEventEl = document.querySelector(`div.event[data-event-id="${eventId}"]`)
    if(!domEventEl) {
        console.error(`No DOM event element with id ${eventId}`)
        return;
    }
    let tmpCommentElem = `
      <div class="comment">
        <div class="owner">
          <img src="fotos_assets/${userAvatar}.jpg" alt="">
          <p>Created by_${userName}</p>
        </div>
        <button onclick="deleteComment('${commentId}')" data-commentId='${commentId}'>Delete</button>
        <p>${commentText}</p>
      </div>`
    document.getElementById(`comments_${eventId}`).insertAdjacentHTML('beforeend',tmpCommentElem)
}

  
// Get Token
async function addToken(){
	let request = await fetch('api/api-add-token.php')
  if( ! request.ok ){ doShowToastMessage('Failed to add token') }
	let response = await request.json();
  }
  

// Get Events
function doAppendEvent(event) {
  addToken();
  const { id, eventId, eventName, eventCreated, eventType, eventImg, eventAbout, eventTime, eventPlace, userId, userAvatar, userName, eventTotalFollowees, eventTotalComments} = event;
  const eventsContainer = document.getElementById('events');
  const tmpEventElem = `
  <article class="event">
      <div id="event_${eventId}" class="event" data-event-id="${eventId}">
          <h2>${eventName}</h2><span><p>created: ${eventCreated}</p></span>
          <p>type: ${eventType}</p>
          <img src="fotos_assets/${eventImg}.jpg" alt="">
          <p>Event discription: ${eventAbout}</p>
          <p>time: ${eventTime}</p>
          <p>place: ${eventPlace}</p>
          <div class="owner" id="${userId}">
            <img src="fotos_assets/${userAvatar}.jpg" alt="">
            <p>Created by_${userName}</p>
          </div>
          <p>followees count: ${eventTotalFollowees}</p>
          <p>comments count: ${eventTotalComments}</p>
          <div id="comments_${eventId}" class="comments"></div>
          <div>
            <form onsubmit="return false">
              <input type="hidden" name="csrf" value="${id}">
              <input id="eventId_${eventId}" name="eventId" value="${eventId}" type="hidden">
              <input id="commentText_${eventId}" name="commentText" type="text">
              <button onclick="sendComment()">Send</button>
            </form>
          </div>
        </div>
      </article>`
  eventsContainer.insertAdjacentHTML('beforeend',tmpEventElem);
}

//TODO: Call this once a user is logged in
function doStartFetchingEventsData() {
  setInterval( () => {
    getLatestEvents().then(() => {
      getLatestComments();
    })
  } , 1000 )
}


// Delete User Comments
async function deleteComment(commentId) {
let box = event.target.parentElement;
let con = await fetch('api/api-delete-comment.php?commentId='+commentId, {
  headers:{
    'Cache-Control': 'no-cache'
  }
})
if( ! con.ok ){ doShowToastMessage('Failed to delete the comment') }
let response = await con.json();
console.log(response);
box.remove();
}

  
// Search Users in Chat
function showSearchResults(){
  document.querySelector('#searchResults').style.display = "grid"
}

function hideSearchResults(){
  document.querySelector('#searchResults').style.display = "none"
}

async function startSearch(){
     // Check that the input has data
  if( document.querySelector('#searchText').value.length == 0 ){
    return
  }
  
  let sSearchFor = document.querySelector('#searchText').value
  let conn = await fetch('api/api-search-user.php?user='+sSearchFor)
  if( ! conn.ok ){ doShowToastMessage('Failed to load users') }
  let ajData = await conn.json()
     // Clear previous data
  document.querySelector('#searchResults').innerHTML = ""
  ajData.forEach( jItem => {
    let sResultDiv = `
    <div class="result" id="${jItem.id}">
      <img src="fotos_assets/${jItem.avatar}.jpg" alt="">
      <p>${jItem.userNick}</p>
      <button onclick="createRoom('${jItem.id}', '${jItem.userNick}', '${jItem.avatar}')" data-addUserId='${jItem.id}' data-addUserNick='${jItem.userNick}' data-addUserImg='${jItem.avatar}'>+ add User</button>
    </div>
    `
    document.querySelector('#searchResults').insertAdjacentHTML('afterbegin', sResultDiv)
  })
}


// Create Room in Chat
async function createRoom(addUserId, addUserNick, addUserImg){
  //let roId = document.querySelector('#roomId').id
  //let resultId = document.querySelector('div.result').id
  let con = await fetch('api/api-create-room.php?to='+addUserId, {
    headers:{
      'Cache-Control': 'no-cache'
    }
  })
  if( ! con.ok ){ doShowToastMessage('Failed to create room') }
  let response = await con.json();
  console.log(response);
  let sRoomDiv = `
    <div class="rooms" id="${response}">
      <img src="fotos_assets/${addUserImg}.jpg" alt="">
      <form onsubmit="return false">
        <input id="LastMid" name="LastMid" value="${response}" type="hidden">
        <button onclick="showChatRoom(${response}) goToRoom(${response})" data-roomId="${response}" >Chat with</button>
      </form>
      <p><strong>${addUserNick}</strong></p>
      <p><strong name="user2">${addUserId}</strong></p>
      <p><strong>xxx</strong></p>
    </div>
    `
    document.querySelector('#right').insertAdjacentHTML('afterbegin', sRoomDiv)
    roId = `${response}`
    addUser(roId, addUserId)
  }


  // Add Users to Chat
async function addUser(roId, addUserId){
  let con = await fetch('api/api-add-reciver.php?room='+roId+'&to='+addUserId, {
    headers:{
      'Cache-Control': 'no-cache'
    }
  })
  if( ! con.ok ){ doShowToastMessage('Failed to add receiver') }
  let response = await con.json();
  hideSearchResults();
  }


// Get all User Rooms
async function getUsersRooms(){
  let conn = await fetch('api/api-get-last-rooms.php?room='+iLatestRoomId,  {
    headers:{
      'Cache-Control': 'no-cache'
    }
  })
  if( ! conn.ok ){ doShowToastMessage('Failed to load the latest rooms') }
  let ajData = await conn.json()
  ajData.forEach( jItem => {
  let sRoomDiv = `
    <div class="rooms" id="${jItem.roomId}">
      <img src="fotos_assets/${jItem.reciverAvatar}.jpg" alt="">
      <button  onclick="showChatRoom(${jItem.roomId}), goToRoom(${jItem.roomId})" data-roomId="${jItem.roomId}" >Chat with</button>
      <p><strong>${jItem.reciverNick}</strong></p>
    </div>
    `
    document.querySelector('#right').insertAdjacentHTML('afterbegin', sRoomDiv);
    iLatestRoomId = jItem.roomId
  })
}

let iLatestRoomId = 0
  setInterval( () => { getUsersRooms()  } , 1000 )


// Show Chat in Room
  async function showChatRoom(roomId){
  let conn = await fetch('api/api-get-latest-message.php?room='+roomId,  {
    headers:{
      'Cache-Control': 'no-cache'
    }
  })
  if( ! conn.ok ){ doShowToastMessage('Failed to load the latest message') }
  let ajData = await conn.json()
  ajData.forEach( jItem => {
    let sMessageDiv = `
    <div class="message" id="${jItem.messageId}">
      <img src="fotos_assets/${jItem.senderAvatar}.jpg" alt="">
      <p class="${jItem.senderNick}">${jItem.messageText}</p>
    </div>`
    console.log(ajData);
    document.querySelector('#roomId').insertAdjacentHTML('beforeend', sMessageDiv)
    iLatestRoomId = jItem.roomId
    iLatestMessageId = jItem.messageId
    let aMessages = document.querySelectorAll(`p.${jItem.senderNick}`)
    aMessages.forEach(message => {
      message.style.backgroundColor = "rgba(212, 175, 55, .3)";
      message.style.justifySelf = "right";
  })
})
}
let iLatestMessageId = 0
  setInterval( () => { showChatRoom(roomId)  } , 1000 )


// Go To Room
function goToRoom(roId){
    addToken();
    const { id } = event;
    let sMessForm = `
    <form onsubmit="return false">
    <input type="hidden" name="csrf" value="${id}">
    <input id="${roId}" name="roomId" value="${roId}" type="hidden">
    <input id="" name="messageText" type="text">
    <button onclick="sendMessage(${roId})" data-roomId="${roId}">Send</button>
    </form>
    `
    document.querySelector('#sendMessage').insertAdjacentHTML('afterbegin', sMessForm);
}


// Create Message in Room
async function sendMessage(roId){
  let form = new FormData(event.target.parentNode);
  let conn = await fetch('api/api-create-message.php', {
    method : "POST",
    body : form
  })
  if( ! conn.ok ){ doShowToastMessage('Failed to create a message') }
  let response = await conn.json();
  //console.log(response);
  showChatRoom(roId);
}

// get Img
async function getImage(){
  let form = event.target
  let connection = await fetch("api/api-get-image.php",  {
    headers:{
      'Cache-Control': 'no-cache'
    }
  })
  let ajData = await connection.json()
  console.log(ajData)
  ajData.forEach( jItem => {
    let sResultDiv = `
    <div class="result">
      <img src="images/${jItem.galeryImage}">
    </div>`
    document.querySelector('#galeryContainer').insertAdjacentHTML('afterbegin', sResultDiv);
  })
}

function doShowToastMessage(message) {
  const toastMessageElem = document.createElement('div');
  toastMessageElem.classList.add('toast-message')

  toastMessageElem.textContent = message;

  document.body.appendChild(toastMessageElem);
  toastMessageElem.classList.add('show');
  setTimeout(() => {
    toastMessageElem.remove()
  }, 3000)
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



