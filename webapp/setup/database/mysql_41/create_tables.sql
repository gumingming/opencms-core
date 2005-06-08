CREATE TABLE CMS_USERS (
	USER_ID VARCHAR(36) BINARY NOT NULL,
	USER_NAME VARCHAR(64) BINARY NOT NULL,
	USER_PASSWORD VARCHAR(32) BINARY NOT NULL,
	USER_DESCRIPTION VARCHAR(255) NOT NULL,
	USER_FIRSTNAME VARCHAR(50) NOT NULL,
	USER_LASTNAME VARCHAR(50) NOT NULL,
	USER_EMAIL VARCHAR(100) NOT NULL,
	USER_LASTLOGIN BIGINT NOT NULL,
	USER_FLAGS INT NOT NULL,
	USER_INFO BLOB,
	USER_ADDRESS VARCHAR(100) NOT NULL,
	USER_TYPE INT NOT NULL,
	PRIMARY KEY	(USER_ID), 
	UNIQUE (USER_NAME)
) ENGINE = MYISAM CHARACTER SET utf8;

CREATE TABLE CMS_GROUPS (
	GROUP_ID VARCHAR(36) BINARY NOT NULL,
	PARENT_GROUP_ID VARCHAR(36) BINARY NOT NULL,
	GROUP_NAME VARCHAR(64) BINARY NOT NULL,
	GROUP_DESCRIPTION VARCHAR(255) NOT NULL,
	GROUP_FLAGS INT NOT NULL,
	PRIMARY KEY (GROUP_ID),
	UNIQUE (GROUP_NAME),
	KEY GROUP_PARENTID (PARENT_GROUP_ID)
) ENGINE = MYISAM CHARACTER SET utf8;

CREATE TABLE CMS_GROUPUSERS (
	GROUP_ID VARCHAR(36) BINARY NOT NULL,
	USER_ID VARCHAR(36) BINARY NOT NULL,
	GROUPUSER_FLAGS INT NOT NULL,
	KEY (GROUP_ID),
	KEY (USER_ID)
) ENGINE = MYISAM CHARACTER SET utf8;

CREATE TABLE CMS_PROJECTS (
	PROJECT_ID INT NOT NULL,
	PROJECT_NAME VARCHAR(64) BINARY NOT NULL,
	PROJECT_DESCRIPTION VARCHAR(255) NOT NULL,
	PROJECT_FLAGS INT NOT NULL,
	PROJECT_TYPE INT NOT NULL,
	USER_ID VARCHAR(36) BINARY NOT NULL,
	GROUP_ID VARCHAR(36) BINARY NOT NULL, 
	MANAGERGROUP_ID VARCHAR(36) BINARY NOT NULL,
	TASK_ID INT NOT NULL,
	DATE_CREATED BIGINT NOT NULL,
	PRIMARY KEY (PROJECT_ID), 
	KEY (PROJECT_NAME, DATE_CREATED),
	KEY PROJECT_FLAGS (PROJECT_FLAGS),
	KEY PROJECTS_GROUPID (GROUP_ID),
	KEY PROJECTS_MANAGERID (MANAGERGROUP_ID),
	KEY PROJECTS_USERID (USER_ID),
	KEY PROJECTS_TASKID (TASK_ID),
	UNIQUE (PROJECT_NAME, DATE_CREATED)
) ENGINE = MYISAM CHARACTER SET utf8;

CREATE TABLE CMS_BACKUP_PROJECTS (
	PROJECT_ID INT NOT NULL,
	PROJECT_NAME VARCHAR(64) BINARY NOT NULL,
	PROJECT_DESCRIPTION VARCHAR(255) NOT NULL,
	PROJECT_TYPE INT NOT NULL,
	USER_ID VARCHAR(36) BINARY NOT NULL,
	GROUP_ID VARCHAR(36) BINARY NOT NULL,
	MANAGERGROUP_ID VARCHAR(36) BINARY NOT NULL,
	TASK_ID INT NOT NULL,
	DATE_CREATED BIGINT NOT NULL,	
	PUBLISH_TAG INT NOT NULL,
	PROJECT_PUBLISHDATE DATETIME,
	PROJECT_PUBLISHED_BY VARCHAR(36) BINARY NOT NULL,
	PROJECT_PUBLISHED_BY_NAME VARCHAR(167),
	USER_NAME VARCHAR(167),
	GROUP_NAME VARCHAR(64) BINARY,
	MANAGERGROUP_NAME VARCHAR(64) BINARY,	
	PRIMARY KEY (PUBLISH_TAG)
) ENGINE = MYISAM CHARACTER SET utf8;

