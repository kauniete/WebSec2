-- phpMyAdmin SQL Dump
-- version 4.6.6deb5ubuntu0.5
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Aug 08, 2021 at 10:10 PM
-- Server version: 5.7.35-0ubuntu0.18.04.1
-- PHP Version: 7.2.24-0ubuntu0.18.04.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `getGalleryImages` (IN `ownerId` INT(20) UNSIGNED)  SELECT * FROM galeries
WHERE galeryUserFk = ownerId$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getLastChatMessages` (IN `chatRoomId` INT(20) UNSIGNED, IN `lastMsgId` INT(20) UNSIGNED)  SELECT * FROM messages
WHERE messageToRoomFk = chatRoomId
AND messageId > lastMsgId
LIMIT 25$$

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

CREATE DEFINER=`root`@`localhost` PROCEDURE `getUserByEmail` (IN `uEmail` VARCHAR(50))  SELECT * FROM users 
WHERE userEmail = uEmail
LIMIT 1$$

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
  `activityUseCount` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `activityCreated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
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
  `commentCreated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `commentActive` tinyint(1) UNSIGNED NOT NULL DEFAULT '1',
  `commentImg` varchar(40) DEFAULT NULL,
  `commentHref` varchar(2000) DEFAULT NULL,
  `commentTotalLikes` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `commentTotalReplays` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `comments`
--

INSERT INTO `comments` (`commentId`, `commentEventFk`, `commentUserFk`, `commentText`, `commentCreated`, `commentActive`, `commentImg`, `commentHref`, `commentTotalLikes`, `commentTotalReplays`) VALUES
(29, 2, 1, '................', '2021-05-11 00:25:34', 1, NULL, NULL, 0, 0),
(77, 1, 1, 'hophop', '2021-05-11 04:20:02', 1, NULL, NULL, 0, 0),
(106, 1, 1, 'X', '2021-05-11 18:00:20', 1, NULL, NULL, 0, 0),
(115, 3, 1, '&lt;script&gt;document.querySelector(&quot;body&quot;).style.color = &quot;red&quot; &lt;/script&gt;', '2021-05-12 20:03:55', 1, NULL, NULL, 0, 0),
(130, 2, 1, 'ggg', '2021-05-13 03:31:22', 1, NULL, NULL, 0, 0),
(218, 2, 214, 'gey', '2021-08-04 13:24:15', 1, NULL, NULL, 0, 0),
(221, 1, 214, 'hey cool event', '2021-08-04 13:29:41', 1, NULL, NULL, 0, 0),
(223, 1, 218, 'i want to go ', '2021-08-04 14:30:25', 1, NULL, NULL, 0, 0),
(225, 3, 214, 'so cool', '2021-08-04 23:32:19', 1, NULL, NULL, 0, 0),
(227, 1, 165, '&lt;script&gt;alert(\'test\');&lt;/script&gt;', '2021-08-05 13:38:03', 1, NULL, NULL, 0, 0),
(231, 1, 165, 'hey', '2021-08-08 22:07:42', 1, NULL, NULL, 0, 0);

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
  `eventCreated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `eventActive` tinyint(1) UNSIGNED NOT NULL DEFAULT '1',
  `eventActivityType` varchar(30) NOT NULL,
  `eventTotalFollowees` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `eventTotalComments` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `events`
--

