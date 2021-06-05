-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 05, 2021 at 08:14 PM
-- Server version: 10.4.19-MariaDB
-- PHP Version: 8.0.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `websec`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `addRecieverToRoom` (IN `roId` INT(20) UNSIGNED, IN `recId` INT(20) UNSIGNED)  INSERT INTO inrooms (inroomRoomFk, inroomUserFk)
VALUES (roId, recId)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `createComment` (IN `eId` INT(20) UNSIGNED, IN `uId` INT(20) UNSIGNED, IN `cText` VARCHAR(280))  INSERT INTO comments (commentEventFk, commentUserFk, commentText) 
  VALUES (eId, uId, cText)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `createLogs` (IN `uId` INT(20) UNSIGNED, IN `tNow` DATETIME)  INSERT INTO loggs VALUES(null, uId, 0, tNow)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `createMessage` (IN `sId` INT(20) UNSIGNED, IN `rId` INT(20) UNSIGNED, IN `mtext` VARCHAR(640), IN `mImg` VARCHAR(40))  INSERT INTO messages (messageFromUserFk, messageToRoomFk, messageText, messageImg)
VALUES (sId, rId, mtext, mImg)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `createRoom` (IN `roId` INT(20) UNSIGNED, IN `uOwnId` INT(20) UNSIGNED, IN `rName` VARCHAR(40))  INSERT INTO rooms (rooms.roomId, rooms.roomOwnerFk, rooms.roomName)
VALUES (roId, uOwnId, rName)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `createUser` (IN `uId` INT(20) UNSIGNED, IN `uFullName` VARCHAR(50), IN `uNick` VARCHAR(25), IN `uEmail` VARCHAR(50), IN `uPass` VARCHAR(255), IN `uCode` VARCHAR(6), IN `uActive` INT(1) UNSIGNED)  INSERT INTO users (userId, userFullName, userUserName, userEmail, userPassword, userVeryfyCode, userActive)
VALUES(uId, uFullName, uNick, uEmail, uPass, uCode, uActive)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteComment` (IN `cId` INT(20) UNSIGNED, IN `uId` INT(20) UNSIGNED)  DELETE comments FROM comments 
INNER JOIN users 
ON users.userId = comments.commentUserFk 
WHERE comments.commentId = cId 
AND users.userId = uId$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllUsers` ()  SELECT * FROM view_users LIMIT 10$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getEvents` ()  SELECT * FROM view_events LIMIT 10$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getLastComments` (IN `LastcId` INT(20) UNSIGNED)  SELECT * FROM view_comments WHERE commentId > LastcId LIMIT 10$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getLastEvents` (IN `iLatestId` INT(20))  SELECT * FROM view_events 
WHERE eventId > iLatestId 
LIMIT 10$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getLastMessages` (IN `sId` INT(20) UNSIGNED, IN `rId` INT(20) UNSIGNED, IN `LastmId` INT(20) UNSIGNED)  SELECT * FROM view_messages
WHERE senderId = sId
AND roomId = rId
AND messageId > LastmId
LIMIT 25$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getLastRooms` (IN `LastrId` INT(20) UNSIGNED, IN `ownId` INT(20) UNSIGNED)  SELECT * FROM view_rooms 
WHERE roomId > LastrId
AND senderId = ownId
LIMIT 15$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getUserById` (IN `uId` INT(20) UNSIGNED)  SELECT * FROM users 
WHERE userId = uId 
LIMIT 1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getUserByUserName` (IN `uNick` VARCHAR(25))  SELECT * FROM users 
WHERE userUserName = uNick
LIMIT 1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getUserLog` (IN `uName` VARCHAR(25))  SELECT * FROM logtry
WHERE logtry.userName = uName 
LIMIT 1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `searchUser` (IN `searchString` VARCHAR(25))  SELECT userId AS id, 
	   userUserName AS userNick, 
       userFullName AS userName, 
       userAvatar AS avatar, 
       userEmail AS email 
FROM users
WHERE userUserName LIKE searchString 
OR userEmail LIKE searchString
OR userFullName LIKE searchString
LIMIT 5$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateLogToIncrement` (IN `tNow` DATETIME, IN `uName` VARCHAR(25))  UPDATE logtry
SET logtry.logCount = logtry.logCount + 1, 
    logtry.lastLog = tNow
WHERE logtry.userName = uName 
LIMIT 1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateLogToUnblock` (IN `tNow` TIMESTAMP, IN `uName` VARCHAR(25))  UPDATE logtry
SET logtry.logCount = 0, logtry.lastLog = tNow
WHERE logtry.userName = uName 
LIMIT 1$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `activities`
--