CREATE TABLE CMS_PROJECTRESOURCES (
	PROJECT_ID INT NOT NULL,
	RESOURCE_PATH BLOB NOT NULL,
	PRIMARY KEY (PROJECT_ID, RESOURCE_PATH(255)),
	INDEX PROJECTRESOURCE_RESOURCEPATH (RESOURCE_PATH(255))
) ENGINE = MYISAM CHARACTER SET utf8;

CREATE TABLE CMS_BACKUP_PROJECTRESOURCES (
	PUBLISH_TAG INT NOT NULL,
	PROJECT_ID INT NOT NULL,
	RESOURCE_PATH BLOB NOT NULL,
	PRIMARY KEY (PUBLISH_TAG, PROJECT_ID, RESOURCE_PATH(255))
) ENGINE = MYISAM CHARACTER SET utf8;

CREATE TABLE CMS_OFFLINE_PROPERTYDEF (
	PROPERTYDEF_ID VARCHAR(36) BINARY NOT NULL, 
	PROPERTYDEF_NAME VARCHAR(128) BINARY NOT NULL,
	PRIMARY KEY (PROPERTYDEF_ID), 
	UNIQUE INDEX IDX1 (PROPERTYDEF_ID),
	UNIQUE INDEX IDX2 (PROPERTYDEF_NAME)
) ENGINE = MYISAM CHARACTER SET utf8;
                           
CREATE TABLE CMS_ONLINE_PROPERTYDEF (
	PROPERTYDEF_ID VARCHAR(36) BINARY NOT NULL, 
	PROPERTYDEF_NAME VARCHAR(128) BINARY NOT NULL,
	PRIMARY KEY (PROPERTYDEF_ID), 
	UNIQUE INDEX IDX1 (PROPERTYDEF_ID),
	UNIQUE INDEX IDX2 (PROPERTYDEF_NAME)	
) ENGINE = MYISAM CHARACTER SET utf8;
                                        
CREATE TABLE CMS_BACKUP_PROPERTYDEF (
	PROPERTYDEF_ID VARCHAR(36) BINARY NOT NULL, 
	PROPERTYDEF_NAME VARCHAR(128) BINARY NOT NULL,
	PRIMARY KEY (PROPERTYDEF_ID), 
	UNIQUE INDEX IDX1 (PROPERTYDEF_ID),
	UNIQUE INDEX IDX2 (PROPERTYDEF_NAME)	
) ENGINE = MYISAM CHARACTER SET utf8;

CREATE TABLE CMS_OFFLINE_PROPERTIES (
	PROPERTY_ID VARCHAR(36) BINARY NOT NULL,
	PROPERTYDEF_ID VARCHAR(36) BINARY NOT NULL,
	PROPERTY_MAPPING_ID VARCHAR(36) BINARY NOT NULL,
	PROPERTY_MAPPING_TYPE INT NOT NULL,
	PROPERTY_VALUE TEXT NOT NULL,
	PRIMARY KEY (PROPERTY_ID),
	INDEX PROPDEF_IDX (PROPERTYDEF_ID),
	INDEX PROMAP_IDX (PROPERTY_MAPPING_ID),	
	INDEX IDX1 (PROPERTYDEF_ID, PROPERTY_MAPPING_ID)
) ENGINE = MYISAM CHARACTER SET utf8;
                                         
