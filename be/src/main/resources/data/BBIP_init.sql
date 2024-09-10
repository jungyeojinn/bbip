-- 데이터베이스 생성
CREATE DATABASE IF NOT EXISTS bbip_db;
USE bbip_db;

-- 'user' 테이블 생성
CREATE TABLE IF NOT EXISTS `user` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(20) NOT NULL,
    `email` VARCHAR(50) NOT NULL,
    `nickname` VARCHAR(20) NOT NULL,
    `deleted` TINYINT(1) NOT NULL
);

-- 'face' 테이블 생성
CREATE TABLE IF NOT EXISTS `face` (
    `user_id` INT NOT NULL,
    `self` TINYINT(1) NOT NULL,
    `embedding` BLOB NOT NULL,
    PRIMARY KEY (`user_id`),
    CONSTRAINT `fk_face_user`
        FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
        ON DELETE CASCADE
);

-- 'rtmp_server' 테이블 생성
CREATE TABLE IF NOT EXISTS `rtmp_server` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(20) NOT NULL,
    `uri` VARCHAR(100) NOT NULL
);

-- 'stream_key' 테이블 생성
CREATE TABLE IF NOT EXISTS `stream_key` (
    `user_id` INT NOT NULL,
    `server_id` INT NOT NULL,
    `key` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`user_id`, `server_id`),
    CONSTRAINT `fk_streamkey_user`
        FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
        ON DELETE CASCADE,
    CONSTRAINT `fk_streamkey_server`
        FOREIGN KEY (`server_id`) REFERENCES `rtmp_server` (`id`)
        ON DELETE CASCADE
);

INSERT INTO `rtmp_server` (`id`, `name`, `uri`) VALUES
(1, 'youtube', 'rtmp://a.rtmp.youtube.com/live2/'),
(2, 'twitch', 'rtmp://live.twitch.tv/app/'),
(3, 'afreeca_tv', 'rtmp://afreecatv.com/live/'),
(4, 'chzzk', 'rtmp://global-rtmp.lip2.navercorp.com:8080/relay'),
(5, 'periscope', 'rtmp://live.periscope.tv:80/'),
(6, 'facebook', 'rtmp://live-api-s.facebook.com:80/rtmp/'),
(7, 'dLive', 'rtmp://stream.dlive.tv/'),
(8, 'trovo', 'rtmp://live.trovo.live/stream/');

