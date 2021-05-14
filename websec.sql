-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 14, 2021 at 01:30 AM
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `createComment` (IN `eId` INT(20) UNSIGNED, IN `uId` INT(20) UNSIGNED, IN `cText` VARCHAR(280))  INSERT INTO comments (commentEventFk, commentUserFk, commentText) 
  VALUES (eId, uId, cText)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `createLogs` (IN `uId` INT(20) UNSIGNED, IN `tNow` DATETIME)  INSERT INTO loggs VALUES(null, uId, 0, tNow)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `createUser` (IN `uId` INT(20) UNSIGNED, IN `uFullName` VARCHAR(50), IN `uNick` VARCHAR(25), IN `uEmail` VARCHAR(50), IN `uPass` VARCHAR(255), IN `uAvatar` VARCHAR(40), IN `uCode` VARCHAR(6), IN `uActive` INT(1) UNSIGNED)  INSERT INTO users (userId, userFullName, userUserName, userEmail, userPassword, userAvatar, userVeryfyCode, userActive)
VALUES(uId, uFullName, uNick, uEmail, uPass, uAvatar, uCode, uActive)$$

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

CREATE DEFINER=`root`@`localhost` PROCEDURE `getUserById` (IN `uId` INT(20) UNSIGNED)  SELECT * FROM users 
WHERE userId = uId 
LIMIT 1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getUserByUserName` (IN `uNick` VARCHAR(25))  SELECT * FROM users 
WHERE userUserName = uNick
LIMIT 1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getUserLog` (IN `uName` VARCHAR(25))  SELECT * FROM logtry
WHERE logtry.userName = uName 
LIMIT 1$$

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
(141, 2, 8, 'gg', '2021-05-14 01:12:27', 1, NULL, NULL, 0, 0),
(146, 1, 8, 'gg', '2021-05-14 01:19:16', 1, NULL, NULL, 0, 0),
(147, 1, 7, 'hhhh', '2021-05-14 01:28:08', 1, NULL, NULL, 0, 0);

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
  `galeryImgCount` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `galeryCreated` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `inrooms`
--

CREATE TABLE `inrooms` (
  `inroomRoomFk` bigint(20) UNSIGNED NOT NULL,
  `inroomUserFk` bigint(20) UNSIGNED NOT NULL,
  `inroomCreated` datetime NOT NULL DEFAULT current_timestamp(),
  `inroomActive` tinyint(1) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
(3, 8, 3, '2021-05-14 01:23:53'),
(4, 7, 0, '2021-05-14 01:25:14');

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

-- --------------------------------------------------------

--
-- Table structure for table `reactions`
--

CREATE TABLE `reactions` (
  `reactionId` bigint(20) UNSIGNED NOT NULL,
  `reactionName` varchar(20) NOT NULL,
  `reactionCount` int(10) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `recivers`
--

CREATE TABLE `recivers` (
  `reciverId` bigint(20) UNSIGNED NOT NULL,
  `reciverUserFk` bigint(20) UNSIGNED NOT NULL,
  `reciverRoomFk` bigint(20) UNSIGNED DEFAULT NULL,
  `reciverMessageFk` bigint(20) UNSIGNED NOT NULL,
  `reciverReactionFk` bigint(20) UNSIGNED DEFAULT NULL,
  `reciverRead` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `reciverActive` tinyint(1) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
  `roomName` varchar(40) NOT NULL,
  `roomCreated` datetime NOT NULL DEFAULT current_timestamp(),
  `roomActive` tinyint(1) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
(8, 'test', 'qweqwe', 'cvb@cv.pl', '$argon2id$v=19$m=65536,t=4,p=1$SHFEZVlKNlcvSlVTT0NWSA$3nmCZTl81pVtjVaFTMR2rAwvCaIbUvk5+tpsi4YKFyA', 'testasd', 'about me', '1e7cc2d6c99a39e8085f25861d92adda', 1, 'test', 'test', '2021-05-10 00:12:18', 20, 20, 20, 20, 20);

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
  MODIFY `commentId` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=148;

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `eventId` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `galeries`
--
ALTER TABLE `galeries`
  MODIFY `galeryId` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `loggs`
--
ALTER TABLE `loggs`
  MODIFY `logId` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `messageId` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reactions`
--
ALTER TABLE `reactions`
  MODIFY `reactionId` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `recivers`
--
ALTER TABLE `recivers`
  MODIFY `reciverId` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `replays`
--
ALTER TABLE `replays`
  MODIFY `replayId` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `rooms`
--
ALTER TABLE `rooms`
  MODIFY `roomId` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `userId` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
