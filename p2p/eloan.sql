/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50626
Source Host           : localhost:3306
Source Database       : eloan

Target Server Type    : MYSQL
Target Server Version : 50626
File Encoding         : 65001

Date: 2015-12-26 14:13:22
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `account`
-- ----------------------------
DROP TABLE IF EXISTS `account`;
CREATE TABLE `account` (
  `id` bigint(20) NOT NULL,
  `tradePassword` varchar(255) DEFAULT NULL,
  `usableAmount` decimal(18,4) NOT NULL,
  `freezedAmount` decimal(18,4) NOT NULL,
  `borrowLimitAmount` decimal(18,4) NOT NULL,
  `version` int(11) NOT NULL,
  `unReceiveInterest` decimal(18,4) NOT NULL,
  `unReceivePrincipal` decimal(18,4) NOT NULL,
  `unReturnAmount` decimal(18,4) NOT NULL,
  `remainBorrowLimit` decimal(18,4) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of account
-- ----------------------------
INSERT INTO `account` VALUES ('4', null, '1140.0000', '0.0000', '2000.0000', '1', '0.0000', '0.0000', '1253.0434', '800.0000');
INSERT INTO `account` VALUES ('6', null, '0.0000', '0.0000', '2000.0000', '0', '0.0000', '0.0000', '0.0000', '2000.0000');
INSERT INTO `account` VALUES ('7', null, '9500.0000', '0.0000', '2000.0000', '3', '22.1014', '500.0000', '0.0000', '2000.0000');
INSERT INTO `account` VALUES ('10', null, '9300.0000', '0.0000', '2000.0000', '4', '30.9420', '700.0000', '0.0000', '2000.0000');

-- ----------------------------
-- Table structure for `accountflow`
-- ----------------------------
DROP TABLE IF EXISTS `accountflow`;
CREATE TABLE `accountflow` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `accountActionType` tinyint(4) NOT NULL,
  `amount` decimal(18,4) NOT NULL,
  `note` varchar(255) NOT NULL,
  `balance` decimal(18,4) NOT NULL,
  `freezed` decimal(18,4) NOT NULL,
  `actionTime` datetime NOT NULL,
  `account_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of accountflow
-- ----------------------------
INSERT INTO `accountflow` VALUES ('1', '0', '10000.0000', '线下充值成功!', '10000.0000', '0.0000', '2015-12-23 11:35:59', '7');
INSERT INTO `accountflow` VALUES ('2', '10', '500.0000', '投标:我穷啊,冻结金额!', '9500.0000', '500.0000', '2015-12-23 16:17:59', '7');
INSERT INTO `accountflow` VALUES ('3', '0', '10000.0000', '线下充值成功!', '10000.0000', '0.0000', '2015-12-23 16:21:27', '10');
INSERT INTO `accountflow` VALUES ('4', '10', '500.0000', '投标:我穷啊,冻结金额!', '9500.0000', '500.0000', '2015-12-23 16:21:39', '10');
INSERT INTO `accountflow` VALUES ('5', '10', '200.0000', '投标:我穷啊,冻结金额!', '9300.0000', '700.0000', '2015-12-23 16:22:01', '10');
INSERT INTO `accountflow` VALUES ('6', '2', '1200.0000', '成功借款,借款金额到账!', '1200.0000', '0.0000', '2015-12-24 15:59:07', '4');
INSERT INTO `accountflow` VALUES ('7', '6', '60.0000', '支付借款手续费!', '1140.0000', '0.0000', '2015-12-24 15:59:07', '4');
INSERT INTO `accountflow` VALUES ('8', '3', '500.0000', '借款成功取消冻结金额!', '9500.0000', '0.0000', '2015-12-24 15:59:07', '7');
INSERT INTO `accountflow` VALUES ('9', '3', '500.0000', '借款成功取消冻结金额!', '9300.0000', '200.0000', '2015-12-24 15:59:07', '10');
INSERT INTO `accountflow` VALUES ('10', '3', '200.0000', '借款成功取消冻结金额!', '9300.0000', '0.0000', '2015-12-24 15:59:07', '10');

-- ----------------------------
-- Table structure for `bid`
-- ----------------------------
DROP TABLE IF EXISTS `bid`;
CREATE TABLE `bid` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `actualRate` decimal(8,4) NOT NULL,
  `availableAmount` decimal(18,4) NOT NULL,
  `bidrequest_id` bigint(20) NOT NULL,
  `bidUser_id` bigint(20) NOT NULL,
  `bidTime` datetime NOT NULL,
  `bidRequestTitle` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bid
-- ----------------------------
INSERT INTO `bid` VALUES ('1', '15.0000', '500.0000', '2', '7', '2015-12-23 16:17:59', '我穷啊');
INSERT INTO `bid` VALUES ('2', '15.0000', '500.0000', '2', '10', '2015-12-23 16:21:39', '我穷啊');
INSERT INTO `bid` VALUES ('3', '15.0000', '200.0000', '2', '10', '2015-12-23 16:22:01', '我穷啊');

-- ----------------------------
-- Table structure for `bidrequest`
-- ----------------------------
DROP TABLE IF EXISTS `bidrequest`;
CREATE TABLE `bidrequest` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` int(11) NOT NULL,
  `bidRequestType` tinyint(4) NOT NULL,
  `bidRequestState` tinyint(4) NOT NULL,
  `bidRequestAmount` decimal(18,4) NOT NULL,
  `currentRate` decimal(8,4) NOT NULL,
  `monthes2Return` tinyint(4) NOT NULL,
  `bidCount` int(11) NOT NULL,
  `totalRewardAmount` decimal(18,4) NOT NULL,
  `currentSum` decimal(18,4) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `note` varchar(255) NOT NULL,
  `disableDate` datetime DEFAULT NULL,
  `createuser_id` bigint(20) NOT NULL,
  `disableDays` tinyint(4) NOT NULL,
  `minBidAmount` decimal(18,4) NOT NULL,
  `applyTime` datetime DEFAULT NULL,
  `publishTime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bidrequest
-- ----------------------------
INSERT INTO `bidrequest` VALUES ('1', '1', '0', '10', '1200.0000', '15.0000', '6', '0', '53.0434', '0.0000', '我靠我穷啊', '我靠我穷啊', '', '2015-12-17 14:52:46', '4', '3', '50.0000', '2015-12-17 14:52:46', null);
INSERT INTO `bidrequest` VALUES ('2', '6', '0', '7', '1200.0000', '15.0000', '6', '3', '53.0434', '1200.0000', '我穷啊', '我穷啊我穷啊', '风控信息无误', '2015-12-24 15:49:39', '4', '3', '50.0000', '2015-12-17 15:49:24', '2015-12-21 15:49:39');

-- ----------------------------
-- Table structure for `bidrequestaudithistory`
-- ----------------------------
DROP TABLE IF EXISTS `bidrequestaudithistory`;
CREATE TABLE `bidrequestaudithistory` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `state` tinyint(4) NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `auditTime` datetime DEFAULT NULL,
  `applyTime` datetime NOT NULL,
  `auditor_id` bigint(20) DEFAULT NULL,
  `applier_id` bigint(20) NOT NULL,
  `bidRequestId` bigint(20) NOT NULL,
  `auditType` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bidrequestaudithistory
-- ----------------------------
INSERT INTO `bidrequestaudithistory` VALUES ('1', '2', '风控信息有问题', '2015-12-17 15:47:52', '2015-12-17 14:52:46', '5', '4', '1', '0');
INSERT INTO `bidrequestaudithistory` VALUES ('2', '1', '风控信息无误', '2015-12-17 15:49:39', '2015-12-17 15:49:24', '5', '4', '2', '0');
INSERT INTO `bidrequestaudithistory` VALUES ('3', '1', '11111', '2015-12-24 10:03:31', '2015-12-17 15:49:24', '5', '4', '2', '1');
INSERT INTO `bidrequestaudithistory` VALUES ('4', '1', '111111', '2015-12-24 10:06:18', '2015-12-17 15:49:24', '5', '4', '2', '1');
INSERT INTO `bidrequestaudithistory` VALUES ('5', '1', '通过', '2015-12-24 15:59:07', '2015-12-17 15:49:24', '5', '4', '2', '2');

-- ----------------------------
-- Table structure for `companybankinfo`
-- ----------------------------
DROP TABLE IF EXISTS `companybankinfo`;
CREATE TABLE `companybankinfo` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `bankname` varchar(255) DEFAULT NULL,
  `accountname` varchar(255) DEFAULT NULL,
  `banknumber` varchar(255) DEFAULT NULL,
  `bankforkname` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of companybankinfo
-- ----------------------------
INSERT INTO `companybankinfo` VALUES ('1', '1', '吴嘉俊', '6212263602026760983', '学院支行');
INSERT INTO `companybankinfo` VALUES ('2', '3', '吴嘉俊', '1111111111111111', '学院支行');
INSERT INTO `companybankinfo` VALUES ('3', '6', '吴嘉俊', '555555555555555555555', '学院支行');
INSERT INTO `companybankinfo` VALUES ('4', '3', '吴嘉俊', '1111111111111111', '学院支行');

-- ----------------------------
-- Table structure for `emailactive`
-- ----------------------------
DROP TABLE IF EXISTS `emailactive`;
CREATE TABLE `emailactive` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `logininfo_id` bigint(20) NOT NULL,
  `email` varchar(255) NOT NULL,
  `sendDate` datetime NOT NULL,
  `uuidcode` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of emailactive
-- ----------------------------
INSERT INTO `emailactive` VALUES ('1', '4', 'stef@xmg.com', '2015-12-12 17:14:06', 'a1392275-a29c-4624-95b0-02233ec30ff9');
INSERT INTO `emailactive` VALUES ('2', '4', 'stef@xmg.com', '2015-12-12 17:15:23', '93083221-51ac-44ba-8536-65d8427a81a9');

-- ----------------------------
-- Table structure for `iplog`
-- ----------------------------
DROP TABLE IF EXISTS `iplog`;
CREATE TABLE `iplog` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ip` varchar(50) NOT NULL,
  `loginState` tinyint(4) NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `loginInfoId` bigint(20) DEFAULT NULL,
  `loginType` tinyint(4) NOT NULL,
  `loginTime` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=156 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of iplog
-- ----------------------------
INSERT INTO `iplog` VALUES ('1', '0:0:0:0:0:0:0:1', '0', 'stef', null, '0', '2015-12-11 15:30:12');
INSERT INTO `iplog` VALUES ('2', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-11 15:30:34');
INSERT INTO `iplog` VALUES ('3', '192.168.101.237', '0', 'stef', null, '0', '2015-12-11 15:35:29');
INSERT INTO `iplog` VALUES ('4', '192.168.101.237', '0', 'stef', null, '0', '2015-12-11 15:35:36');
INSERT INTO `iplog` VALUES ('5', '192.168.101.237', '1', 'stef', '4', '0', '2015-12-11 15:35:55');
INSERT INTO `iplog` VALUES ('6', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-11 15:52:12');
INSERT INTO `iplog` VALUES ('7', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-11 16:12:26');
INSERT INTO `iplog` VALUES ('8', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-11 16:16:44');
INSERT INTO `iplog` VALUES ('9', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-11 16:19:33');
INSERT INTO `iplog` VALUES ('10', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-11 17:10:35');
INSERT INTO `iplog` VALUES ('11', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-11 17:11:11');
INSERT INTO `iplog` VALUES ('12', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-11 17:21:12');
INSERT INTO `iplog` VALUES ('13', '0:0:0:0:0:0:0:1', '0', 'admin', null, '1', '2015-12-11 17:31:51');
INSERT INTO `iplog` VALUES ('14', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-11 17:31:54');
INSERT INTO `iplog` VALUES ('15', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-11 21:41:10');
INSERT INTO `iplog` VALUES ('16', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-11 22:25:31');
INSERT INTO `iplog` VALUES ('17', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-12 00:06:15');
INSERT INTO `iplog` VALUES ('18', '127.0.0.1', '1', 'stef', '4', '0', '2015-12-12 00:06:41');
INSERT INTO `iplog` VALUES ('19', '127.0.0.1', '1', 'stef', '4', '0', '2015-12-12 00:07:19');
INSERT INTO `iplog` VALUES ('20', '127.0.0.1', '1', 'stef', '4', '0', '2015-12-12 00:07:55');
INSERT INTO `iplog` VALUES ('21', '127.0.0.1', '1', 'stef', '4', '0', '2015-12-12 00:08:41');
INSERT INTO `iplog` VALUES ('22', '127.0.0.1', '1', 'stef', '4', '0', '2015-12-12 00:09:31');
INSERT INTO `iplog` VALUES ('23', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-12 00:10:24');
INSERT INTO `iplog` VALUES ('24', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-12 00:27:10');
INSERT INTO `iplog` VALUES ('25', '0:0:0:0:0:0:0:1', '0', 'admin', null, '1', '2015-12-12 00:28:01');
INSERT INTO `iplog` VALUES ('26', '0:0:0:0:0:0:0:1', '0', 'admin', null, '1', '2015-12-12 00:28:05');
INSERT INTO `iplog` VALUES ('27', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-12 00:28:28');
INSERT INTO `iplog` VALUES ('28', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-12 00:58:26');
INSERT INTO `iplog` VALUES ('29', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-12 09:42:40');
INSERT INTO `iplog` VALUES ('30', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-12 10:06:31');
INSERT INTO `iplog` VALUES ('31', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-12 10:27:44');
INSERT INTO `iplog` VALUES ('32', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-12 11:32:17');
INSERT INTO `iplog` VALUES ('33', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-12 11:44:50');
INSERT INTO `iplog` VALUES ('34', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-12 11:50:13');
INSERT INTO `iplog` VALUES ('35', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-12 12:04:17');
INSERT INTO `iplog` VALUES ('36', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-12 14:33:56');
INSERT INTO `iplog` VALUES ('37', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-12 14:49:33');
INSERT INTO `iplog` VALUES ('38', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-12 15:41:37');
INSERT INTO `iplog` VALUES ('39', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-12 17:12:22');
INSERT INTO `iplog` VALUES ('40', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-12 17:15:17');
INSERT INTO `iplog` VALUES ('41', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-12 17:28:57');
INSERT INTO `iplog` VALUES ('42', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-13 00:48:59');
INSERT INTO `iplog` VALUES ('43', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-13 19:26:18');
INSERT INTO `iplog` VALUES ('44', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-13 19:29:07');
INSERT INTO `iplog` VALUES ('45', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-13 19:31:44');
INSERT INTO `iplog` VALUES ('46', '0:0:0:0:0:0:0:1', '1', 'admin', '6', '0', '2015-12-13 19:49:49');
INSERT INTO `iplog` VALUES ('47', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-14 16:22:22');
INSERT INTO `iplog` VALUES ('48', '0:0:0:0:0:0:0:1', '0', 'admin', null, '1', '2015-12-14 16:47:25');
INSERT INTO `iplog` VALUES ('49', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-14 16:47:28');
INSERT INTO `iplog` VALUES ('50', '0:0:0:0:0:0:0:1', '0', 'admin', null, '1', '2015-12-14 17:17:45');
INSERT INTO `iplog` VALUES ('51', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-14 17:17:48');
INSERT INTO `iplog` VALUES ('52', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-14 17:20:32');
INSERT INTO `iplog` VALUES ('53', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-14 17:57:08');
INSERT INTO `iplog` VALUES ('54', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-14 18:08:30');
INSERT INTO `iplog` VALUES ('55', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-14 18:10:10');
INSERT INTO `iplog` VALUES ('56', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-14 18:20:43');
INSERT INTO `iplog` VALUES ('57', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-14 18:29:47');
INSERT INTO `iplog` VALUES ('58', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-14 20:30:18');
INSERT INTO `iplog` VALUES ('59', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-15 00:07:51');
INSERT INTO `iplog` VALUES ('60', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-15 09:59:39');
INSERT INTO `iplog` VALUES ('61', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-15 10:33:24');
INSERT INTO `iplog` VALUES ('62', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-15 10:48:11');
INSERT INTO `iplog` VALUES ('63', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-15 11:11:00');
INSERT INTO `iplog` VALUES ('64', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-15 11:11:45');
INSERT INTO `iplog` VALUES ('65', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-15 11:29:05');
INSERT INTO `iplog` VALUES ('66', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-15 11:41:23');
INSERT INTO `iplog` VALUES ('67', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-15 12:03:31');
INSERT INTO `iplog` VALUES ('68', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-15 12:05:50');
INSERT INTO `iplog` VALUES ('69', '127.0.0.1', '1', 'admin', '5', '1', '2015-12-15 14:30:18');
INSERT INTO `iplog` VALUES ('70', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-15 14:40:54');
INSERT INTO `iplog` VALUES ('71', '127.0.0.1', '1', 'admin', '5', '1', '2015-12-15 14:41:07');
INSERT INTO `iplog` VALUES ('72', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-15 14:42:38');
INSERT INTO `iplog` VALUES ('73', '127.0.0.1', '1', 'admin', '5', '1', '2015-12-15 14:42:48');
INSERT INTO `iplog` VALUES ('74', '127.0.0.1', '1', 'admin', '5', '1', '2015-12-15 14:44:39');
INSERT INTO `iplog` VALUES ('75', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-15 14:45:26');
INSERT INTO `iplog` VALUES ('76', '127.0.0.1', '1', 'admin', '5', '1', '2015-12-15 14:46:28');
INSERT INTO `iplog` VALUES ('77', '127.0.0.1', '1', 'admin', '5', '1', '2015-12-15 15:16:02');
INSERT INTO `iplog` VALUES ('78', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-15 15:27:56');
INSERT INTO `iplog` VALUES ('79', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-15 16:03:09');
INSERT INTO `iplog` VALUES ('80', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-15 16:08:52');
INSERT INTO `iplog` VALUES ('81', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-15 16:12:39');
INSERT INTO `iplog` VALUES ('82', '0:0:0:0:0:0:0:1', '1', 'stea', '7', '0', '2015-12-15 16:22:11');
INSERT INTO `iplog` VALUES ('83', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-15 16:26:30');
INSERT INTO `iplog` VALUES ('84', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-15 17:10:57');
INSERT INTO `iplog` VALUES ('85', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-15 17:22:46');
INSERT INTO `iplog` VALUES ('86', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-15 17:32:21');
INSERT INTO `iplog` VALUES ('87', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-15 17:33:53');
INSERT INTO `iplog` VALUES ('88', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-15 17:42:23');
INSERT INTO `iplog` VALUES ('89', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-17 09:23:00');
INSERT INTO `iplog` VALUES ('90', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-17 09:32:27');
INSERT INTO `iplog` VALUES ('91', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-17 09:34:16');
INSERT INTO `iplog` VALUES ('92', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-17 11:37:12');
INSERT INTO `iplog` VALUES ('93', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-17 14:52:20');
INSERT INTO `iplog` VALUES ('94', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-17 15:30:32');
INSERT INTO `iplog` VALUES ('95', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-17 15:47:41');
INSERT INTO `iplog` VALUES ('96', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-17 15:48:22');
INSERT INTO `iplog` VALUES ('97', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-17 20:01:49');
INSERT INTO `iplog` VALUES ('98', '0:0:0:0:0:0:0:1', '1', 'stea', '7', '0', '2015-12-17 20:55:13');
INSERT INTO `iplog` VALUES ('99', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-17 22:04:01');
INSERT INTO `iplog` VALUES ('100', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-17 22:44:39');
INSERT INTO `iplog` VALUES ('101', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-17 22:45:13');
INSERT INTO `iplog` VALUES ('102', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-18 09:37:40');
INSERT INTO `iplog` VALUES ('103', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-18 09:39:34');
INSERT INTO `iplog` VALUES ('104', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-18 09:41:53');
INSERT INTO `iplog` VALUES ('105', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-18 09:45:00');
INSERT INTO `iplog` VALUES ('106', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-18 09:46:45');
INSERT INTO `iplog` VALUES ('107', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-18 11:44:19');
INSERT INTO `iplog` VALUES ('108', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-18 11:45:11');
INSERT INTO `iplog` VALUES ('109', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-18 14:43:59');
INSERT INTO `iplog` VALUES ('110', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-18 15:14:19');
INSERT INTO `iplog` VALUES ('111', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-18 16:33:32');
INSERT INTO `iplog` VALUES ('112', '0:0:0:0:0:0:0:1', '0', 'sta', null, '0', '2015-12-18 16:35:42');
INSERT INTO `iplog` VALUES ('113', '0:0:0:0:0:0:0:1', '1', 'stea', '7', '0', '2015-12-18 16:35:47');
INSERT INTO `iplog` VALUES ('114', '0:0:0:0:0:0:0:1', '1', 'stea', '7', '0', '2015-12-18 16:36:42');
INSERT INTO `iplog` VALUES ('115', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-18 17:09:46');
INSERT INTO `iplog` VALUES ('116', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-18 17:13:29');
INSERT INTO `iplog` VALUES ('117', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-18 17:16:08');
INSERT INTO `iplog` VALUES ('118', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-19 12:08:57');
INSERT INTO `iplog` VALUES ('119', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-19 15:34:05');
INSERT INTO `iplog` VALUES ('120', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-19 15:38:20');
INSERT INTO `iplog` VALUES ('121', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-19 17:19:40');
INSERT INTO `iplog` VALUES ('122', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-19 17:56:38');
INSERT INTO `iplog` VALUES ('123', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-19 18:15:18');
INSERT INTO `iplog` VALUES ('124', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-19 21:13:01');
INSERT INTO `iplog` VALUES ('125', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-19 23:08:42');
INSERT INTO `iplog` VALUES ('126', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-21 10:16:43');
INSERT INTO `iplog` VALUES ('127', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-23 10:07:24');
INSERT INTO `iplog` VALUES ('128', '0:0:0:0:0:0:0:1', '1', 'stea', '7', '0', '2015-12-23 10:07:31');
INSERT INTO `iplog` VALUES ('129', '0:0:0:0:0:0:0:1', '1', 'stea', '7', '0', '2015-12-23 10:09:16');
INSERT INTO `iplog` VALUES ('130', '127.0.0.1', '1', 'stea', '7', '0', '2015-12-23 10:15:04');
INSERT INTO `iplog` VALUES ('131', '0:0:0:0:0:0:0:1', '1', 'stea', '7', '0', '2015-12-23 10:44:25');
INSERT INTO `iplog` VALUES ('132', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-23 10:58:06');
INSERT INTO `iplog` VALUES ('133', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-23 10:59:53');
INSERT INTO `iplog` VALUES ('134', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-23 11:34:17');
INSERT INTO `iplog` VALUES ('135', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-23 11:35:05');
INSERT INTO `iplog` VALUES ('136', '0:0:0:0:0:0:0:1', '1', 'stea', '7', '0', '2015-12-23 11:35:08');
INSERT INTO `iplog` VALUES ('137', '0:0:0:0:0:0:0:1', '1', 'stea', '7', '0', '2015-12-23 15:26:33');
INSERT INTO `iplog` VALUES ('138', '0:0:0:0:0:0:0:1', '1', 'stea', '7', '0', '2015-12-23 16:17:49');
INSERT INTO `iplog` VALUES ('139', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-23 16:20:33');
INSERT INTO `iplog` VALUES ('140', '0:0:0:0:0:0:0:1', '1', 'stee', '10', '0', '2015-12-23 16:20:36');
INSERT INTO `iplog` VALUES ('141', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-23 16:21:18');
INSERT INTO `iplog` VALUES ('142', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-23 16:35:28');
INSERT INTO `iplog` VALUES ('143', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-23 16:47:57');
INSERT INTO `iplog` VALUES ('144', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-23 17:01:50');
INSERT INTO `iplog` VALUES ('145', '0:0:0:0:0:0:0:1', '1', 'stee', '10', '0', '2015-12-23 17:03:30');
INSERT INTO `iplog` VALUES ('146', '0:0:0:0:0:0:0:1', '1', 'stee', '10', '0', '2015-12-23 17:05:10');
INSERT INTO `iplog` VALUES ('147', '0:0:0:0:0:0:0:1', '1', 'stee', '10', '0', '2015-12-23 17:09:05');
INSERT INTO `iplog` VALUES ('148', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-24 09:07:42');
INSERT INTO `iplog` VALUES ('149', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-24 10:03:21');
INSERT INTO `iplog` VALUES ('150', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-24 10:06:12');
INSERT INTO `iplog` VALUES ('151', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-24 10:30:35');
INSERT INTO `iplog` VALUES ('152', '0:0:0:0:0:0:0:1', '1', 'admin', '5', '1', '2015-12-24 15:58:57');
INSERT INTO `iplog` VALUES ('153', '0:0:0:0:0:0:0:1', '1', 'stef', '4', '0', '2015-12-24 16:00:12');
INSERT INTO `iplog` VALUES ('154', '0:0:0:0:0:0:0:1', '1', 'stee', '10', '0', '2015-12-24 16:01:33');
INSERT INTO `iplog` VALUES ('155', '0:0:0:0:0:0:0:1', '1', 'stea', '7', '0', '2015-12-24 16:01:47');

-- ----------------------------
-- Table structure for `logininfo`
-- ----------------------------
DROP TABLE IF EXISTS `logininfo`;
CREATE TABLE `logininfo` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) DEFAULT NULL,
  `password` varchar(200) DEFAULT NULL,
  `state` tinyint(4) DEFAULT NULL,
  `usertype` tinyint(4) DEFAULT NULL,
  `admin` bit(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of logininfo
-- ----------------------------
INSERT INTO `logininfo` VALUES ('4', 'stef', 'B59C67BF196A4758191E42F76670CEBA', '0', '0', '');
INSERT INTO `logininfo` VALUES ('5', 'admin', 'B59C67BF196A4758191E42F76670CEBA', '0', '1', '');
INSERT INTO `logininfo` VALUES ('6', 'admin', '81DC9BDB52D04DC20036DBD8313ED055', '0', '0', '');
INSERT INTO `logininfo` VALUES ('7', 'stea', 'B59C67BF196A4758191E42F76670CEBA', '0', '0', '');
INSERT INTO `logininfo` VALUES ('10', 'stee', 'B59C67BF196A4758191E42F76670CEBA', '0', '0', '');

-- ----------------------------
-- Table structure for `paymentschedule`
-- ----------------------------
DROP TABLE IF EXISTS `paymentschedule`;
CREATE TABLE `paymentschedule` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `deadLine` datetime NOT NULL,
  `payDate` datetime DEFAULT NULL,
  `totalAmount` decimal(18,4) NOT NULL,
  `principal` decimal(18,4) NOT NULL,
  `interest` decimal(18,4) NOT NULL,
  `monthIndex` tinyint(4) NOT NULL,
  `state` tinyint(4) NOT NULL,
  `bidRequestType` tinyint(4) NOT NULL,
  `returnType` tinyint(4) NOT NULL,
  `bidrequest_id` bigint(20) NOT NULL,
  `biduser_id` bigint(20) NOT NULL,
  `bidRequestTitle` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of paymentschedule
-- ----------------------------
INSERT INTO `paymentschedule` VALUES ('1', '2016-01-24 15:59:07', null, '208.8406', '193.8406', '15.0000', '1', '0', '0', '0', '2', '4', '我穷啊');
INSERT INTO `paymentschedule` VALUES ('2', '2016-02-24 15:59:07', null, '208.8406', '196.2636', '12.5770', '2', '0', '0', '0', '2', '4', '我穷啊');
INSERT INTO `paymentschedule` VALUES ('3', '2016-03-24 15:59:07', null, '208.8406', '198.7169', '10.1237', '3', '0', '0', '0', '2', '4', '我穷啊');
INSERT INTO `paymentschedule` VALUES ('4', '2016-04-24 15:59:07', null, '208.8406', '201.2009', '7.6397', '4', '0', '0', '0', '2', '4', '我穷啊');
INSERT INTO `paymentschedule` VALUES ('5', '2016-05-24 15:59:07', null, '208.8406', '203.7159', '5.1247', '5', '0', '0', '0', '2', '4', '我穷啊');
INSERT INTO `paymentschedule` VALUES ('6', '2016-06-24 15:59:07', null, '208.8406', '206.2623', '2.5783', '6', '0', '0', '0', '2', '4', '我穷啊');

-- ----------------------------
-- Table structure for `paymentscheduledetail`
-- ----------------------------
DROP TABLE IF EXISTS `paymentscheduledetail`;
CREATE TABLE `paymentscheduledetail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `bidamount` decimal(18,4) NOT NULL,
  `bid_id` bigint(20) NOT NULL,
  `totalamount` decimal(18,4) NOT NULL,
  `principal` decimal(18,4) NOT NULL,
  `interest` decimal(18,4) NOT NULL,
  `monthindex` tinyint(4) NOT NULL,
  `deadline` datetime NOT NULL,
  `bidrequest_id` bigint(20) NOT NULL,
  `paydate` datetime DEFAULT NULL,
  `returntype` tinyint(4) NOT NULL,
  `paymentschedule_id` bigint(20) NOT NULL,
  `fromlogininfo_id` bigint(20) DEFAULT NULL,
  `tologininfo_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of paymentscheduledetail
-- ----------------------------
INSERT INTO `paymentscheduledetail` VALUES ('1', '500.0000', '1', '87.0169', '80.7669', '6.2500', '1', '2016-01-24 15:59:07', '2', null, '0', '1', '4', '7');
INSERT INTO `paymentscheduledetail` VALUES ('2', '500.0000', '2', '87.0169', '80.7669', '6.2500', '1', '2016-01-24 15:59:07', '2', null, '0', '1', '4', '10');
INSERT INTO `paymentscheduledetail` VALUES ('3', '200.0000', '3', '34.8068', '32.3068', '2.5000', '1', '2016-01-24 15:59:07', '2', null, '0', '1', '4', '10');
INSERT INTO `paymentscheduledetail` VALUES ('4', '500.0000', '1', '87.0169', '81.7765', '5.2404', '2', '2016-02-24 15:59:07', '2', null, '0', '2', '4', '7');
INSERT INTO `paymentscheduledetail` VALUES ('5', '500.0000', '2', '87.0169', '81.7765', '5.2404', '2', '2016-02-24 15:59:07', '2', null, '0', '2', '4', '10');
INSERT INTO `paymentscheduledetail` VALUES ('6', '200.0000', '3', '34.8068', '32.7106', '2.0962', '2', '2016-02-24 15:59:07', '2', null, '0', '2', '4', '10');
INSERT INTO `paymentscheduledetail` VALUES ('7', '500.0000', '1', '87.0169', '82.7987', '4.2182', '3', '2016-03-24 15:59:07', '2', null, '0', '3', '4', '7');
INSERT INTO `paymentscheduledetail` VALUES ('8', '500.0000', '2', '87.0169', '82.7987', '4.2182', '3', '2016-03-24 15:59:07', '2', null, '0', '3', '4', '10');
INSERT INTO `paymentscheduledetail` VALUES ('9', '200.0000', '3', '34.8068', '33.1195', '1.6873', '3', '2016-03-24 15:59:07', '2', null, '0', '3', '4', '10');
INSERT INTO `paymentscheduledetail` VALUES ('10', '500.0000', '1', '87.0169', '83.8337', '3.1832', '4', '2016-04-24 15:59:07', '2', null, '0', '4', '4', '7');
INSERT INTO `paymentscheduledetail` VALUES ('11', '500.0000', '2', '87.0169', '83.8337', '3.1832', '4', '2016-04-24 15:59:07', '2', null, '0', '4', '4', '10');
INSERT INTO `paymentscheduledetail` VALUES ('12', '200.0000', '3', '34.8068', '33.5335', '1.2733', '4', '2016-04-24 15:59:07', '2', null, '0', '4', '4', '10');
INSERT INTO `paymentscheduledetail` VALUES ('13', '500.0000', '1', '87.0169', '84.8816', '2.1353', '5', '2016-05-24 15:59:07', '2', null, '0', '5', '4', '7');
INSERT INTO `paymentscheduledetail` VALUES ('14', '500.0000', '2', '87.0169', '84.8816', '2.1353', '5', '2016-05-24 15:59:07', '2', null, '0', '5', '4', '10');
INSERT INTO `paymentscheduledetail` VALUES ('15', '200.0000', '3', '34.8068', '33.9526', '0.8541', '5', '2016-05-24 15:59:07', '2', null, '0', '5', '4', '10');
INSERT INTO `paymentscheduledetail` VALUES ('16', '500.0000', '1', '87.0169', '85.9426', '1.0743', '6', '2016-06-24 15:59:07', '2', null, '0', '6', '4', '7');
INSERT INTO `paymentscheduledetail` VALUES ('17', '500.0000', '2', '87.0169', '85.9426', '1.0743', '6', '2016-06-24 15:59:07', '2', null, '0', '6', '4', '10');
INSERT INTO `paymentscheduledetail` VALUES ('18', '200.0000', '3', '34.8068', '34.3771', '0.4297', '6', '2016-06-24 15:59:07', '2', null, '0', '6', '4', '10');

-- ----------------------------
-- Table structure for `realauth`
-- ----------------------------
DROP TABLE IF EXISTS `realauth`;
CREATE TABLE `realauth` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `realname` varchar(50) NOT NULL,
  `sex` tinyint(4) NOT NULL,
  `birthDate` varchar(50) DEFAULT NULL,
  `idNumber` varchar(50) NOT NULL,
  `address` varchar(255) NOT NULL,
  `state` tinyint(4) NOT NULL,
  `image1` varchar(255) NOT NULL,
  `image2` varchar(255) NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `auditTime` datetime DEFAULT NULL,
  `applyTime` datetime NOT NULL,
  `auditor_id` bigint(20) DEFAULT NULL,
  `applier_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of realauth
-- ----------------------------
INSERT INTO `realauth` VALUES ('1', '哈哈', '0', '2015-05-05', '510108111111111111', '四川成都', '2', '/upload/7266fe0a-70e9-49fe-8c22-238952e2e45d.jpg', '/upload/68c6990a-6839-4c76-a6ff-1077487bff67.jpg', null, '2015-12-15 14:46:36', '2015-12-15 11:42:33', '5', '4');
INSERT INTO `realauth` VALUES ('2', '哈哈', '0', '2015-05-05', '510108111111111111', '四川成都', '1', '/upload/848a9f69-1228-44d6-904b-9e2641431fa7.jpg', '/upload/f35f0ab7-4f72-40aa-96ff-017a49a43242.jpg', null, '2015-12-15 14:47:24', '2015-12-15 14:47:14', '5', '4');
INSERT INTO `realauth` VALUES ('3', '哈哈', '0', '2015-05-05', '510108111111111112', '四川成都', '1', '/upload/d49a0317-9abb-4f90-b82a-0284459ba7ad.jpg', '/upload/9cb61e08-948f-4be2-b1af-9a7347712352.jpg', null, '2015-12-15 16:26:38', '2015-12-15 16:26:06', '5', '7');

-- ----------------------------
-- Table structure for `rechargeoffline`
-- ----------------------------
DROP TABLE IF EXISTS `rechargeoffline`;
CREATE TABLE `rechargeoffline` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `state` tinyint(4) NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `auditTime` datetime DEFAULT NULL,
  `applyTime` datetime NOT NULL,
  `auditor_id` bigint(20) DEFAULT NULL,
  `applier_id` bigint(20) NOT NULL,
  `tradeCode` varchar(255) NOT NULL,
  `tradeTime` datetime NOT NULL,
  `amount` decimal(18,4) NOT NULL,
  `note` varchar(255) DEFAULT NULL,
  `bankinfo_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of rechargeoffline
-- ----------------------------
INSERT INTO `rechargeoffline` VALUES ('1', '2', '没有收到钱啊', '2015-12-23 11:34:31', '2015-12-23 10:15:11', '5', '7', '00001', '2015-12-23 00:00:00', '10000.0000', '我是土豪', '1');
INSERT INTO `rechargeoffline` VALUES ('2', '1', '土豪抱个大腿', '2015-12-23 11:35:59', '2015-12-23 11:35:45', '5', '7', '0002', '2015-12-23 00:00:00', '10000.0000', '我靠,我是土豪也', '2');
INSERT INTO `rechargeoffline` VALUES ('3', '1', '通过', '2015-12-23 16:21:27', '2015-12-23 16:20:56', '5', '10', '00001', '2015-12-23 00:00:00', '10000.0000', '线下充值', '3');

-- ----------------------------
-- Table structure for `systemaccount`
-- ----------------------------
DROP TABLE IF EXISTS `systemaccount`;
CREATE TABLE `systemaccount` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` int(11) NOT NULL,
  `beginDate` datetime DEFAULT NULL,
  `endDate` datetime DEFAULT NULL,
  `createdate` datetime NOT NULL,
  `totalbalance` decimal(18,4) NOT NULL,
  `freezedamount` decimal(18,4) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of systemaccount
-- ----------------------------
INSERT INTO `systemaccount` VALUES ('1', '1', '2015-12-24 15:58:47', null, '2015-12-24 15:58:47', '60.0000', '0.0000');

-- ----------------------------
-- Table structure for `systemaccountflow`
-- ----------------------------
DROP TABLE IF EXISTS `systemaccountflow`;
CREATE TABLE `systemaccountflow` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `createdDate` datetime NOT NULL,
  `accountactiontype` tinyint(4) NOT NULL,
  `amount` decimal(18,4) NOT NULL,
  `note` varchar(255) DEFAULT NULL,
  `balance` decimal(18,4) NOT NULL,
  `freezedAmount` decimal(18,4) NOT NULL,
  `systemAccount_id` bigint(20) NOT NULL,
  `targetuser_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of systemaccountflow
-- ----------------------------
INSERT INTO `systemaccountflow` VALUES ('1', '2015-12-24 15:59:07', '1', '60.0000', '收到借款人stef成功借款支付管理费!', '60.0000', '0.0000', '1', '4');

-- ----------------------------
-- Table structure for `systemdictionary`
-- ----------------------------
DROP TABLE IF EXISTS `systemdictionary`;
CREATE TABLE `systemdictionary` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sn` varchar(50) NOT NULL,
  `title` varchar(50) NOT NULL,
  `intro` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of systemdictionary
-- ----------------------------
INSERT INTO `systemdictionary` VALUES ('1', 'incomeGrade', '月收入', '个人基本信息-月收入');
INSERT INTO `systemdictionary` VALUES ('2', 'educationBackground', '学历', '学历');
INSERT INTO `systemdictionary` VALUES ('3', 'marriage', '婚姻', '婚姻');
INSERT INTO `systemdictionary` VALUES ('4', 'kidCount', '子女', '子女');
INSERT INTO `systemdictionary` VALUES ('5', 'houseCondition', '住房条件', '住房条件');
INSERT INTO `systemdictionary` VALUES ('6', 'userFileType', '风控资料类型', '');

-- ----------------------------
-- Table structure for `systemdictionaryitem`
-- ----------------------------
DROP TABLE IF EXISTS `systemdictionaryitem`;
CREATE TABLE `systemdictionaryitem` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `parentId` bigint(20) NOT NULL,
  `title` varchar(50) NOT NULL,
  `tvalue` varchar(50) DEFAULT NULL,
  `sequence` tinyint(4) NOT NULL,
  `intro` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of systemdictionaryitem
-- ----------------------------
INSERT INTO `systemdictionaryitem` VALUES ('1', '1', '3000以下', '', '1', '3000以下');
INSERT INTO `systemdictionaryitem` VALUES ('2', '1', '3000~5000', '', '2', '3000~5000');
INSERT INTO `systemdictionaryitem` VALUES ('3', '2', '大专以下', null, '1', '大专以下');
INSERT INTO `systemdictionaryitem` VALUES ('4', '2', '大专', null, '2', '大专');
INSERT INTO `systemdictionaryitem` VALUES ('5', '3', '已婚', null, '1', '已婚');
INSERT INTO `systemdictionaryitem` VALUES ('6', '3', '未婚', null, '2', '未婚');
INSERT INTO `systemdictionaryitem` VALUES ('7', '4', '有子女', null, '1', '有');
INSERT INTO `systemdictionaryitem` VALUES ('8', '4', '无子女', null, '2', '无');
INSERT INTO `systemdictionaryitem` VALUES ('9', '5', '有自有房', null, '1', '有');
INSERT INTO `systemdictionaryitem` VALUES ('10', '5', '无自有房', null, '2', '无');
INSERT INTO `systemdictionaryitem` VALUES ('11', '5', '租房', null, '3', '租房');
INSERT INTO `systemdictionaryitem` VALUES ('12', '6', '房产证正面', '', '1', '房产证正面');
INSERT INTO `systemdictionaryitem` VALUES ('13', '6', '房产证反面', '', '2', '');
INSERT INTO `systemdictionaryitem` VALUES ('14', '6', '户口本', '', '3', '');
INSERT INTO `systemdictionaryitem` VALUES ('15', '6', '结婚证', '', '4', '');
INSERT INTO `systemdictionaryitem` VALUES ('16', '6', '银行流水证明', '', '5', '');
INSERT INTO `systemdictionaryitem` VALUES ('17', '6', '学位证', '', '6', '');
INSERT INTO `systemdictionaryitem` VALUES ('18', '6', '毕业证', '', '7', '');
INSERT INTO `systemdictionaryitem` VALUES ('19', '6', '电话记录', '', '7', '');

-- ----------------------------
-- Table structure for `userfile`
-- ----------------------------
DROP TABLE IF EXISTS `userfile`;
CREATE TABLE `userfile` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `state` tinyint(4) NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `auditTime` datetime DEFAULT NULL,
  `applyTime` datetime NOT NULL,
  `auditor_id` bigint(20) DEFAULT NULL,
  `applier_id` bigint(20) NOT NULL,
  `score` tinyint(4) NOT NULL,
  `file` varchar(255) NOT NULL,
  `filetype_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of userfile
-- ----------------------------
INSERT INTO `userfile` VALUES ('1', '2', '文件错误', '2015-12-17 09:33:08', '2015-12-15 17:32:42', '5', '4', '0', '/upload/d903adea-036d-4e48-8ed9-3f77748ea3d4.jpg', '12');
INSERT INTO `userfile` VALUES ('2', '1', '通过', '2015-12-17 09:33:37', '2015-12-15 17:32:42', '5', '4', '3', '/upload/a67cb5e4-72ad-4723-afe6-0316d7574eaa.jpg', '13');
INSERT INTO `userfile` VALUES ('3', '1', '通过', '2015-12-17 09:33:45', '2015-12-15 17:32:42', '5', '4', '5', '/upload/20be119e-edd5-488d-9973-2c985445dd49.jpg', '14');
INSERT INTO `userfile` VALUES ('4', '1', '通过', '2015-12-17 09:33:48', '2015-12-15 17:32:42', '5', '4', '5', '/upload/8159cf26-a71d-4367-a750-c93cf6f5fe3d.jpg', '15');
INSERT INTO `userfile` VALUES ('5', '1', '通过', '2015-12-17 09:35:24', '2015-12-17 09:34:56', '5', '4', '5', '/upload/000c0ee6-2470-42ce-9a5a-55d33dd9fcd7.jpg', '17');
INSERT INTO `userfile` VALUES ('6', '1', '通过', '2015-12-17 09:35:30', '2015-12-17 09:34:56', '5', '4', '5', '/upload/c69ca7ac-bb0c-40ee-b382-7a8a7f5fe4b0.jpg', '19');
INSERT INTO `userfile` VALUES ('7', '1', '通过', '2015-12-17 09:35:38', '2015-12-17 09:34:56', '5', '4', '5', '/upload/331f0ae8-3462-4854-94b4-33140a8ded12.jpg', '18');
INSERT INTO `userfile` VALUES ('8', '1', '通过', '2015-12-17 09:35:55', '2015-12-17 09:34:56', '5', '4', '5', '/upload/eef70012-fb9d-4bbc-b002-6209b568bdc2.jpg', '15');
INSERT INTO `userfile` VALUES ('9', '0', null, null, '2015-12-17 20:55:25', null, '7', '0', '/upload/469f5670-8edf-4b00-94f0-672219d370b2.jpg', null);
INSERT INTO `userfile` VALUES ('10', '0', null, null, '2015-12-17 20:55:25', null, '7', '0', '/upload/47299e64-b108-463f-b5d3-cb5c83278021.jpg', null);
INSERT INTO `userfile` VALUES ('11', '0', null, null, '2015-12-17 20:55:25', null, '7', '0', '/upload/8f7e6bf8-f44a-4cb5-b257-5b33803138bf.jpg', null);
INSERT INTO `userfile` VALUES ('12', '0', null, null, '2015-12-17 20:55:26', null, '7', '0', '/upload/e9615d8c-df6c-4feb-b13b-f4f8379429bb.jpg', null);

-- ----------------------------
-- Table structure for `userinfo`
-- ----------------------------
DROP TABLE IF EXISTS `userinfo`;
CREATE TABLE `userinfo` (
  `id` bigint(20) NOT NULL,
  `version` int(11) NOT NULL,
  `bitState` bigint(20) NOT NULL,
  `realName` varchar(30) DEFAULT NULL,
  `idNumber` varchar(30) DEFAULT NULL,
  `phoneNumber` varchar(30) DEFAULT NULL,
  `incomeGrade_id` bigint(20) DEFAULT NULL,
  `marriage_id` bigint(20) DEFAULT NULL,
  `kidCount_id` bigint(20) DEFAULT NULL,
  `educationBackground_id` bigint(20) DEFAULT NULL,
  `authScore` int(11) DEFAULT NULL,
  `houseCondition_id` bigint(20) DEFAULT NULL,
  `realauthid` bigint(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of userinfo
-- ----------------------------
INSERT INTO `userinfo` VALUES ('4', '20', '63', '哈哈', '510108000000000000', '15500000000', '2', '6', '8', '4', '33', '10', '2', null);
INSERT INTO `userinfo` VALUES ('6', '0', '1', null, null, null, null, null, null, null, '0', null, null, null);
INSERT INTO `userinfo` VALUES ('7', '4', '63', '哈哈', '510108111111111112', '13800000000', '2', '6', '7', '4', '0', '9', '3', 'stea@qq.com');
INSERT INTO `userinfo` VALUES ('10', '0', '1', null, null, '', null, null, null, null, '0', null, null, null);

-- ----------------------------
-- Table structure for `vedioauth`
-- ----------------------------
DROP TABLE IF EXISTS `vedioauth`;
CREATE TABLE `vedioauth` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `state` tinyint(4) NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `auditTime` datetime DEFAULT NULL,
  `applyTime` datetime NOT NULL,
  `auditor_id` bigint(20) DEFAULT NULL,
  `applier_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of vedioauth
-- ----------------------------
INSERT INTO `vedioauth` VALUES ('1', '2', '还是太丑了', '2015-12-15 15:28:15', '2015-12-15 15:28:15', '5', '4');
INSERT INTO `vedioauth` VALUES ('2', '1', '审核通过', '2015-12-15 16:12:35', '2015-12-15 16:12:35', '5', '4');
INSERT INTO `vedioauth` VALUES ('3', '1', '通过审核', '2015-12-15 16:27:01', '2015-12-15 16:27:01', '5', '7');