INSERT INTO `events` (`eventId`, `eventName`, `eventOwnerFk`, `eventAbout`, `eventTime`, `eventPlace`, `eventImg`, `eventCreated`, `eventActive`, `eventActivityType`, `eventTotalFollowees`, `eventTotalComments`) VALUES
(1, 'Event Nr 1 Run', 1, 'run run run', '2021-05-19 12:14:44', 'address 1', 'photo-1526676037777-05a232554f77', '2021-05-10 00:18:51', 1, 'running', 0, 0),
(2, 'Event Nr 2 Swim', 1, 'swim swim swim', '2021-05-14 10:14:44', 'address 2', 'photo-1472978346569-9fa7ea7adf4a', '2021-05-10 00:18:51', 1, 'swimming', 0, 0),
(3, 'Event Nr 3 Play', 5, 'Play Play play ', '2021-05-12 18:36:49', 'address3 ', 'photo-1547347298-4074fc3086f0', '2021-05-12 18:43:35', 1, 'playing', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `followers`
--

CREATE TABLE `followers` (
  `followerFollowerFk` bigint(20) UNSIGNED NOT NULL,
  `followerFolloweeFk` bigint(20) UNSIGNED NOT NULL,
  `followerRelation` tinyint(1) UNSIGNED NOT NULL DEFAULT '0',
  `followerCreated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `followings`
--

CREATE TABLE `followings` (
  `followingUserFk` bigint(20) UNSIGNED NOT NULL,
  `followingActivityFk` bigint(20) UNSIGNED DEFAULT NULL,
  `followingEventFk` bigint(20) UNSIGNED DEFAULT NULL,
  `followingCreated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `galeries`
--

CREATE TABLE `galeries` (
  `galeryId` bigint(20) UNSIGNED NOT NULL,
  `galeryUserFk` bigint(20) UNSIGNED NOT NULL,
  `galeryImage` varchar(70) NOT NULL,
  `galeryImgSize` int(5) UNSIGNED NOT NULL,
  `galeryCreated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `galeries`
--

INSERT INTO `galeries` (`galeryId`, `galeryUserFk`, `galeryImage`, `galeryImgSize`, `galeryCreated`) VALUES
(5, 1, 'hoho', 2000, '2021-06-05 01:36:23'),
(7, 1, 'lalalala', 2000, '2021-06-05 01:43:51'),
(34, 8, 'arangodb-logo.png', 27091, '2021-06-05 13:32:23'),
(39, 17, 'a3ad6d4d-0ec0-4ab8-a619-50b97e44ab09-ori', 56656, '2021-06-06 15:40:26'),
(40, 17, '143351776_149563320307290_13230104346098', 61323, '2021-06-06 15:42:33'),
(41, 17, '143299312_1469604130072415_2685182826010', 78223, '2021-06-06 15:57:52'),
(42, 43, '26754429_10213430620672400_919054584_n.j', 37297, '2021-07-27 22:34:08'),
(43, 43, 'hi.jpg', 37297, '2021-07-27 22:38:33'),
(45, 214, 'favicon-yellow-mellow.png', 11489, '2021-08-04 20:48:17'),
(47, 214, 'favicon.png', 20287, '2021-08-04 23:07:52'),
(78, 165, 'Donovan_-_Mellow_Yellow.jpg', 28545, '2021-08-06 21:44:28'),
(79, 165, 'original.jpg', 158790, '2021-08-07 22:43:02'),
(80, 165, 'index.jpg', 5261, '2021-08-07 22:43:59'),
(81, 165, 'is-mellow-yellow-gluten-free.jpg', 20207, '2021-08-07 23:16:42'),
(82, 165, '950x350-mellow-yellow-solid-color-background.jpg', 5973, '2021-08-08 12:19:24'),
(83, 165, 'ad50ce29e7e72f0c37d0717b8870bc6f.png', 16064, '2021-08-08 22:08:36');

-- --------------------------------------------------------

--
-- Table structure for table `loggs`
--

CREATE TABLE `loggs` (
  `logId` bigint(20) UNSIGNED NOT NULL,
  `logUserFk` bigint(20) UNSIGNED NOT NULL,
  `logLogCount` tinyint(1) UNSIGNED NOT NULL DEFAULT '0',
  `logLastLog` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `loggs`
--

INSERT INTO `loggs` (`logId`, `logUserFk`, `logLogCount`, `logLastLog`) VALUES
(1, 2, 0, '2021-05-14 10:14:44'),
(2, 1, 1, '2021-07-30 15:40:29'),
(3, 8, 1, '2021-05-14 15:30:21'),
(4, 7, 0, '2021-05-14 01:25:14'),
(5, 12, 1, '2021-05-14 15:34:47'),
(6, 17, 0, '2021-06-06 15:51:27'),
(7, 38, 1, '2021-07-24 21:38:07'),
(8, 41, 3, '2021-07-27 21:20:26'),
(9, 42, 0, '2021-07-27 22:11:40'),
(10, 44, 0, '2021-07-28 17:31:10'),
(11, 48, 0, '2021-07-28 17:42:30'),
(12, 43, 0, '2021-07-28 18:11:47'),
(13, 52, 0, '2021-07-29 14:49:04'),
(14, 53, 10, '2021-07-30 18:45:55');

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
  `messageCreated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `messageHref` varchar(2000) DEFAULT NULL,
  `messageQuoteFk` bigint(20) UNSIGNED DEFAULT NULL,
  `messageActive` tinyint(1) UNSIGNED NOT NULL DEFAULT '1',
  `senderNick` varchar(25) NOT NULL,
  `senderAvatar` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `messages`
--

INSERT INTO `messages` (`messageId`, `messageFromUserFk`, `messageToRoomFk`, `messageText`, `messageCreated`, `messageHref`, `messageQuoteFk`, `messageActive`, `senderNick`, `senderAvatar`) VALUES
(404, 165, 561, 'hi', '2021-08-06 20:45:18', NULL, NULL, 1, 'aldona', 'default_profile_reasonably_small'),
(407, 165, 561, 'hello', '2021-08-06 21:39:02', NULL, NULL, 1, 'aldona', 'default_profile_reasonably_small'),
(408, 166, 561, 'kaip sekasi', '2021-08-06 21:50:48', NULL, NULL, 1, 'dagnis', 'default_profile_reasonably_small'),
(410, 165, 561, 'super', '2021-08-06 21:59:06', NULL, NULL, 1, 'aldona', 'default_profile_reasonably_small'),
(416, 165, 561, 'you are the best', '2021-08-06 22:52:20', NULL, NULL, 1, 'aldona', 'default_profile_reasonably_small'),
(425, 165, 573, 'hejsa', '2021-08-07 20:22:49', NULL, NULL, 1, 'aldona', 'default_profile_reasonably_small'),
(438, 165, 573, 'wats up', '2021-08-07 22:31:29', NULL, NULL, 1, 'aldona', 'default_profile_reasonably_small'),
(439, 165, 574, 'hey', '2021-08-07 22:32:46', NULL, NULL, 1, 'aldona', 'default_profile_reasonably_small'),
(440, 165, 574, 'so', '2021-08-07 22:33:49', NULL, NULL, 1, 'aldona', 'default_profile_reasonably_small'),
(441, 165, 573, 'how is life', '2021-08-07 22:34:20', NULL, NULL, 1, 'aldona', 'default_profile_reasonably_small'),
(442, 165, 574, 'aha', '2021-08-07 22:46:46', NULL, NULL, 1, 'aldona', 'default_profile_reasonably_small'),
(443, 165, 574, 'long time', '2021-08-08 12:21:04', NULL, NULL, 1, 'aldona', 'default_profile_reasonably_small'),
(444, 166, 561, 'me too', '2021-08-08 12:22:11', NULL, NULL, 1, 'dagnis', 'default_profile_reasonably_small'),
(445, 165, 561, 'good to know', '2021-08-08 16:31:51', NULL, NULL, 1, 'aldona', 'default_profile_reasonably_small'),
(446, 166, 561, 'so', '2021-08-08 16:33:15', NULL, NULL, 1, 'dagnis', 'default_profile_reasonably_small');

-- --------------------------------------------------------

--
-- Table structure for table `reactions`
--

CREATE TABLE `reactions` (
  `reactionId` bigint(20) UNSIGNED NOT NULL,
  `reactionName` varchar(20) NOT NULL,
  `reactionCount` int(10) NOT NULL DEFAULT '0'
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
-- Table structure for table `rooms`
--

CREATE TABLE `rooms` (
  `roomId` bigint(20) UNSIGNED NOT NULL,
  `roomOwnerFk` bigint(20) UNSIGNED NOT NULL,
  `user2Fk` bigint(20) UNSIGNED NOT NULL,
  `roomName` varchar(40) DEFAULT NULL,
  `roomCreated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `roomActive` tinyint(1) UNSIGNED NOT NULL DEFAULT '1',
  `user2Avatar` varchar(60) DEFAULT NULL,
  `user2Nick` varchar(25) NOT NULL,
  `roomOwnerNick` varchar(25) NOT NULL,
  `roomOwnerAvatar` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `rooms`
--

INSERT INTO `rooms` (`roomId`, `roomOwnerFk`, `user2Fk`, `roomName`, `roomCreated`, `roomActive`, `user2Avatar`, `user2Nick`, `roomOwnerNick`, `roomOwnerAvatar`) VALUES
(561, 165, 166, NULL, '2021-08-06 20:45:13', 1, 'default_profile_reasonably_small', 'dagnis', 'aldona', 'default_profile_reasonably_small'),
(573, 165, 312, NULL, '2021-08-07 20:17:19', 1, 'default_profile_reasonably_small', 'neringa', 'aldona', 'default_profile_reasonably_small'),
(574, 165, 214, NULL, '2021-08-07 21:37:43', 1, 'default_profile_reasonably_small', 'nijole', 'aldona', 'default_profile_reasonably_small');

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
  `userAvatar` varchar(60) DEFAULT NULL,
  `userAbout` varchar(500) DEFAULT NULL,
  `userVeryfyCode` varchar(40) NOT NULL,
  `userActive` tinyint(1) UNSIGNED NOT NULL DEFAULT '0',
  `userCity` varchar(60) DEFAULT NULL,
  `userLanguage` varchar(5) DEFAULT NULL,
  `userCreated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `userTotalMessages` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `userTotalImg` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `userTotalFollowers` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `userTotalFollowees` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `userTotalFollowing` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`userId`, `userFullName`, `userUserName`, `userEmail`, `userPassword`, `userAvatar`, `userAbout`, `userVeryfyCode`, `userActive`, `userCity`, `userLanguage`, `userCreated`, `userTotalMessages`, `userTotalImg`, `userTotalFollowers`, `userTotalFollowees`, `userTotalFollowing`) VALUES
(1, 'a aa', 'aaa', 'a@a.com', 'pass1', 'photo-1519872775884-29a6fea271ca', NULL, 'code1', 1, NULL, NULL, '2021-05-10 00:12:18', 0, 0, 0, 0, 0),
(5, 'z zz', 'zzz', 'z@z.com', 'Pass5', 'photo-1519613273847-6daa1d54e198', NULL, 'code5', 1, NULL, NULL, '2021-05-12 18:41:55', 0, 0, 0, 0, 0),
(165, 'test', 'aldona', 'aldona@aldona.com', '$2y$10$VhZOfsxjirPigGrFqvilD.Cbl.Kv.MDykVL2XP8OpBMCfd9ZQeIkK', 'default_profile_reasonably_small', NULL, '7850987b893f7940ee022d008b7ac98f', 1, NULL, NULL, '2021-07-31 23:19:49', 0, 0, 0, 0, 0),
(166, 'test', 'dagnis', 'dagnis@dagnis.com', '$2y$10$9Ul4KW01e0qkZrQNNt19XuTwPl.uXmHzvdRD6fh3k4O3THCUoWw5e', 'default_profile_reasonably_small', NULL, 'c9682c8341fdf5de3ccf2a9bac89cb50', 1, NULL, NULL, '2021-07-31 23:26:18', 0, 0, 0, 0, 0),
(214, 'test', 'nijole', 'nijole@nijole.com', '$2y$10$KUAXmUgVTwTkKqMQnk6ML.O/ZQiQLlpiH0zT31sdakWSZ5Sx/uBau', 'default_profile_reasonably_small', NULL, '40b04329553430e2a627a0a57aa0e8cf', 1, NULL, NULL, '2021-08-03 16:44:54', 0, 0, 0, 0, 0),
(218, 'test', 'birute', 'birute@birute.com', '$2y$10$S1TODueW7br4TUtZcYsZ5uu3EEOuZe.o00FtaRgsY9lKo3UpC4G9G', 'default_profile_reasonably_small', NULL, 'b505c8f522021b70a2a0da4b2bcde811', 1, NULL, NULL, '2021-08-04 14:18:03', 0, 0, 0, 0, 0),
(312, 'test', 'neringa', 'neringa@neringa.com', '$2y$10$nDGwPH3ZwlMu1pJFJZ3D4uJ5VnLYmk5l5WJVKiN7LnKhjfaSr0OCi', 'default_profile_reasonably_small', NULL, '7174435a08006f8fafb0f916d0c3b480', 1, NULL, NULL, '2021-08-04 19:42:27', 0, 0, 0, 0, 0),
(313, 'test', 'azuolas', 'azuolas@azuolas.com', '$2y$10$.d8.HSypaRUp44.oKu7ZrO/Avx0R1r9Vtd5NxXtHaPN8SOOwWL2n.', 'default_profile_reasonably_small', NULL, '75f00ec17af0b1efe215e0fe728edc35', 1, NULL, NULL, '2021-08-08 17:45:23', 0, 0, 0, 0, 0);

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
,`userAvatar` varchar(60)
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
,`userAvatar` varchar(60)
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
,`userAvatar` varchar(60)
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

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `logtry`  AS  select `loggs`.`logId` AS `logId`,`loggs`.`logLogCount` AS `logCount`,`loggs`.`logLastLog` AS `lastLog`,`users`.`userId` AS `userId`,`users`.`userUserName` AS `userName`,`users`.`userEmail` AS `userEmail` from (`loggs` join `users`) where (`loggs`.`logUserFk` = `users`.`userId`) ;

-- --------------------------------------------------------

--
-- Structure for view `view_comments`
--
DROP TABLE IF EXISTS `view_comments`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_comments`  AS  select `comments`.`commentId` AS `commentId`,`comments`.`commentText` AS `commentText`,`comments`.`commentCreated` AS `commentCreated`,`comments`.`commentActive` AS `commentActive`,`comments`.`commentImg` AS `commentImg`,`comments`.`commentHref` AS `commentHref`,`comments`.`commentTotalLikes` AS `commentTotalLikes`,`comments`.`commentTotalReplays` AS `commentTotalReplays`,`users`.`userId` AS `userId`,`users`.`userUserName` AS `userName`,`users`.`userAvatar` AS `userAvatar`,`events`.`eventId` AS `eventId` from ((`comments` join `users` on((`comments`.`commentUserFk` = `users`.`userId`))) join `events` on((`comments`.`commentEventFk` = `events`.`eventId`))) ;

-- --------------------------------------------------------

--
-- Structure for view `view_events`
--
DROP TABLE IF EXISTS `view_events`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_events`  AS  select `events`.`eventId` AS `eventId`,`events`.`eventName` AS `eventName`,`events`.`eventAbout` AS `eventAbout`,`events`.`eventTime` AS `eventTime`,`events`.`eventPlace` AS `eventPlace`,`events`.`eventImg` AS `eventImg`,`events`.`eventCreated` AS `eventCreated`,`events`.`eventActive` AS `eventActive`,`events`.`eventActivityType` AS `eventType`,`events`.`eventTotalFollowees` AS `eventTotalFollowees`,`events`.`eventTotalComments` AS `eventTotalComments`,`owner`.`userId` AS `userId`,`owner`.`userUserName` AS `userName`,`owner`.`userAvatar` AS `userAvatar` from (`events` join `users` `owner` on((`events`.`eventOwnerFk` = `owner`.`userId`))) ;

-- --------------------------------------------------------

--
-- Structure for view `view_users`
--
DROP TABLE IF EXISTS `view_users`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_users`  AS  select `users`.`userId` AS `userId`,`users`.`userFullName` AS `userFullName`,`users`.`userUserName` AS `userUserName`,`users`.`userEmail` AS `userEmail`,`users`.`userAvatar` AS `userAvatar`,`users`.`userAbout` AS `userAbout`,`users`.`userActive` AS `userActive`,`users`.`userCity` AS `userCity`,`users`.`userLanguage` AS `userLanguage`,`users`.`userCreated` AS `userCreated`,`users`.`userTotalMessages` AS `userTotalMessages` from `users` ;

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
  MODIFY `commentId` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=232;
--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `eventId` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `galeries`
--
ALTER TABLE `galeries`
  MODIFY `galeryId` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=84;
--
-- AUTO_INCREMENT for table `loggs`
--
ALTER TABLE `loggs`
  MODIFY `logId` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;
--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `messageId` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=447;
--
-- AUTO_INCREMENT for table `reactions`
--
ALTER TABLE `reactions`
  MODIFY `reactionId` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `rooms`
--
ALTER TABLE `rooms`
  MODIFY `roomId` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=575;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `userId` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=314;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