CREATE TABLE `activities` (
  `activityId` bigint(20) UNSIGNED NOT NULL,
  `activityName` varchar(30) NOT NULL,
  `activityUseCount` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `activityCreated` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `commentId` bigint(20) UNSIGNED NOT NULL,
  `commentEventFk` bigint(20) UNSIGNED NOT NULL,
  `commentUserFk` bigint(20) UNSIGNED NOT NULL,
  `commentText` varchar(280) NOT NULL,
  `commentCreated` datetime NOT NULL DEFAULT current_timestamp(),
  `commentActive` tinyint(1) UNSIGNED NOT NULL DEFAULT 1,
  `commentImg` varchar(40) DEFAULT NULL,
  `commentHref` varchar(2000) DEFAULT NULL,
  `commentTotalLikes` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `commentTotalReplays` int(10) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `comments`
--

INSERT INTO `comments` (`commentId`, `commentEventFk`, `commentUserFk`, `commentText`, `commentCreated`, `commentActive`, `commentImg`, `commentHref`, `commentTotalLikes`, `commentTotalReplays`) VALUES
(23, 1, 1, 'ttttttt', '2021-05-10 01:03:16', 1, NULL, NULL, 0, 0),
(29, 2, 1, '................', '2021-05-11 00:25:34', 1, NULL, NULL, 0, 0),
(77, 1, 1, 'hophop', '2021-05-11 04:20:02', 1, NULL, NULL, 0, 0),
(82, 0, 1, 'OOOOOOOOOO', '2021-05-11 04:53:58', 1, NULL, NULL, 0, 0),
(103, 2, 1, 'XXXXXXXXXXXXXXXXXX', '2021-05-11 17:55:55', 1, NULL, NULL, 0, 0),
(106, 1, 1, 'X', '2021-05-11 18:00:20', 1, NULL, NULL, 0, 0),
(115, 3, 1, '&lt;script&gt;document.querySelector(&quot;body&quot;).style.color = &quot;red&quot; &lt;/script&gt;', '2021-05-12 20:03:55', 1, NULL, NULL, 0, 0),
(129, 1, 1, 'ggg', '2021-05-13 03:31:16', 1, NULL, NULL, 0, 0),
(130, 2, 1, 'ggg', '2021-05-13 03:31:22', 1, NULL, NULL, 0, 0),
(131, 3, 1, 'ggg', '2021-05-13 03:31:26', 1, NULL, NULL, 0, 0),
(132, 1, 1, 'jjjjjjjjjjjjjjjjjjjjjjjjjjjjjj', '2021-05-13 04:06:02', 1, NULL, NULL, 0, 0),
(148, 1, 7, 'hhhh', '2021-05-14 02:10:10', 1, NULL, NULL, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE `events` (
  `eventId` bigint(20) UNSIGNED NOT NULL,
  `eventName` varchar(100) NOT NULL,
  `eventOwnerFk` bigint(20) UNSIGNED NOT NULL,
  `eventAbout` varchar(640) NOT NULL,
  `eventTime` datetime NOT NULL,
  `eventPlace` varchar(200) NOT NULL,
  `eventImg` varchar(40) NOT NULL,
  `eventCreated` datetime NOT NULL DEFAULT current_timestamp(),
  `eventActive` tinyint(1) UNSIGNED NOT NULL DEFAULT 1,
  `eventActivityType` varchar(30) NOT NULL,
  `eventTotalFollowees` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `eventTotalComments` int(10) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `events`
--

INSERT INTO `events` (`eventId`, `eventName`, `eventOwnerFk`, `eventAbout`, `eventTime`, `eventPlace`, `eventImg`, `eventCreated`, `eventActive`, `eventActivityType`, `eventTotalFollowees`, `eventTotalComments`) VALUES
(1, 'Event Nr 1 Run', 3, 'run run run', '2021-05-19 12:14:44', 'address 1', 'photo-1526676037777-05a232554f77', '2021-05-10 00:18:51', 1, 'running', 0, 0),
(2, 'Event Nr 2 Swim', 2, 'swim swim swim', '2021-05-14 10:14:44', 'address 2', 'photo-1472978346569-9fa7ea7adf4a', '2021-05-10 00:18:51', 1, 'swimming', 0, 0),
(3, 'Event Nr 3 Play', 5, 'Play Play play ', '2021-05-12 18:36:49', 'address3 ', 'photo-1547347298-4074fc3086f0', '2021-05-12 18:43:35', 1, 'playing', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `followers`
--

CREATE TABLE `followers` (
  `followerFollowerFk` bigint(20) UNSIGNED NOT NULL,
  `followerFolloweeFk` bigint(20) UNSIGNED NOT NULL,
  `followerRelation` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `followerCreated` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `followings`
--

CREATE TABLE `followings` (
  `followingUserFk` bigint(20) UNSIGNED NOT NULL,
  `followingActivityFk` bigint(20) UNSIGNED DEFAULT NULL,
  `followingEventFk` bigint(20) UNSIGNED DEFAULT NULL,
  `followingCreated` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `galeries`
--

CREATE TABLE `galeries` (
  `galeryId` bigint(20) UNSIGNED NOT NULL,
  `galeryUserFk` bigint(20) UNSIGNED NOT NULL,
  `galeryImage` varchar(40) NOT NULL,
  `galeryImgSize` int(5) UNSIGNED NOT NULL,
  `galeryCreated` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `galeries`
--

INSERT INTO `galeries` (`galeryId`, `galeryUserFk`, `galeryImage`, `galeryImgSize`, `galeryCreated`) VALUES
(5, 1, 'hoho', 2000, '2021-06-05 01:36:23'),
(7, 1, 'lalalala', 2000, '2021-06-05 01:43:51'),
(34, 8, 'arangodb-logo.png', 27091, '2021-06-05 13:32:23');

-- --------------------------------------------------------

--
-- Table structure for table `inrooms`
--

CREATE TABLE `inrooms` (
  `inroomId` bigint(20) UNSIGNED NOT NULL,
  `inroomRoomFk` bigint(20) UNSIGNED NOT NULL,
  `inroomUserFk` bigint(20) UNSIGNED NOT NULL,
  `inroomCreated` datetime NOT NULL DEFAULT current_timestamp(),
  `inroomActive` tinyint(1) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `inrooms`
--

INSERT INTO `inrooms` (`inroomId`, `inroomRoomFk`, `inroomUserFk`, `inroomCreated`, `inroomActive`) VALUES
(2, 2, 1, '2021-05-18 04:31:06', 1),
(3, 1, 2, '2021-05-18 05:05:52', 1),
(4, 2, 8, '2021-05-18 05:05:52', 1),
(72, 81, 2, '2021-05-31 12:58:16', 1),
(74, 83, 13, '2021-06-05 20:13:05', 1);

-- --------------------------------------------------------

--
-- Table structure for table `loggs`
--

CREATE TABLE `loggs` (
  `logId` bigint(20) UNSIGNED NOT NULL,
  `logUserFk` bigint(20) UNSIGNED NOT NULL,
  `logLogCount` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `logLastLog` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `loggs`
--

INSERT INTO `loggs` (`logId`, `logUserFk`, `logLogCount`, `logLastLog`) VALUES
(1, 2, 0, '2021-05-14 10:14:44'),
(2, 1, 0, '2021-05-14 10:14:44'),
(3, 8, 1, '2021-05-14 15:30:21'),
(4, 7, 0, '2021-05-14 01:25:14'),
(5, 12, 1, '2021-05-14 15:34:47');

-- --------------------------------------------------------

--
-- Stand-in structure for view `logtry`
-- (See below for the actual view)
--
CREATE TABLE `logtry` (
`logId` bigint(20) unsigned
,`logCount` tinyint(1) unsigned
,`lastLog` datetime
,`userId` bigint(20) unsigned
,`userName` varchar(25)
,`userEmail` varchar(50)
);

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `messageId` bigint(20) UNSIGNED NOT NULL,
  `messageFromUserFk` bigint(20) UNSIGNED NOT NULL,
  `messageToRoomFk` bigint(20) UNSIGNED NOT NULL,
  `messageText` varchar(640) NOT NULL,
  `messageCreated` datetime NOT NULL DEFAULT current_timestamp(),
  `messageImg` varchar(40) DEFAULT NULL,
  `messageHref` varchar(2000) DEFAULT NULL,
  `messageQuoteFk` bigint(20) UNSIGNED DEFAULT NULL,
  `messageActive` tinyint(1) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `messages`
--

INSERT INTO `messages` (`messageId`, `messageFromUserFk`, `messageToRoomFk`, `messageText`, `messageCreated`, `messageImg`, `messageHref`, `messageQuoteFk`, `messageActive`) VALUES
(1, 1, 1, 'hola hola', '2021-05-17 16:50:41', '', '', NULL, 1),
(2, 1, 1, 'top top', '2021-05-17 17:14:30', '', '', NULL, 1),
(8, 2, 1, 'hi hi hi', '2021-05-17 22:06:40', NULL, NULL, NULL, 1),
(11, 1, 1, 'plum plum', '2021-05-19 03:28:14', NULL, NULL, NULL, 1),
(19, 1, 1, '.................', '2021-05-19 04:56:32', NULL, NULL, NULL, 1),
(66, 8, 81, 'jjjjjjjjjjjjjjjjjjjjjjjjjjjjj', '2021-06-05 19:53:00', NULL, NULL, NULL, 1),
(67, 8, 81, 'plum plum', '2021-06-05 19:58:26', NULL, NULL, NULL, 1),
(69, 8, 81, 'ghghghg', '2021-06-05 20:08:15', NULL, NULL, NULL, 1),
(70, 8, 81, '.................', '2021-06-05 20:09:34', NULL, NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `reactions`
--

CREATE TABLE `reactions` (
  `reactionId` bigint(20) UNSIGNED NOT NULL,
  `reactionName` varchar(20) NOT NULL,
  `reactionCount` int(10) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `reactions`
--

INSERT INTO `reactions` (`reactionId`, `reactionName`, `reactionCount`) VALUES
(1, 'OK', 0),
(2, 'Happy', 0),
(3, 'Love', 0),
(4, 'Sad', 0),
(5, 'Angry', 0);

-- --------------------------------------------------------

--
-- Table structure for table `recivers`
--

CREATE TABLE `recivers` (
  `reciverId` bigint(20) UNSIGNED NOT NULL,
  `reciverRoomFk` bigint(20) UNSIGNED NOT NULL,
  `reciverUserFk` bigint(20) UNSIGNED NOT NULL,
  `reciverMessageFk` bigint(20) UNSIGNED NOT NULL,
  `reciverReactionFk` bigint(20) UNSIGNED DEFAULT NULL,
  `reciverRead` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `reciverActive` tinyint(1) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `recivers`
--

INSERT INTO `recivers` (`reciverId`, `reciverRoomFk`, `reciverUserFk`, `reciverMessageFk`, `reciverReactionFk`, `reciverRead`, `reciverActive`) VALUES
(1, 1, 2, 1, NULL, 0, 1),
(2, 1, 2, 2, NULL, 0, 1),
(3, 1, 2, 2, NULL, 0, 1),
(4, 1, 2, 3, NULL, 0, 1),
(5, 1, 2, 3, NULL, 0, 1),
(6, 1, 8, 2, NULL, 0, 1),
(7, 1, 1, 3, NULL, 0, 1),
(8, 1, 2, 3, NULL, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `replays`
--

CREATE TABLE `replays` (
  `replayId` bigint(20) UNSIGNED NOT NULL,
  `replayCommentFk` bigint(20) UNSIGNED NOT NULL,
  `replayUserFk` bigint(20) UNSIGNED NOT NULL,
  `replayText` varchar(280) NOT NULL,
  `replayCreated` datetime NOT NULL DEFAULT current_timestamp(),
  `replayActive` tinyint(1) UNSIGNED NOT NULL DEFAULT 1,
  `replayImg` varchar(40) DEFAULT NULL,
  `replayHref` varchar(2000) DEFAULT NULL,
  `replayTotalLikes` int(10) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `rooms`
--

CREATE TABLE `rooms` (
  `roomId` bigint(20) UNSIGNED NOT NULL,
  `roomOwnerFk` bigint(20) UNSIGNED NOT NULL,
  `roomName` varchar(40) DEFAULT NULL,
  `roomCreated` datetime NOT NULL DEFAULT current_timestamp(),
  `roomActive` tinyint(1) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `rooms`
--

INSERT INTO `rooms` (`roomId`, `roomOwnerFk`, `roomName`, `roomCreated`, `roomActive`) VALUES
(0, 3, '0', '2021-05-17 20:26:39', 1),
(1, 1, 'FirstOne', '2021-05-17 17:08:20', 1),
(2, 1, 'SecondOne', '2021-05-17 17:45:16', 1),
(81, 8, NULL, '2021-05-31 12:58:16', 1),
(83, 16, NULL, '2021-06-05 20:13:05', 1);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `userId` bigint(20) UNSIGNED NOT NULL,
  `userFullName` varchar(50) NOT NULL,
  `userUserName` varchar(25) NOT NULL,
  `userEmail` varchar(50) NOT NULL,
  `userPassword` varchar(255) NOT NULL,
  `userAvatar` varchar(40) DEFAULT NULL,
  `userAbout` varchar(500) DEFAULT NULL,
  `userVeryfyCode` varchar(40) NOT NULL,
  `userActive` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `userCity` varchar(60) DEFAULT NULL,
  `userLanguage` varchar(5) DEFAULT NULL,
  `userCreated` datetime NOT NULL DEFAULT current_timestamp(),
  `userTotalMessages` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `userTotalImg` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `userTotalFollowers` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `userTotalFollowees` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `userTotalFollowing` int(10) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`userId`, `userFullName`, `userUserName`, `userEmail`, `userPassword`, `userAvatar`, `userAbout`, `userVeryfyCode`, `userActive`, `userCity`, `userLanguage`, `userCreated`, `userTotalMessages`, `userTotalImg`, `userTotalFollowers`, `userTotalFollowees`, `userTotalFollowing`) VALUES
(1, 'a aa', 'aaa', 'a@a.com', 'pass1', 'photo-1519872775884-29a6fea271ca', NULL, 'code1', 1, NULL, NULL, '2021-05-10 00:12:18', 0, 0, 0, 0, 0),
(2, 'c cc', 'ccc', 'c@c.com', 'pass2', 'photo-1504810370725-2585de12e6ee', NULL, 'code2', 1, NULL, NULL, '2021-05-10 00:12:18', 0, 0, 0, 0, 0),
(3, 'e ee', 'eee', 'e@2.com', 'pass3', 'photo-1489424731084-a5d8b219a5bb', NULL, 'code3', 1, NULL, NULL, '2021-05-10 00:14:12', 0, 0, 0, 0, 0),
(4, 'x xx', 'xxx', 'x@x.com', 'pass4', 'photo-1499996860823-5214fcc65f8f', NULL, 'code4', 1, NULL, NULL, '2021-05-10 00:14:12', 0, 0, 0, 0, 0),
(5, 'z zz', 'zzz', 'z@z.com', 'Pass5', 'photo-1519613273847-6daa1d54e198', NULL, 'code5', 1, NULL, NULL, '2021-05-12 18:41:55', 0, 0, 0, 0, 0),
(6, 'test', 'test', 'test.com', 'test', 'test', NULL, 'code', 1, NULL, NULL, '2021-05-13 02:18:02', 0, 0, 0, 0, 0),
(7, 'test', 'aiais', 'cvb@cv.pl', '$argon2id$v=19$m=65536,t=4,p=1$dE1zeW9ueTBLQzAvN2dPNQ$9YRcWpeNNd6Rp2OrgUn1HTT5z62JEUvbg7tXQG5+zhI', 'testasd', 'about me', '0a26ab', 1, 'test', 'test', '2021-05-10 00:12:18', 20, 20, 20, 20, 20),
(8, 'test', 'qweqwe', 'cvb@cv.pl', '$argon2id$v=19$m=65536,t=4,p=1$SHFEZVlKNlcvSlVTT0NWSA$3nmCZTl81pVtjVaFTMR2rAwvCaIbUvk5+tpsi4YKFyA', 'photo-1580489944761-15a19d654956', 'about me', '1e7cc2d6c99a39e8085f25861d92adda', 1, 'test', 'test', '2021-05-10 00:12:18', 20, 20, 20, 20, 20),
(9, 'test', 'poipoi', 'cvb@cv.pl', '$argon2id$v=19$m=65536,t=4,p=1$azQudXpaZkx2SUpVd2REUw$po9Q0eM9FIXfaro8CaLMZSYE++FV4mxp6jsG+od4yzY', 'photo-1580489944761-15a19d654956', 'about me', 'b5ec0fb194f07820ce17b919e143ca1c', 1, 'test', 'test', '2021-05-10 00:12:18', 20, 20, 20, 20, 20),
(10, 'test', 'poipoi2', 'cvb@cv.pl', '$argon2id$v=19$m=65536,t=4,p=1$RE02N29Dai41QmdRNnF1TA$nyQvrn23sN/MPuQA9U1HEUM1WyWRc7g6PnaLKHDM93I', 'photo-1580489944761-15a19d654956', 'about me', '007894d500686f7ee806d939393b010a', 1, 'test', 'test', '2021-05-10 00:12:18', 20, 20, 20, 20, 20),
(11, 'test', 'qweqwe34', 'cvb@cv.pl', '$argon2id$v=19$m=65536,t=4,p=1$SmtONlQxRnNYSkJvbi4xYw$7UwkUA0R/DyH5iYQu4wGB5xqE+35r1GK01UnsqqQBJY', 'photo-1580489944761-15a19d654956', 'about me', '25daf37391ca6cdda13731f058fa06f4', 1, 'test', 'test', '2021-05-10 00:12:18', 20, 20, 20, 20, 20),
(12, 'test', 'poipoi89', 'cvb@cv.pl', '$argon2id$v=19$m=65536,t=4,p=1$TGV6QzRBbDZZTDQxWTl4Lg$n7VrO4CxTgTfNqvNiEKo29DUsnUxuCJDDMciPiV82W0', 'photo-1580489944761-15a19d654956', 'about me', 'c5ba5f3ac040b07578e43d1f113b508f', 1, 'test', 'test', '2021-05-10 00:12:18', 20, 20, 20, 20, 20),
(13, 'test', 'qweqwe09', 'cvb@cv.pl', '$argon2id$v=19$m=65536,t=4,p=1$WHQ1eFRBMnYvdlNpejBQeQ$+2WpOnn92UTfWyOvgc2RCVxcqx+kfy34AFytRpXwRBc', 'photo-1580489944761-15a19d654956', 'about me', '6fdd71888b04d1b1d5831cc3588053ba', 1, 'test', 'test', '2021-05-10 00:12:18', 20, 20, 20, 20, 20),
(14, 'test', 'evebra12', 'cvb@cv.pl', '$argon2id$v=19$m=65536,t=4,p=1$dm5vYUpyN1huOUdMeTRkVg$/gSINflQ/uzFpsuLrxwadSQns7MD19z0zVjlEmtrWUo', 'photo-1580489944761-15a19d654956', 'about me', 'd90ad21cf9ba84db8bd5706031df2664', 1, 'test', 'test', '2021-05-10 00:12:18', 20, 20, 20, 20, 20),
(16, 'test', 'poipoi69', 'cvb@cv.pl', '$argon2id$v=19$m=65536,t=4,p=1$eGlpcm5POWoySFBSTWp4cw$BlrESefN0BHOOa6EveFQ4ZnMyqnI5bqVQFEK69Mzo5A', NULL, NULL, '234d7adbcc78f4ed465702b289bf8298', 1, NULL, NULL, '2021-06-05 20:11:01', 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_comments`
-- (See below for the actual view)
--
CREATE TABLE `view_comments` (
`commentId` bigint(20) unsigned
,`commentText` varchar(280)
,`commentCreated` datetime
,`commentActive` tinyint(1) unsigned
,`commentImg` varchar(40)
,`commentHref` varchar(2000)
,`commentTotalLikes` int(10) unsigned
,`commentTotalReplays` int(10) unsigned
,`userId` bigint(20) unsigned
,`userName` varchar(25)
,`userAvatar` varchar(40)
,`eventId` bigint(20) unsigned
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_events`
-- (See below for the actual view)
--
CREATE TABLE `view_events` (
`eventId` bigint(20) unsigned
,`eventName` varchar(100)
,`eventAbout` varchar(640)
,`eventTime` datetime
,`eventPlace` varchar(200)
,`eventImg` varchar(40)
,`eventCreated` datetime
,`eventActive` tinyint(1) unsigned
,`eventType` varchar(30)
,`eventTotalFollowees` int(10) unsigned
,`eventTotalComments` int(10) unsigned
,`userId` bigint(20) unsigned
,`userName` varchar(25)
,`userAvatar` varchar(40)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_messages`
-- (See below for the actual view)
--
CREATE TABLE `view_messages` (
`senderId` bigint(20) unsigned
,`senderNick` varchar(25)
,`senderAvatar` varchar(40)
,`roomId` bigint(20) unsigned
,`roomName` varchar(40)
,`reciverId` bigint(20) unsigned
,`reciverNick` varchar(25)
,`reciverAvatar` varchar(40)
,`messageId` bigint(20) unsigned
,`messageText` varchar(640)
,`messageImg` varchar(40)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_messages2`
-- (See below for the actual view)
--
CREATE TABLE `view_messages2` (
`senderId` bigint(20) unsigned
,`senderNick` varchar(25)
,`senderAvatar` varchar(40)
,`roomId` bigint(20) unsigned
,`roomName` varchar(40)
,`reciverId` bigint(20) unsigned
,`reciverNick` varchar(25)
,`reciverAvatar` varchar(40)
,`messageId` bigint(20) unsigned
,`messageText` varchar(640)
,`messageImg` varchar(40)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_rooms`
-- (See below for the actual view)
--
CREATE TABLE `view_rooms` (
`senderId` bigint(20) unsigned
,`senderNick` varchar(25)
,`senderAvatar` varchar(40)
,`roomId` bigint(20) unsigned
,`roomName` varchar(40)
,`reciverId` bigint(20) unsigned
,`reciverNick` varchar(25)
,`reciverAvatar` varchar(40)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_users`
-- (See below for the actual view)
--
CREATE TABLE `view_users` (
`userId` bigint(20) unsigned
,`userFullName` varchar(50)
,`userUserName` varchar(25)
,`userEmail` varchar(50)
,`userAvatar` varchar(40)
,`userAbout` varchar(500)
,`userActive` tinyint(1) unsigned
,`userCity` varchar(60)
,`userLanguage` varchar(5)
,`userCreated` datetime
,`userTotalMessages` int(10) unsigned
);

-- --------------------------------------------------------

--
-- Structure for view `logtry`
--
DROP TABLE IF EXISTS `logtry`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `logtry`  AS SELECT `loggs`.`logId` AS `logId`, `loggs`.`logLogCount` AS `logCount`, `loggs`.`logLastLog` AS `lastLog`, `users`.`userId` AS `userId`, `users`.`userUserName` AS `userName`, `users`.`userEmail` AS `userEmail` FROM (`loggs` join `users`) WHERE `loggs`.`logUserFk` = `users`.`userId` ;

-- --------------------------------------------------------

--
-- Structure for view `view_comments`
--
DROP TABLE IF EXISTS `view_comments`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_comments`  AS SELECT `comments`.`commentId` AS `commentId`, `comments`.`commentText` AS `commentText`, `comments`.`commentCreated` AS `commentCreated`, `comments`.`commentActive` AS `commentActive`, `comments`.`commentImg` AS `commentImg`, `comments`.`commentHref` AS `commentHref`, `comments`.`commentTotalLikes` AS `commentTotalLikes`, `comments`.`commentTotalReplays` AS `commentTotalReplays`, `users`.`userId` AS `userId`, `users`.`userUserName` AS `userName`, `users`.`userAvatar` AS `userAvatar`, `events`.`eventId` AS `eventId` FROM ((`comments` join `users` on(`comments`.`commentUserFk` = `users`.`userId`)) join `events` on(`comments`.`commentEventFk` = `events`.`eventId`)) ;

-- --------------------------------------------------------

--
-- Structure for view `view_events`
--
DROP TABLE IF EXISTS `view_events`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_events`  AS SELECT `events`.`eventId` AS `eventId`, `events`.`eventName` AS `eventName`, `events`.`eventAbout` AS `eventAbout`, `events`.`eventTime` AS `eventTime`, `events`.`eventPlace` AS `eventPlace`, `events`.`eventImg` AS `eventImg`, `events`.`eventCreated` AS `eventCreated`, `events`.`eventActive` AS `eventActive`, `events`.`eventActivityType` AS `eventType`, `events`.`eventTotalFollowees` AS `eventTotalFollowees`, `events`.`eventTotalComments` AS `eventTotalComments`, `owner`.`userId` AS `userId`, `owner`.`userUserName` AS `userName`, `owner`.`userAvatar` AS `userAvatar` FROM (`events` join `users` `owner` on(`events`.`eventOwnerFk` = `owner`.`userId`)) ;

-- --------------------------------------------------------

--
-- Structure for view `view_messages`
--
DROP TABLE IF EXISTS `view_messages`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_messages`  AS SELECT `sender`.`userId` AS `senderId`, `sender`.`userUserName` AS `senderNick`, `sender`.`userAvatar` AS `senderAvatar`, `rooms`.`roomId` AS `roomId`, `rooms`.`roomName` AS `roomName`, `reciver`.`userId` AS `reciverId`, `reciver`.`userUserName` AS `reciverNick`, `reciver`.`userAvatar` AS `reciverAvatar`, `messages`.`messageId` AS `messageId`, `messages`.`messageText` AS `messageText`, `messages`.`messageImg` AS `messageImg` FROM ((((`users` `sender` join `users` `reciver`) join `messages`) join `rooms`) join `inrooms`) WHERE `messages`.`messageFromUserFk` = `sender`.`userId` AND `messages`.`messageToRoomFk` = `rooms`.`roomId` AND `inrooms`.`inroomRoomFk` = `rooms`.`roomId` AND `inrooms`.`inroomUserFk` = `reciver`.`userId` ;

-- --------------------------------------------------------

--
-- Structure for view `view_messages2`
--
DROP TABLE IF EXISTS `view_messages2`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_messages2`  AS SELECT `sender`.`userId` AS `senderId`, `sender`.`userUserName` AS `senderNick`, `sender`.`userAvatar` AS `senderAvatar`, `rooms`.`roomId` AS `roomId`, `rooms`.`roomName` AS `roomName`, `reciver`.`userId` AS `reciverId`, `reciver`.`userUserName` AS `reciverNick`, `reciver`.`userAvatar` AS `reciverAvatar`, `messages`.`messageId` AS `messageId`, `messages`.`messageText` AS `messageText`, `messages`.`messageImg` AS `messageImg` FROM ((((`users` `sender` join `users` `reciver`) join `messages`) join `rooms`) join `recivers`) WHERE `sender`.`userId` <> `reciver`.`userId` AND `messages`.`messageFromUserFk` = `sender`.`userId` AND `messages`.`messageToRoomFk` = `rooms`.`roomId` AND `recivers`.`reciverMessageFk` = `messages`.`messageId` AND `recivers`.`reciverRoomFk` = `rooms`.`roomId` AND `recivers`.`reciverUserFk` = `reciver`.`userId` ;

-- --------------------------------------------------------

--
-- Structure for view `view_rooms`
--
DROP TABLE IF EXISTS `view_rooms`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_rooms`  AS SELECT `sender`.`userId` AS `senderId`, `sender`.`userUserName` AS `senderNick`, `sender`.`userAvatar` AS `senderAvatar`, `rooms`.`roomId` AS `roomId`, `rooms`.`roomName` AS `roomName`, `reciver`.`userId` AS `reciverId`, `reciver`.`userUserName` AS `reciverNick`, `reciver`.`userAvatar` AS `reciverAvatar` FROM (((`users` `sender` join `users` `reciver`) join `rooms`) join `inrooms`) WHERE `sender`.`userId` <> `reciver`.`userId` AND `rooms`.`roomOwnerFk` = `sender`.`userId` AND `rooms`.`roomId` = `inrooms`.`inroomRoomFk` AND `inrooms`.`inroomUserFk` = `reciver`.`userId` ;

-- --------------------------------------------------------

--
-- Structure for view `view_users`
--
DROP TABLE IF EXISTS `view_users`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_users`  AS SELECT `users`.`userId` AS `userId`, `users`.`userFullName` AS `userFullName`, `users`.`userUserName` AS `userUserName`, `users`.`userEmail` AS `userEmail`, `users`.`userAvatar` AS `userAvatar`, `users`.`userAbout` AS `userAbout`, `users`.`userActive` AS `userActive`, `users`.`userCity` AS `userCity`, `users`.`userLanguage` AS `userLanguage`, `users`.`userCreated` AS `userCreated`, `users`.`userTotalMessages` AS `userTotalMessages` FROM `users` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activities`
--
ALTER TABLE `activities`
  ADD PRIMARY KEY (`activityId`),
  ADD UNIQUE KEY `activityId` (`activityId`);

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`commentId`),
  ADD UNIQUE KEY `commentId` (`commentId`);

--
-- Indexes for table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`eventId`),
  ADD UNIQUE KEY `eventId` (`eventId`);

--
-- Indexes for table `galeries`
--
ALTER TABLE `galeries`
  ADD PRIMARY KEY (`galeryId`),
  ADD UNIQUE KEY `galeryId` (`galeryId`);

--
-- Indexes for table `inrooms`
--
ALTER TABLE `inrooms`
  ADD PRIMARY KEY (`inroomId`),
  ADD UNIQUE KEY `inroomId` (`inroomId`);

--
-- Indexes for table `loggs`
--
ALTER TABLE `loggs`
  ADD PRIMARY KEY (`logId`),
  ADD UNIQUE KEY `logId` (`logId`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`messageId`),
  ADD UNIQUE KEY `messageId` (`messageId`);

--
-- Indexes for table `reactions`
--
ALTER TABLE `reactions`
  ADD PRIMARY KEY (`reactionId`),
  ADD UNIQUE KEY `reactionId` (`reactionId`);

--
-- Indexes for table `recivers`
--
ALTER TABLE `recivers`
  ADD PRIMARY KEY (`reciverId`),
  ADD UNIQUE KEY `reciverId` (`reciverId`);

--
-- Indexes for table `replays`
--
ALTER TABLE `replays`
  ADD PRIMARY KEY (`replayId`),
  ADD UNIQUE KEY `replayId` (`replayId`);

--
-- Indexes for table `rooms`
--
ALTER TABLE `rooms`
  ADD UNIQUE KEY `roomId` (`roomId`),
  ADD UNIQUE KEY `roomId_2` (`roomId`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`userId`),
  ADD UNIQUE KEY `user_id` (`userId`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activities`
--
ALTER TABLE `activities`
  MODIFY `activityId` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `commentId` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=178;

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `eventId` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `galeries`
--
ALTER TABLE `galeries`
  MODIFY `galeryId` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `inrooms`
--
ALTER TABLE `inrooms`
  MODIFY `inroomId` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=75;

--
-- AUTO_INCREMENT for table `loggs`
--
ALTER TABLE `loggs`
  MODIFY `logId` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `messageId` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=71;

--
-- AUTO_INCREMENT for table `reactions`
--
ALTER TABLE `reactions`
  MODIFY `reactionId` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `recivers`
--
ALTER TABLE `recivers`
  MODIFY `reciverId` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `replays`
--
ALTER TABLE `replays`
  MODIFY `replayId` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `rooms`
--
ALTER TABLE `rooms`
  MODIFY `roomId` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=84;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `userId` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
