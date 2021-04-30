-- A table for storing a user's time sheets. This records amounts of employees' time which
-- they spend on doing their job.
-- TOD: All tables needs to be encrypted.
START TRANSACTION;
DROP DATABASE IF EXISTS `time_sheet`;

CREATE DATABASE IF NOT EXISTS `time_sheet` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `time_sheet`;

CREATE TABLE IF NOT EXISTS `user` (
  `user_id` BIGINT PRIMARY KEY auto_increment,
  `first_name` varchar(128) NOT NULL,
  `middle_name` varchar(128),
  `last_name` varchar(128) NOT NULL,
  `address` varchar(256) NOT NULL,
  `phone_number` varchar(48) NOT NULL,
  `employee_type_id` INT DEFAULT 1 NOT NULL,
  `email` varchar(128) NOT NULL,
  UNIQUE (`first_name`, `middle_name`, `last_name`, `phone_number`),
  UNIQUE (`email`)
);

CREATE TABLE IF NOT EXISTS `time_sheet_table` (
  `time_id` BIGINT auto_increment,
  `user_id` BIGINT NOT NULL,
  `time` datetime NOT NULL,
  `state` varchar(16) NOT NULL,
  PRIMARY KEY (`time_id`)
);

CREATE TABLE IF NOT EXISTS `occupation` (
  `employee_type_id` INT auto_increment,
  `occupation_type` varchar(64) NOT NULL,
  `wage` INT NOT NULL,
  PRIMARY KEY (`employee_type_id`),
  UNIQUE(`occupation_type`)
);

-- Insert default 
INSERT INTO `occupation` (`occupation_type`,
            `wage`) VALUES ('OCCUPATION_NOT_SELECTED', 0);

-- Different salt is created for different users.
CREATE TABLE IF NOT EXISTS `user_secret` (
  `password_id` BIGINT auto_increment,
  `user_id` BIGINT NOT NULL,
  `salt` varchar(50) NOT NULL,
  `email_verification_token` varchar(128) NOT NULL,
  `verified` BOOLEAN NOT NULL DEFAULT 0,
  `password` varchar(256) NOT NULL,
  PRIMARY KEY (`password_id`)
);

ALTER TABLE `user_secret` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);
ALTER TABLE `time_sheet_table` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);
ALTER TABLE `user` ADD FOREIGN KEY (`employee_type_id`) REFERENCES `occupation` (`employee_type_id`);

-- Change users' database permissions
GRANT SELECT, INSERT ON `time_sheet`.* TO 'time_sheet_client'@'%';
GRANT ALL PRIVILEGES ON `time_sheet`.* TO 'time_sheet_admin'@'%' WITH GRANT OPTION;

COMMIT;