<?php
session_start();

if( ! isset($_SESSION['userId']) ){
    header('Location: index.php');
  exit();
}
// if ($_SESSION['userActive'] == 0){
//     header('Location: api/logout-action.php');
//     exit();
// }
print_r($_SESSION);
?>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home</title>
    <link rel="stylesheet" href="app.css">
    
</head>

<body onload="doStartFetchingEventsData();">
<header>
    <h1>Yellow Mellow</h1>
</header>
<div id="page">
    <nav>
        <a id="btnhome" href="#home" class="active">Home</a>
        <a id="btnevents" href="#events">Events</a>
        <a id="btnusers" href="#users">Users</a>
        <a id="btnprofile" href="#profile">Profile</a>
        <a id="btnchat" href="#chat">Chat</a>
        <a id="btngalery" href="#galery">Galery</a>
        <a id="btncalendar" href="#calendar">Calendar</a>
    
    </nav>

    <main>

        <div id="serchBar">
            <input type="text" value="Search - not working!!!">
            <svg viewBox="0 0 24 24"><path d="M21.53 20.47l-3.66-3.66C19.195 15.24 20 13.214 20 11c0-4.97-4.03-9-9-9s-9 4.03-9 9 4.03 9 9 9c2.215 0 4.24-.804 5.808-2.13l3.66 3.66c.147.146.34.22.53.22s.385-.073.53-.22c.295-.293.295-.767.002-1.06zM3.5 11c0-4.135 3.365-7.5 7.5-7.5s7.5 3.365 7.5 7.5-3.365 7.5-7.5 7.5-7.5-3.365-7.5-7.5z"></path></svg>
        </div>

<!-- start of Home page--> 
        <section id="home">
            <header>
                <h3>Home</h3>
            </header>
            <div>
                <h1>Highlight upcoming events!!!</h1>
                <h2>Upcoming events</h2>
                <h2>More events</h2>
            </div>            
        </section>
<!-- end of Home page-->     

<!-- start of Events page--> 
        <section id="events">
            <header>
                    <h3>Events</h3>
            </header>
          
        </section>
<!-- end of Events page--> 

<!-- start of Users page--> 
        <section id="users">
            <header>
                    <h3>Users</h3>
            </header>       
            <p>under construction, not sorry!</p>    
        </section>
<!-- end of Users page--> 

<!-- start of Profile page--> 
        <section id="profile">
            <header>
                    <h3>Profile</h3>
            </header>        
        </section>
<!-- end of Profile page--> 

<!-- start of Chat page--> 
        <section id="chat">
            <header>
                    <h3>Chat</h3>
            </header>
            <form id="startChat" onsubmit="return false">
                <input id="searchText" name="userProfileName" type="text" placeholder="Searching for the user ?"
                    onfocus="showSearchResults()"
                    oninput="startSearch()"
                >
            </form>    
            <div id="searchResults"></div>
            <div id="roomId" class="room"></div>
            <div id="sendMessage"></div>
        </section>
<!-- end of Chat page--> 

<!-- star of Galery page--> 
        <section id="galery">
            <header>
                    <h3>Gallery</h3>
            </header>
            <div id="galeryContainer"></div>        
            <form action="api/api-add-image.php" method="POST" enctype="multipart/form-data">
                <input type="file" name="image" id="image">
                <button onclick="getImage();" type="submit" name="submit">submit</button>
            </form>
            <div id="imgUploaded"></div>
        </section>
<!-- end of Galery page--> 

<!-- start of Calendar page--> 
        <section id="calendar">
            <header>
                    <h3>Calendar</h3>
            </header>
            <p>under construction, not sorry!</p>        
        </section>
<!-- end of Calendar page--> 
    </main>

<!-- start of top page--> 
    <div id="top">
        <img src="<?=$_SESSION['userAvatar']?>" alt="">
        <p><strong><?=$_SESSION['userName']?></strong></p>
        
            <a href="api/logout-action.php">Log out</a>
        </div>
    
<!-- end of top page-->

<!-- start of right page--> 
    <div id="right">

    </div>
<!-- end of right page-->

</div>
</body>
<script src="app.js"></script>
</html>