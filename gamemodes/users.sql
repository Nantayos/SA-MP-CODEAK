SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

CREATE TABLE `users` (
  `ID` int(11) NOT NULL,
  `Username` varchar(30) NOT NULL,
  `Password` varchar(129) NOT NULL,
  `IP` varchar(17) NOT NULL,
  `Cash` varchar(11) NOT NULL,
  `Kills` varchar(11) NOT NULL,
  `Deaths` varchar(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;