CREATE TABLE CMS_ONLINE_PROPERTIES (
	PROPERTY_ID VARCHAR(36) BINARY NOT NULL,
	PROPERTYDEF_ID VARCHAR(36) BINARY NOT NULL,
	PROPERTY_MAPPING_ID VARCHAR(36) BINARY NOT NULL,
	PROPERTY_MAPPING_TYPE INT NOT NULL,
	PROPERTY_VALUE TEXT NOT NULL,
	PRIMARY KEY(PROPERTY_ID),
	INDEX PROPDEF_IDX (PROPERTYDEF_ID),	
	INDEX PROMAP_IDX (PROPERTY_MAPPING_ID),	
	INDEX IDX1 (PROPERTYDEF_ID, PROPERTY_MAPPING_ID)
) ENGINE = MYISAM CHARACTER SET utf8;
                                                                              
CREATE TABLE CMS_BACKUP_PROPERTIES (
	BACKUP_ID VARCHAR(36) BINARY NOT NULL,
	PROPERTY_ID VARCHAR(36) BINARY NOT NULL,
	PROPERTYDEF_ID VARCHAR(36) BINARY NOT NULL,
	PROPERTY_MAPPING_ID VARCHAR(36) BINARY NOT NULL,
	PROPERTY_MAPPING_TYPE INT NOT NULL,
	PROPERTY_VALUE TEXT NOT NULL,
	PUBLISH_TAG INT,
	VERSION_ID	INT NOT NULL,
	PRIMARY KEY(PROPERTY_ID),
	INDEX IDX1 (PROPERTYDEF_ID, PROPERTY_MAPPING_ID),
	INDEX PROPDEF_IDX (PROPERTYDEF_ID),	
	INDEX PROMAP_IDX (PROPERTY_MAPPING_ID)	
) ENGINE = MYISAM CHARACTER SET utf8;                                                                             

CREATE TABLE CMS_SYSTEMID (
	TABLE_KEY VARCHAR(255) NOT NULL,
	ID INT NOT NULL,
	PRIMARY KEY(TABLE_KEY)
) ENGINE = MYISAM CHARACTER SET utf8;
                                                                                 
CREATE TABLE CMS_TASK (
	AUTOFINISH INT(11),
	ENDTIME DATETIME,
	ESCALATIONTYPEREF INT(11),
	ID INT(11) NOT NULL,
	INITIATORUSERREF VARCHAR(36) BINARY,
	MILESTONEREF INT(11),
	NAME VARCHAR(254),
	ORIGINALUSERREF VARCHAR(36) BINARY,
	AGENTUSERREF VARCHAR(36) BINARY,
	PARENT INT(11),
	PERCENTAGE VARCHAR(50),
	PERMISSION VARCHAR(50),
	PRIORITYREF INT(11) DEFAULT '2',
	ROLEREF VARCHAR(36) BINARY,
	ROOT INT(11),
	STARTTIME DATETIME,
	STATE INT(11),
	TASKTYPEREF INT(11),
	TIMEOUT DATETIME,
	WAKEUPTIME DATETIME,
	HTMLLINK VARCHAR(254),
	ESTIMATETIME INT(11) DEFAULT '86400',
	PRIMARY KEY (ID)
) ENGINE = MYISAM CHARACTER SET utf8;
                                                                                 
CREATE TABLE CMS_TASKTYPE (
	AUTOFINISH INT(11),
	ESCALATIONTYPEREF INT(11),
	HTMLLINK VARCHAR(254),
	ID INT(11) NOT NULL,
	NAME VARCHAR(50),
	PERMISSION VARCHAR(50),
	PRIORITYREF INT(11),
	ROLEREF VARCHAR(36) BINARY,
	PRIMARY KEY (ID)
) ENGINE = MYISAM CHARACTER SET utf8;
                                                                                 
CREATE TABLE CMS_TASKLOG (
	COMENT TEXT,
	EXTERNALUSERNAME VARCHAR(254),
	ID INT(11) NOT NULL,
	STARTTIME DATETIME,
	TASKREF INT(11),
	USERREF VARCHAR(36) BINARY NOT NULL,
	TYPE INT(18) DEFAULT '0',
	PRIMARY KEY (ID)
) ENGINE = MYISAM CHARACTER SET utf8;
                                         
CREATE TABLE CMS_TASKPAR (
	ID INT(11) NOT NULL ,
	PARNAME VARCHAR(50),
	PARVALUE VARCHAR(50),
	REF INT(11),
	PRIMARY KEY (ID)
) ENGINE = MYISAM CHARACTER SET utf8;

