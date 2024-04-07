DROP TABLE IF EXISTS `economic_word`;
DROP TABLE IF EXISTS `comment`;
DROP TABLE IF EXISTS `post_category`;
DROP TABLE IF EXISTS `bookmark`;
DROP TABLE IF EXISTS `post`;
DROP TABLE IF EXISTS `policy`;
DROP TABLE IF EXISTS `category`;
DROP TABLE IF EXISTS `category_detail`;
DROP TABLE IF EXISTS `user`;
DROP TABLE IF EXISTS `policy_category_detail`;

CREATE TABLE `user`
(
    `user_id`       INT         NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_login_id` VARCHAR(16) NOT NULL,
    `user_password` VARCHAR(255) NOT NULL COMMENT 'bcrypt',
    `user_nickname` VARCHAR(33) NOT NULL,
    `created_at`    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `is_deleted`    BIT         NOT NULL DEFAULT FALSE,
    `deleted_at`    DATETIME NULL DEFAULT NULL
);

CREATE TABLE `economic_word`
(
    `economic_word_id`          INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `economic_word`             VARCHAR(255) NOT NULL,
    `economic_word_description` TEXT         NOT NULL
);



CREATE TABLE `bookmark`
(
    `bookmark_id`   INT     NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_id`       INT     NOT NULL DEFAULT 0,
    `referenced_id` INT     NOT NULL DEFAULT 0,
    `bookmark_type` CHAR(3) NOT NULL COMMENT 'POS: 게시글, POL: 정책'
);



CREATE TABLE `post`
(
    `post_id`      INT           NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_id`      INT           NOT NULL DEFAULT 0,
    `post_name`    VARCHAR(400)  NOT NULL,
    `post_content` VARCHAR(6000) NOT NULL,
    `created_at`   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `is_deleted`   BIT           NOT NULL DEFAULT FALSE,
    `deleted_at`   DATETIME NULL DEFAULT NULL
);


CREATE TABLE `policy`
(
    `policy_id`                             INT         NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `policy_code`                           VARCHAR(16) NOT NULL COMMENT 'API의 정책 ID',
    `policy_area`                           VARCHAR(21) NOT NULL COMMENT '🔑 API의 정책일련번호',
    `policy_name`                           TEXT        NOT NULL COMMENT 'API의 정책명',
    `policy_intro`                          TEXT NULL DEFAULT NULL COMMENT 'API의 정책소개',
    `policy_support_content`                TEXT NULL DEFAULT NULL COMMENT 'API의 지원내용',
    `policy_support_scale`                  TEXT NULL DEFAULT NULL COMMENT 'API의 지원규모',
    `policy_etc`                            TEXT NULL DEFAULT NULL COMMENT 'API의 기타사항',
    `policy_field`                          VARCHAR(21) NOT NULL COMMENT '🔑 API의 정책분야코드(관심분야)',
    `policy_business_period`                TEXT NULL DEFAULT NULL COMMENT 'API의 사업운영기간내용',
    `policy_period_type_code`               VARCHAR(21) NOT NULL COMMENT '🔑 API의 산업신청기간반복구분코드',
    `policy_start_date`                     DATE NULL COMMENT 'policy_business_period 가공',
    `policy_end_date`                       DATE NULL COMMENT 'policy_business_period 가공',
    `policy_age_info`                       VARCHAR(40) NULL COMMENT '"만 OO세 ~ OO세" 로 통일',
    `policy_major_requirements`             TEXT NULL COMMENT 'API의 전공요건내용',
    `policy_employment_status`              VARCHAR(31) NOT NULL COMMENT '🔑 API의 취업상태내용',
    `policy_specialized_field`              VARCHAR(31) NOT NULL COMMENT '🔑 API의 특화분야내용',
    `policy_education_requirements`         VARCHAR(31) NOT NULL COMMENT '🔑 API의 학력요건내용',
    `policy_residence_income`               TEXT NULL DEFAULT NULL COMMENT 'API의 거주지및소득조건내용',
    `policy_additional_clues`               TEXT NULL DEFAULT NULL COMMENT 'API의 추가단서사항내용',
    `policy_entry_limit`                    TEXT NULL DEFAULT NULL COMMENT 'API의 참여제한대상내용',
    `policy_application_procedure`          TEXT NULL DEFAULT NULL COMMENT 'API의 신청절차내용',
    `policy_required_documents`             TEXT NULL DEFAULT NULL COMMENT 'API의 제출서류내용',
    `policy_evaluation_content`             TEXT NULL DEFAULT NULL COMMENT 'API의 심사발표내용',
    `policy_site_address`                   VARCHAR(1000) NULL DEFAULT NULL COMMENT 'API의 신청사이트주소',
    `policy_main_organization`              TEXT NULL DEFAULT NULL COMMENT 'API의 주관부처명',
    `policy_main_contact`                   TEXT NULL DEFAULT NULL COMMENT 'API의 주관부처담당자연락처',
    `policy_operation_organization`         TEXT NULL DEFAULT NULL COMMENT 'API의 운영기관명',
    `policy_operation_organization_contact` TEXT NULL DEFAULT NULL COMMENT 'API의 운영기관담당자연락처',
    `policy_application_period`             TEXT NULL DEFAULT NULL COMMENT 'API의 사업신청기간-관리자가 startDate, endDate로 분리',
    `policy_is_processed`                   BIT         NOT NULL COMMENT '원본 데이터 가공 여부',
    `policy_processed_at`                   DATETIME NULL COMMENT '원본 데이터 가공 일자',
    `policy_created_at`                     DATETIME    NOT NULL DEFAULT (CURRENT_DATE) COMMENT '원본 데이터 반입 일자'
);

CREATE INDEX idx_policy_code ON policy(policy_code);


CREATE TABLE `comment`
(
    `comment_id`      INT           NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_id`         INT           NOT NULL,
    `referenced_id`   INT           NOT NULL,
    `comment_type`    CHAR(3)       NOT NULL COMMENT 'POL: 정책, POS: 게시글',
    `comment_content` VARCHAR(1200) NOT NULL,
    `created_at`      DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `is_deleted`      BIT           NOT NULL DEFAULT FALSE,
    `deleted_at`      DATETIME NULL DEFAULT NULL
);

