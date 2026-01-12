CREATE DATABASE IF NOT EXISTS hrms;
USE hrms;

CREATE TABLE `users` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `email` varchar(50) UNIQUE NOT NULL,
  `display_name` varchar(50),
  `avatar_url` text,
  `manager_id` int,
  `created_at` timestamp DEFAULT current_timestamp,
  `updated_at` timestamp DEFAULT current_timestamp on update current_timestamp  -- COMMENT 'on update current_timestamp'
);

CREATE TABLE `biometrics` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `credential_id` varbinary(255) UNIQUE NOT NULL,
  `device_type` varchar(255),
  `public_key` blob NOT NULL,
  `created_at` timestamp DEFAULT current_timestamp
);

CREATE TABLE `social_accounts` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `provider_name` varchar(30) NOT NULL,
  `provider_user_id` varchar(255) NOT NULL,
  `access_token` text NOT NULL,
  `refresh_token` text,
  `expires_at` timestamp,
  `scope` varchar(255),
  `created_at` timestamp DEFAULT current_timestamp
);

CREATE TABLE `expense_categories` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(255)
);

CREATE TABLE `expenses` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `payee` int NOT NULL,
  `amount` double NOT NULL,
  `category` int NOT NULL DEFAULT 1,
  `status` ENUM ('pending', 'approved', 'rejected') DEFAULT 'pending',
  `created_at` timestamp DEFAULT current_timestamp,
  `updated_at` timestamp DEFAULT current_timestamp on update current_timestamp -- COMMENT 'on update current_timestamp'
);

CREATE TABLE `expense_splits` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `expense_id` int NOT NULL,
  `user_id` int NOT NULL,
  `amount` double NOT NULL,
  `remark` varchar(255),
  `created_at` timestamp DEFAULT current_timestamp,
  `updated_at` timestamp DEFAULT current_timestamp on update current_timestamp -- COMMENT 'on update current_timestamp'
);

CREATE TABLE `leaves` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `reason` text NOT NULL,
  `from_date` date NOT NULL,
  `to_date` date NOT NULL,
  `status` ENUM ('pending', 'approved', 'rejected') DEFAULT 'pending',
  `half_day` bool DEFAULT 0,
  `created_at` timestamp DEFAULT current_timestamp,
  `updated_at` timestamp DEFAULT current_timestamp on update current_timestamp -- COMMENT 'on update current_timestamp'
);

CREATE TABLE `attendance` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `location` POINT NOT NULL, -- COMMENT 'SRID 4326',
  `created_at` timestamp DEFAULT current_timestamp,
  SPATIAL INDEX(location)
);

ALTER TABLE `attendance` ADD CONSTRAINT `fk_user_attendance` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `biometrics` ADD CONSTRAINT `fk_user_biometrics` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `users` ADD CONSTRAINT `fk_user_manager` FOREIGN KEY (`manager_id`) REFERENCES `users` (`id`);

ALTER TABLE `leaves` ADD CONSTRAINT `fk_user_leave` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `expenses` ADD CONSTRAINT `fk_user_expense` FOREIGN KEY (`payee`) REFERENCES `users` (`id`);

ALTER TABLE `expense_splits` ADD CONSTRAINT `fk_expense_split` FOREIGN KEY (`expense_id`) REFERENCES `expenses` (`id`);

ALTER TABLE `expense_splits` ADD CONSTRAINT `fk_user_expense_split` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `expenses` ADD CONSTRAINT `fk_expense_category` FOREIGN KEY (`category`) REFERENCES `expense_categories` (`id`);

ALTER TABLE `social_accounts` ADD CONSTRAINT `fk_user_social_account` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