CREATE TABLE CMS_ONLINE_ACCESSCONTROL (
	RESOURCE_ID VARCHAR(36) BINARY NOT NULL,
	PRINCIPAL_ID VARCHAR(36) BINARY NOT NULL,
	ACCESS_ALLOWED INT,
	ACCESS_DENIED INT,
	ACCESS_FLAGS INT,
	PRIMARY KEY (RESOURCE_ID, PRINCIPAL_ID),
	INDEX IDX0 (PRINCIPAL_ID)
) ENGINE = MYISAM CHARACTER SET utf8;

CREATE TABLE CMS_OFFLINE_ACCESSCONTROL (
	RESOURCE_ID VARCHAR(36) BINARY NOT NULL,
	PRINCIPAL_ID VARCHAR(36) BINARY NOT NULL,
	ACCESS_ALLOWED INT,
	ACCESS_DENIED INT,
	ACCESS_FLAGS INT,
	PRIMARY KEY (RESOURCE_ID, PRINCIPAL_ID),
	INDEX IDX0 (PRINCIPAL_ID)
) ENGINE = MYISAM CHARACTER SET utf8;

CREATE TABLE CMS_PUBLISH_HISTORY (
	HISTORY_ID VARCHAR(36) BINARY NOT NULL,
	PUBLISH_TAG INT NOT NULL,
	STRUCTURE_ID VARCHAR(36) BINARY NOT NULL,
	RESOURCE_ID VARCHAR(36) BINARY NOT NULL,
	RESOURCE_PATH BLOB NOT NULL,
	RESOURCE_STATE INT NOT NULL,
	RESOURCE_TYPE INT NOT NULL,
	SIBLING_COUNT INT NOT NULL,
	PRIMARY KEY (HISTORY_ID, PUBLISH_TAG, STRUCTURE_ID, RESOURCE_ID)
) ENGINE = MYISAM CHARACTER SET utf8;

CREATE TABLE CMS_STATICEXPORT_LINKS (
	LINK_ID VARCHAR(36) BINARY NOT NULL,
	LINK_RFS_PATH BLOB NOT NULL,
	LINK_TYPE INT NOT NULL,
	LINK_PARAMETER TEXT,
	LINK_TIMESTAMP BIGINT,	
	PRIMARY KEY (LINK_ID)	
) ENGINE = MYISAM CHARACTER SET utf8;

CREATE TABLE CMS_OFFLINE_STRUCTURE (
	STRUCTURE_ID VARCHAR(36) BINARY NOT NULL,
	RESOURCE_ID VARCHAR(36) BINARY NOT NULL,
	PARENT_ID VARCHAR(36) BINARY NOT NULL,
	RESOURCE_PATH BLOB NOT NULL,
	STRUCTURE_STATE SMALLINT UNSIGNED NOT NULL,
	DATE_RELEASED BIGINT NOT NULL,
	DATE_EXPIRED BIGINT NOT NULL,
	PRIMARY KEY (STRUCTURE_ID),
	INDEX IDX1 (STRUCTURE_ID, RESOURCE_PATH(255)),
	INDEX IDX2 (RESOURCE_PATH(255), RESOURCE_ID),
	INDEX IDX4 (STRUCTURE_ID, RESOURCE_ID),
	INDEX IDX7 (STRUCTURE_STATE),
	INDEX IDX3 (PARENT_ID),
	INDEX IDXA1 (RESOURCE_ID),
	INDEX OFFPATH_IDX (RESOURCE_PATH(255))
) ENGINE = MYISAM CHARACTER SET utf8;