CREATE TABLE `category`
(
    `category_code` VARCHAR(21) NOT NULL PRIMARY KEY COMMENT '코드',
    `category_name` VARCHAR(21) NOT NULL COMMENT '분류명'
);

CREATE TABLE `category_detail`
(
    `category_code`   VARCHAR(21)  NOT NULL COMMENT '코드',
    `category_number` INT          NOT NULL COMMENT '번호',
    `category_name`   VARCHAR(100) NOT NULL COMMENT '카테고리명',
    PRIMARY KEY (`category_code`, `category_number`)
);

CREATE TABLE `post_category`
(
    `category_code`   VARCHAR(21) NOT NULL COMMENT '코드',
    `category_number` INT         NOT NULL COMMENT '번호',
    `post_id`         INT         NOT NULL DEFAULT 0,
    PRIMARY KEY (`post_id`, `category_number`, `category_code`)
);

CREATE TABLE `policy_category_detail`
(
    `category_code`   VARCHAR(21) NOT NULL COMMENT '코드',
    `category_number` INT     NOT NULL COMMENT '번호',
    `policy_id`       INT         NOT NULL,
    PRIMARY KEY (`category_code`, `category_number`, `policy_id`)
);

INSERT INTO category (category_code, category_name)
VALUES ('RGO', '지역');
INSERT INTO category (category_code, category_name)
VALUES ('ADM', '학력');
INSERT INTO category (category_code, category_name)
VALUES ('EPM', '취업 상태');
INSERT INTO category (category_code, category_name)
VALUES ('SPC', '특화 분야');
INSERT INTO category (category_code, category_name)
VALUES ('PFD', '관심 분야');
INSERT INTO category (category_code, category_name)
VALUES ('APC', '신청 기간');
INSERT INTO category (category_code, category_name)
VALUES ('POS', '게시판');

-- 취업 상태
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('EPM', 1, '제한 없음');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('EPM', 2, '재직자');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('EPM', 3, '개인 사업자');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('EPM', 4, '미취업자');

-- 학력
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('ADM', 1, '제한 없음');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('ADM', 2, '고졸 이하');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('ADM', 3, '대학 재학');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('ADM', 4, '대졸 예정');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('ADM', 5, '대학 졸업');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('ADM', 6, '석/박사');

-- 특화 분야
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('SPC', 1, '제한 없음');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('SPC', 2, '여성');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('SPC', 3, '장애인');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('SPC', 4, '군인');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('SPC', 5, '중소기업');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('SPC', 6, '저소득층');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('SPC', 7, '농업인');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('SPC', 8, '지역인재');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('SPC', 9, '기타');

-- 관심 분야
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('PFD', 23010, '일자리');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('PFD', 23020, '주거');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('PFD', 23030, '교육');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('PFD', 23040, '복지,문화');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('PFD', 23050, '참여,권리');

-- 지역
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3001, '중앙부처');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002001, '서울');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002002, '부산');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002003, '대구');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002004, '인천');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002005, '광주');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002006, '대전');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002007, '울산');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002008, '경기');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002009, '강원');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002010, '충북');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002011, '충남');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002012, '전북');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002013, '전남');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002014, '경북');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002015, '경남');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002016, '제주');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002017, '세종');

-- 신청 구분
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('APC', 1, '상시');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('APC', 2, '미정');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('APC', 3, '기간 선택');

-- 게시판
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('POS', 1, '전체');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('POS', 2, '정책 추천');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('POS', 3, '공모전');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('POS', 4, '생활 꿀팁');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('POS', 5, '기타');
