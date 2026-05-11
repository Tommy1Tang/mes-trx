-- PostgreSQL 版 Quartz 初始化脚本
-- 来源：quartz.sql (MySQL → PostgreSQL 转换)

DROP TABLE IF EXISTS QRTZ_FIRED_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_PAUSED_TRIGGER_GRPS;
DROP TABLE IF EXISTS QRTZ_SCHEDULER_STATE;
DROP TABLE IF EXISTS QRTZ_LOCKS;
DROP TABLE IF EXISTS QRTZ_SIMPLE_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_SIMPROP_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_CRON_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_BLOB_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_JOB_DETAILS;
DROP TABLE IF EXISTS QRTZ_CALENDARS;

-- 1、存储每一个已配置的 jobDetail 的详细信息
CREATE TABLE QRTZ_JOB_DETAILS (
    sched_name           varchar(120)    not null,
    job_name             varchar(200)    not null,
    job_group            varchar(200)    not null,
    description          varchar(250)    null,
    job_class_name       varchar(250)    not null,
    is_durable           varchar(1)      not null,
    is_nonconcurrent     varchar(1)      not null,
    is_update_data       varchar(1)      not null,
    requests_recovery    varchar(1)      not null,
    job_data             bytea           null,
    primary key (sched_name, job_name, job_group)
);

-- 2、存储已配置的 Trigger 的信息
CREATE TABLE QRTZ_TRIGGERS (
    sched_name           varchar(120)    not null,
    trigger_name         varchar(200)    not null,
    trigger_group        varchar(200)    not null,
    job_name             varchar(200)    not null,
    job_group            varchar(200)    not null,
    description          varchar(250)    null,
    next_fire_time       bigint          null,
    prev_fire_time       bigint          null,
    priority             integer         null,
    trigger_state        varchar(16)     not null,
    trigger_type         varchar(8)      not null,
    start_time           bigint          not null,
    end_time             bigint          null,
    calendar_name        varchar(200)    null,
    misfire_instr        smallint        null,
    job_data             bytea           null,
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, job_name, job_group) references QRTZ_JOB_DETAILS(sched_name, job_name, job_group)
);

-- 3、存储简单的 Trigger
CREATE TABLE QRTZ_SIMPLE_TRIGGERS (
    sched_name           varchar(120)    not null,
    trigger_name         varchar(200)    not null,
    trigger_group        varchar(200)    not null,
    repeat_count         bigint          not null,
    repeat_interval      bigint          not null,
    times_triggered      bigint          not null,
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
);

-- 4、存储 Cron Trigger
CREATE TABLE QRTZ_CRON_TRIGGERS (
    sched_name           varchar(120)    not null,
    trigger_name         varchar(200)    not null,
    trigger_group        varchar(200)    not null,
    cron_expression      varchar(200)    not null,
    time_zone_id         varchar(80),
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
);

-- 5、Trigger 作为 Blob 类型存储
CREATE TABLE QRTZ_BLOB_TRIGGERS (
    sched_name           varchar(120)    not null,
    trigger_name         varchar(200)    not null,
    trigger_group        varchar(200)    not null,
    blob_data            bytea           null,
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
);

-- 6、日历信息表
CREATE TABLE QRTZ_CALENDARS (
    sched_name           varchar(120)    not null,
    calendar_name        varchar(200)    not null,
    calendar             bytea           not null,
    primary key (sched_name, calendar_name)
);

-- 7、已暂停的 Trigger 组
CREATE TABLE QRTZ_PAUSED_TRIGGER_GRPS (
    sched_name           varchar(120)    not null,
    trigger_group        varchar(200)    not null,
    primary key (sched_name, trigger_group)
);

-- 8、已触发的触发器表
CREATE TABLE QRTZ_FIRED_TRIGGERS (
    sched_name           varchar(120)    not null,
    entry_id             varchar(95)     not null,
    trigger_name         varchar(200)    not null,
    trigger_group        varchar(200)    not null,
    instance_name        varchar(200)    not null,
    fired_time           bigint          not null,
    sched_time           bigint          not null,
    priority             integer         not null,
    state                varchar(16)     not null,
    job_name             varchar(200)    null,
    job_group            varchar(200)    null,
    is_nonconcurrent     varchar(1)      null,
    requests_recovery    varchar(1)      null,
    primary key (sched_name, entry_id)
);

-- 9、调度器状态表
CREATE TABLE QRTZ_SCHEDULER_STATE (
    sched_name           varchar(120)    not null,
    instance_name        varchar(200)    not null,
    last_checkin_time    bigint          not null,
    checkin_interval     bigint          not null,
    primary key (sched_name, instance_name)
);

-- 10、悲观锁信息表
CREATE TABLE QRTZ_LOCKS (
    sched_name           varchar(120)    not null,
    lock_name            varchar(40)     not null,
    primary key (sched_name, lock_name)
);

-- 11、同步机制的行锁表
CREATE TABLE QRTZ_SIMPROP_TRIGGERS (
    sched_name           varchar(120)    not null,
    trigger_name         varchar(200)    not null,
    trigger_group        varchar(200)    not null,
    str_prop_1           varchar(512)    null,
    str_prop_2           varchar(512)    null,
    str_prop_3           varchar(512)    null,
    int_prop_1           integer         null,
    int_prop_2           integer         null,
    long_prop_1          bigint          null,
    long_prop_2          bigint          null,
    dec_prop_1           numeric(13,4)   null,
    dec_prop_2           numeric(13,4)   null,
    bool_prop_1          varchar(1)      null,
    bool_prop_2          varchar(1)      null,
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
);

COMMENT ON TABLE QRTZ_JOB_DETAILS IS '任务详细信息表';
COMMENT ON TABLE QRTZ_TRIGGERS IS '触发器详细信息表';
COMMENT ON TABLE QRTZ_SIMPLE_TRIGGERS IS '简单触发器的信息表';
COMMENT ON TABLE QRTZ_CRON_TRIGGERS IS 'Cron类型的触发器表';
COMMENT ON TABLE QRTZ_BLOB_TRIGGERS IS 'Blob类型的触发器表';
COMMENT ON TABLE QRTZ_CALENDARS IS '日历信息表';
COMMENT ON TABLE QRTZ_PAUSED_TRIGGER_GRPS IS '暂停的触发器表';
COMMENT ON TABLE QRTZ_FIRED_TRIGGERS IS '已触发的触发器表';
COMMENT ON TABLE QRTZ_SCHEDULER_STATE IS '调度器状态表';
COMMENT ON TABLE QRTZ_LOCKS IS '存储的悲观锁信息表';
COMMENT ON TABLE QRTZ_SIMPROP_TRIGGERS IS '同步机制的行锁表';

COMMIT;
