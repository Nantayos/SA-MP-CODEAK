--
-- Table structure for table `bans`
--

DROP TABLE IF EXISTS `bans`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bans` (
  `id` int(11) NOT NULL auto_increment,
  `type` tinyint(2) NOT NULL,
  `player` int(11) NOT NULL,
  `time` int(11) NOT NULL,
  `amount` bigint(20) NOT NULL default '0',
  `ip` varchar(16) NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `logins`
--

DROP TABLE IF EXISTS `logins`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `logins` (
  `id` int(11) NOT NULL auto_increment,
  `time` int(11) NOT NULL,
  `ip` varchar(16) NOT NULL,
  `userid` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `leaders`
--

DROP TABLE IF EXISTS `leaders`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `leaders` (
  `id` int(11) NOT NULL auto_increment,
  `Leader1` int(11) NOT NULL default '0',
  `Leader2` int(11) NOT NULL default '0',
  `Leader3` int(11) NOT NULL default '0',
  `Leader4` int(11) NOT NULL default '0',
  `Leader5` int(11) NOT NULL default '0',
  `Leader6` int(11) NOT NULL default '0',
  `Leader7` int(11) NOT NULL default '0',
  `Leader8` int(11) NOT NULL default '0',
  `Leader9` int(11) NOT NULL default '0',
  `Leader10` int(11) NOT NULL default '0',
  `Leader11` int(11) NOT NULL default '0',
  `Leader12` int(11) NOT NULL default '0',
  `Leader13` int(11) NOT NULL default '0',
  `Leader14` int(11) NOT NULL default '0',
  `Leader15` int(11) NOT NULL default '0',
  `Leader16` int(11) NOT NULL default '0',
  `Leader17` int(11) NOT NULL default '0',
  `LeaderName1` varchar(50) collate latin1_general_ci NOT NULL default 'Empty',
  `LeaderName2` varchar(50) collate latin1_general_ci NOT NULL default 'Empty',
  `LeaderName3` varchar(50) collate latin1_general_ci NOT NULL default 'Empty',
  `LeaderName4` varchar(50) collate latin1_general_ci NOT NULL default 'Empty',
  `LeaderName5` varchar(50) collate latin1_general_ci NOT NULL default 'Empty',
  `LeaderName6` varchar(50) collate latin1_general_ci NOT NULL default 'Empty',
  `LeaderName7` varchar(50) collate latin1_general_ci NOT NULL default 'Empty',
  `LeaderName8` varchar(50) collate latin1_general_ci NOT NULL default 'Empty',
  `LeaderName9` varchar(50) collate latin1_general_ci NOT NULL default 'Empty',
  `LeaderName10` varchar(50) collate latin1_general_ci NOT NULL default 'Empty',
  `LeaderName11` varchar(50) collate latin1_general_ci NOT NULL default 'Empty',
  `LeaderName12` varchar(50) collate latin1_general_ci NOT NULL default 'Empty',
  `LeaderName13` varchar(50) collate latin1_general_ci NOT NULL default 'Empty',
  `LeaderName14` varchar(50) collate latin1_general_ci NOT NULL default 'Empty',
  `LeaderName15` varchar(50) collate latin1_general_ci NOT NULL default 'Empty',
  `LeaderName16` varchar(50) collate latin1_general_ci NOT NULL default 'Empty',
  `LeaderName17` varchar(50) collate latin1_general_ci NOT NULL default 'Empty',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

INSERT INTO `leaders` (
`id` ,
`Leader1` ,
`Leader2` ,
`Leader3` ,
`Leader4` ,
`Leader5` ,
`Leader6` ,
`Leader7` ,
`Leader8` ,
`Leader9` ,
`Leader10` ,
`Leader11` ,
`Leader12` ,
`Leader13` ,
`Leader14` ,
`Leader15` ,
`Leader16` ,
`Leader17` ,
`LeaderName1` ,
`LeaderName2` ,
`LeaderName3` ,
`LeaderName4` ,
`LeaderName5` ,
`LeaderName6` ,
`LeaderName7` ,
`LeaderName8` ,
`LeaderName9` ,
`LeaderName10` ,
`LeaderName11` ,
`LeaderName12` ,
`LeaderName13` ,
`LeaderName14` ,
`LeaderName15` ,
`LeaderName16` ,
`LeaderName17` 
)
VALUES (
NULL , '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty'
);

--
-- Table structure for table `players`
--

DROP TABLE IF EXISTS `players`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `players` (
  `id` int(11) NOT NULL auto_increment,
  `Name` varchar(50) collate latin1_general_ci NOT NULL,
  `Password` varchar(50) character set latin1 collate latin1_bin NOT NULL,
  `Leve` int(11) NOT NULL default '1',
  `Die` int(11) NOT NULL default '0',
  `Full` int(11) NOT NULL default '1000',
  `Robbank` int(11) NOT NULL default '0',
  `Carkey` int(11) NOT NULL default '999',
  `Crash` int(11) NOT NULL default '0',
  `AdminLevel` int(11) NOT NULL default '0',
  `DonateRank` int(11) NOT NULL default '0',
  `UpgradePoints` int(11) NOT NULL default '0',
  `ConnectedTime` int(11) NOT NULL default '0',
  `Registered` int(11) NOT NULL default '0',
  `Sex` int(11) NOT NULL default '0',
  `Age` int(11) NOT NULL default '0',
  `Origin` int(11) NOT NULL default '1',
  `CK` int(11) NOT NULL default '0',
  `Muted` int(11) NOT NULL default '0',
  `Respect` int(11) NOT NULL default '0',
  `Money` bigint(20) NOT NULL default '0',
  `Bank` int(11) NOT NULL default '0',
  `Crimes` int(11) NOT NULL default '0',
  `Kills` int(11) NOT NULL default '0',
  `Deaths` int(11) NOT NULL default '0',
  `Arrested` int(11) NOT NULL default '0',
  `WantedDeaths` int(11) NOT NULL default '0',
  `Phonebook` int(11) NOT NULL default '0',
  `LottoNr` int(11) NOT NULL default '0',
  `Fishes` int(11) NOT NULL default '0',
  `BiggestFish` int(11) NOT NULL default '0',
  `Job` int(11) NOT NULL default '0',
  `Paycheck` int(11) NOT NULL default '0',
  `HeadValue` int(11) NOT NULL default '0',
  `Jailed` int(11) NOT NULL default '0',
  `JailTime` int(11) NOT NULL default '0',
  `Materials` int(11) NOT NULL default '0',
  `Drugs` int(11) NOT NULL default '0',
  `Leader` int(11) NOT NULL default '0',
  `Member` int(11) NOT NULL default '0',
  `FMember` int(11) NOT NULL default '255',
  `Rank` int(11) NOT NULL default '0',
  `Chara` int(11) NOT NULL default '0',
  `ContractTime` int(11) NOT NULL default '0',
  `DetSkill` int(11) NOT NULL default '0',
  `SexSkill` int(11) NOT NULL default '0',
  `BoxSkill` int(11) NOT NULL default '0',
  `LawSkill` int(11) NOT NULL default '0',
  `MechSkill` int(11) NOT NULL default '0',
  `JackSkill` int(11) NOT NULL default '0',
  `CarSkill` int(11) NOT NULL default '0',
  `NewsSkill` int(11) NOT NULL default '0',
  `DrugsSkill` int(11) NOT NULL default '0',
  `CookSkill` int(11) NOT NULL default '0',
  `FishSkill` int(11) NOT NULL default '0',
  `pSHealth` varchar(16) collate latin1_general_ci NOT NULL default '50.0',
  `pHealth` varchar(16) collate latin1_general_ci NOT NULL default '50.0',
  `Inte` int(11) NOT NULL default '0',
  `Local` int(11) NOT NULL default '255',
  `Team` int(11) NOT NULL default '3',
  `Model` int(11) NOT NULL default '250',
  `PhoneNr` int(11) NOT NULL default '0',
  `House` int(11) NOT NULL default '255',
  `Bizz` int(11) NOT NULL default '255',
  `Pos_x` varchar(16) collate latin1_general_ci NOT NULL default '0.0',
  `Pos_y` varchar(16) collate latin1_general_ci NOT NULL default '0.0',
  `Pos_z` varchar(16) collate latin1_general_ci NOT NULL default '0.0',
  `CarLic` int(11) NOT NULL default '0',
  `FlyLic` int(11) NOT NULL default '0',
  `BoatLic` int(11) NOT NULL default '0',
  `FishLic` int(11) NOT NULL default '0',
  `GunLic` int(11) NOT NULL default '0',
  `Gun1` int(11) NOT NULL default '0',
  `Gun2` int(11) NOT NULL default '0',
  `Gun3` int(11) NOT NULL default '0',
  `Gun4` int(11) NOT NULL default '0',
  `Ammo1` int(11) NOT NULL default '0',
  `Ammo2` int(11) NOT NULL default '0',
  `Ammo3` int(11) NOT NULL default '0',
  `Ammo4` int(11) NOT NULL default '0',
  `CarTime` int(11) NOT NULL default '0',
  `PayDay` int(11) NOT NULL default '0',
  `PayDayHad` int(11) NOT NULL default '0',
  `CDPlayer` int(11) NOT NULL default '0',
  `Wins` int(11) NOT NULL default '0',
  `Loses` int(11) NOT NULL default '0',
  `AlcoholPerk` int(11) NOT NULL default '0',
  `DrugPerk` int(11) NOT NULL default '0',
  `MiserPerk` int(11) NOT NULL default '0',
  `PainPerk` int(11) NOT NULL default '0',
  `TraderPerk` int(11) NOT NULL default '0',
  `Tutorial` int(11) NOT NULL default '0',
  `Mission` int(11) NOT NULL default '0',
  `Warnings` int(11) NOT NULL default '0',
  `Adjustable` int(11) NOT NULL default '0',
  `Fuel` int(11) NOT NULL default '0',
  `Married` int(11) NOT NULL default '0',
  `MarriedTo` varchar(50) collate latin1_general_ci NOT NULL default 'No-one',
  `WalkieFreQ` int(11) NOT NULL default '0',
  `Walkie` int(11) NOT NULL default '0',
  `Banned` int(11) NOT NULL default '0',
  `OldHealth` varchar(16) collate latin1_general_ci NOT NULL default '0',
  `OldArmour` varchar(16) collate latin1_general_ci NOT NULL default '0',
  `VirtualWorld` int(11) NOT NULL default '0',
  `Spawn` int(11) NOT NULL default '0',
  `Lighter` int(11) NOT NULL default '0',
  `Cigarettes` int(11) NOT NULL default '0',
  `Gate` int(11) NOT NULL default '0',
  `Pray` int(11) NOT NULL default '0',
  `Idcard` int(11) NOT NULL default '0',
  `Idcardvalid` int(11) NOT NULL default '0',
  `DonateTime` int(11) NOT NULL default '0',
  `CarKey2` int(11) NOT NULL default '0',
  `CarKey3` int(11) NOT NULL default '0',
  `LawyerTime` int(11) NOT NULL default '0',
  `Point` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
SET character_set_client = @saved_cs_client;