CREATE TABLE CMS_ONLINE_STRUCTURE (
	STRUCTURE_ID VARCHAR(36) BINARY NOT NULL,
	RESOURCE_ID VARCHAR(36) BINARY NOT NULL,
	PARENT_ID VARCHAR(36) BINARY NOT NULL,
	RESOURCE_PATH BLOB NOT NULL,
	STRUCTURE_STATE SMALLINT UNSIGNED NOT NULL,
	DATE_RELEASED BIGINT NOT NULL,
	DATE_EXPIRED BIGINT NOT NULL,
	PRIMARY KEY (STRUCTURE_ID),
	INDEX IDX1 (STRUCTURE_ID, RESOURCE_PATH(255)),
	INDEX IDX2 (RESOURCE_PATH(255), RESOURCE_ID),
	INDEX IDX4 (STRUCTURE_ID, RESOURCE_ID),
	INDEX IDX7 (STRUCTURE_STATE),	
	INDEX IDX3 (PARENT_ID),
	INDEX IDXA1 (RESOURCE_ID),
	INDEX OFFPATH_IDX (RESOURCE_PATH(255))	
) ENGINE = MYISAM CHARACTER SET utf8;

CREATE TABLE CMS_BACKUP_STRUCTURE (
	BACKUP_ID VARCHAR(36) BINARY NOT NULL,
	PUBLISH_TAG INT NOT NULL,
	VERSION_ID INT NOT NULL,
	STRUCTURE_ID VARCHAR(36) BINARY NOT NULL,
	RESOURCE_ID VARCHAR(36) BINARY NOT NULL,
	RESOURCE_PATH BLOB NOT NULL,
	STRUCTURE_STATE SMALLINT UNSIGNED NOT NULL,
	DATE_RELEASED BIGINT NOT NULL,
	DATE_EXPIRED BIGINT NOT NULL,
	PRIMARY KEY (BACKUP_ID),
	INDEX IDX1 (STRUCTURE_ID, RESOURCE_PATH(255)),
	INDEX IDX2 (RESOURCE_PATH(255), RESOURCE_ID),
	INDEX IDX4 (STRUCTURE_ID, RESOURCE_ID),
	INDEX IDX7 (STRUCTURE_STATE),
	INDEX IDXA1 (RESOURCE_ID),	
	INDEX OFFPATH_IDX (RESOURCE_PATH(255)),	
	INDEX IDX8 (PUBLISH_TAG),
	INDEX IDX9 (VERSION_ID)	
) ENGINE = MYISAM CHARACTER SET utf8;

CREATE TABLE CMS_OFFLINE_RESOURCES (
	RESOURCE_ID VARCHAR(36) BINARY NOT NULL,
	RESOURCE_TYPE INT NOT NULL,
	RESOURCE_FLAGS INT NOT NULL,
	RESOURCE_STATE	SMALLINT UNSIGNED NOT NULL,
	RESOURCE_SIZE INT NOT NULL,                                         
	SIBLING_COUNT INT NOT NULL,
	DATE_CREATED BIGINT NOT NULL,
	DATE_LASTMODIFIED BIGINT NOT NULL,
	USER_CREATED VARCHAR(36) BINARY NOT NULL,                                         
	USER_LASTMODIFIED VARCHAR(36) BINARY NOT NULL,
	PROJECT_LASTMODIFIED SMALLINT UNSIGNED NOT NULL,          
	PRIMARY KEY(RESOURCE_ID),
	KEY RESOURCE_TYPE (RESOURCE_TYPE), 
	INDEX IDX_PROJECT_LASTMODIFIED (PROJECT_LASTMODIFIED),
	INDEX IDX1 (PROJECT_LASTMODIFIED, RESOURCE_SIZE),
	INDEX IDX2 (RESOURCE_SIZE),
	INDEX IDX3 (DATE_LASTMODIFIED),
	INDEX IDX4 (RESOURCE_TYPE)
) ENGINE = MYISAM CHARACTER SET utf8;

CREATE TABLE CMS_ONLINE_RESOURCES (
	RESOURCE_ID VARCHAR(36) BINARY NOT NULL,
	RESOURCE_TYPE INT NOT NULL,
	RESOURCE_FLAGS INT NOT NULL,
	RESOURCE_STATE	SMALLINT UNSIGNED NOT NULL,
	RESOURCE_SIZE INT NOT NULL,
	SIBLING_COUNT INT NOT NULL,	
	DATE_CREATED BIGINT NOT NULL,
	DATE_LASTMODIFIED BIGINT NOT NULL,
	USER_CREATED VARCHAR(36) BINARY NOT NULL,                                         
	USER_LASTMODIFIED VARCHAR(36) BINARY NOT NULL,
	PROJECT_LASTMODIFIED SMALLINT UNSIGNED NOT NULL,
	PRIMARY KEY(RESOURCE_ID),
	KEY RESOURCE_TYPE (RESOURCE_TYPE),
	INDEX IDX_PROJECT_LASTMODIFIED (PROJECT_LASTMODIFIED),
	INDEX IDX1 (PROJECT_LASTMODIFIED, RESOURCE_SIZE),
	INDEX IDX2 (RESOURCE_SIZE),
	INDEX IDX3 (DATE_LASTMODIFIED),
	INDEX IDX4 (RESOURCE_TYPE)	
) ENGINE = MYISAM CHARACTER SET utf8;
                                         
CREATE TABLE CMS_BACKUP_RESOURCES (
	BACKUP_ID VARCHAR(36) BINARY NOT NULL,
	RESOURCE_ID VARCHAR(36) BINARY NOT NULL,
	RESOURCE_TYPE INT NOT NULL,
	RESOURCE_FLAGS INT NOT NULL,
	RESOURCE_STATE	SMALLINT UNSIGNED NOT NULL,
	RESOURCE_SIZE INT NOT NULL,
	SIBLING_COUNT INT NOT NULL,	
	DATE_CREATED BIGINT NOT NULL,
	DATE_LASTMODIFIED BIGINT NOT NULL,
	USER_CREATED VARCHAR(36) BINARY NOT NULL,
	USER_LASTMODIFIED VARCHAR(36) BINARY NOT NULL,
	PROJECT_LASTMODIFIED SMALLINT UNSIGNED NOT NULL,
	PUBLISH_TAG INT NOT NULL,
	VERSION_ID INT NOT NULL,
	USER_CREATED_NAME VARCHAR(64) NOT NULL,
	USER_LASTMODIFIED_NAME VARCHAR(64) NOT NULL,
	PRIMARY KEY(BACKUP_ID),
	KEY RESOURCE_RESOURCEID (RESOURCE_ID),
	KEY REESOURCE_TYPE (RESOURCE_TYPE),
	INDEX IDX_PROJECT_LASTMODIFIED (PROJECT_LASTMODIFIED),
	INDEX IDX1 (PROJECT_LASTMODIFIED, RESOURCE_SIZE),
	INDEX IDX2 (RESOURCE_SIZE),
	INDEX IDX3 (DATE_LASTMODIFIED),
	INDEX IDX4 (RESOURCE_TYPE)	
) ENGINE = MYISAM CHARACTER SET utf8;
                                         
CREATE TABLE CMS_OFFLINE_CONTENTS (
	CONTENT_ID VARCHAR(36) BINARY NOT NULL,
	RESOURCE_ID VARCHAR(36) BINARY NOT NULL,
	FILE_CONTENT MEDIUMBLOB NOT NULL,
	UNIQUE INDEX IDX1 (RESOURCE_ID),
	PRIMARY KEY(CONTENT_ID)
) ENGINE = MYISAM CHARACTER SET utf8;

CREATE TABLE CMS_ONLINE_CONTENTS (
	CONTENT_ID VARCHAR(36) BINARY NOT NULL,
	RESOURCE_ID VARCHAR(36) BINARY NOT NULL,
	FILE_CONTENT MEDIUMBLOB NOT NULL,
	UNIQUE INDEX IDX1 (RESOURCE_ID),
	PRIMARY KEY(CONTENT_ID)
) ENGINE = MYISAM CHARACTER SET utf8;

CREATE TABLE CMS_BACKUP_CONTENTS (
	BACKUP_ID VARCHAR(36) BINARY NOT NULL,
	CONTENT_ID VARCHAR(36) BINARY NOT NULL,
	RESOURCE_ID VARCHAR(36) BINARY NOT NULL,
	FILE_CONTENT MEDIUMBLOB NOT NULL,
	PUBLISH_TAG INT,
	VERSION_ID INT NOT NULL,
	INDEX IDX1 (RESOURCE_ID),
	PRIMARY KEY(BACKUP_ID)
) ENGINE = MYISAM CHARACTER SET utf8;
