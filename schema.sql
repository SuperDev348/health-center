create table if not exists category
(
    cate_id       serial
        constraint category_pk
            primary key,
    cate_category varchar(60) not null
);

alter table category
    owner to postgres;

create unique index if not exists category_cate_category_uindex
    on category (cate_category);

create table if not exists conversation
(
    conv_uuid   uuid not null
        constraint conversation_pk
            primary key,
    conv_user_a uuid not null,
    conv_user_b uuid not null
);

alter table conversation
    owner to postgres;

create table if not exists file
(
    file_uuid  uuid         not null
        constraint file_pk
            primary key,
    file_title varchar(255) not null,
    file_name  varchar(255) not null
);

alter table file
    owner to postgres;

create unique index if not exists file_file_uuid_uindex
    on file (file_uuid);

create table if not exists home_screen
(
    hosc_uuid uuid                                not null,
    hosc_file varchar(60)                         not null,
    hosc_date timestamp default CURRENT_TIMESTAMP not null,
    hosc_type varchar(20)
);

alter table home_screen
    owner to postgres;

create table if not exists main_text
(
    mate_uuid   uuid         not null,
    mate_text   varchar(500) not null,
    mate_text_b varchar(500)
);

alter table main_text
    owner to postgres;

create table if not exists page
(
    page_uuid        uuid                                not null
        constraint page_pk
            primary key,
    page_title       varchar(160)                        not null,
    page_slug        varchar(160)                        not null,
    page_keywords    varchar(160)                        not null,
    page_content     text,
    "page_createdAt" timestamp default CURRENT_TIMESTAMP not null,
    page_updated_at  timestamp default CURRENT_TIMESTAMP not null
);

alter table page
    owner to postgres;

create unique index if not exists page_page_uuid_uindex
    on page (page_uuid);

create table if not exists previous_conversation
(
    prco_uuid   uuid                                not null,
    prco_user_a uuid                                not null,
    prco_user_b uuid                                not null,
    prco_pdf    varchar(30)                         not null,
    prco_date   timestamp default CURRENT_TIMESTAMP not null
);

alter table previous_conversation
    owner to postgres;

create table if not exists privacy_policy
(
    prpo_id   serial
        constraint privacy_policy_pk
            primary key,
    prpo_text text not null
);

alter table privacy_policy
    owner to postgres;

create unique index if not exists privacy_policy_prpo_id_uindex
    on privacy_policy (prpo_id);

create table if not exists terms_conditions
(
    teco_id   serial
        constraint terms_conditions_pk
            primary key,
    teco_text text not null
);

alter table terms_conditions
    owner to postgres;

create unique index if not exists terms_conditions_teco_id_uindex
    on terms_conditions (teco_id);

create table if not exists user_role
(
    usro_id   serial
        constraint user_role_pk
            primary key,
    usro_role varchar(12) not null,
    usro_key  varchar(9)  not null
);

alter table user_role
    owner to postgres;

create table if not exists "user"
(
    user_uuid           uuid                  not null
        constraint user_pk
            unique,
    user_email          varchar(150),
    user_first_name     varchar(30)           not null,
    user_last_name      varchar(30)           not null,
    user_date_of_birth  date,
    user_password       varchar(100),
    user_usro_id        serial
        constraint user_user_role_usro_id_fk
            references user_role
            on update cascade on delete restrict,
    user_email_verified boolean default false not null,
    user_deleted        boolean default false not null,
    user_blocked        boolean default false not null,
    user_mrn            serial,
    user_owner          uuid
        constraint user_user_user_uuid_fk
            references "user" (user_uuid),
    user_country_code   varchar(3),
    user_phone_no       varchar(15),
    user_picture        varchar(60)
);

alter table "user"
    owner to postgres;

create table if not exists address
(
    addr_uuid       uuid                  not null
        constraint address_pk
            primary key,
    addr_line1      varchar(100)          not null,
    addr_city       varchar(60)           not null,
    addr_state      varchar(60)           not null,
    addr_zip        varchar(12)           not null,
    addr_owner      uuid                  not null
        constraint address_user_user_uuid_fk
            references "user" (user_uuid)
            on update cascade on delete cascade,
    addr_is_patient boolean default false not null
);

alter table address
    owner to postgres;

create unique index if not exists address_addr_uuid_uindex
    on address (addr_uuid);

create table if not exists medical_record
(
    mere_uuid            uuid                                not null
        constraint medical_record_pk
            primary key,
    mere_name            varchar(60),
    mere_allergies       text,
    mere_current_meds    text,
    mere_medical_history text,
    mere_social_history  text,
    mere_family_history  text,
    mere_bp              varchar(10),
    mere_pulse           varchar(10),
    mere_resp_rate       varchar(10),
    mere_temp            varchar(10),
    mere_height          double precision,
    mere_weight          double precision,
    mere_chief_complaint text,
    mere_hpi             text,
    mere_subject         text,
    mere_objective       text,
    mere_assessment      text,
    mere_plan            text,
    mere_owner           uuid                                not null
        constraint medical_record_user_user_uuid_fk
            references "user" (user_uuid)
            on update cascade on delete restrict,
    mere_is_public       boolean   default false             not null,
    mere_date            date,
    mere_sign            text,
    mere_addendum        text,
    mere_updated         timestamp default CURRENT_TIMESTAMP not null,
    mere_is_draft        boolean   default true              not null,
    mere_is_encounter    boolean   default false             not null
);

alter table medical_record
    owner to postgres;

create table if not exists medical_record_user
(
    mrus_uuid      uuid                                not null
        constraint medical_record_user_pk
            primary key,
    mrus_mere_uuid uuid                                not null
        constraint medical_record_user_medical_record_mere_uuid_fk
            references medical_record
            on update cascade on delete cascade,
    mrus_user_uuid uuid                                not null
        constraint medical_record_user_user_user_uuid_fk
            references "user" (user_uuid)
            on update cascade on delete cascade,
    mrus_date      timestamp default CURRENT_TIMESTAMP not null,
    mrus_updated   timestamp default CURRENT_TIMESTAMP not null
);

alter table medical_record_user
    owner to postgres;

create unique index if not exists medical_record_user_mrus_uuid_uindex
    on medical_record_user (mrus_uuid);

create table if not exists messages
(
    mess_uuid      uuid                                not null
        constraint messages_pk
            primary key,
    mess_conv_uuid uuid                                not null
        constraint messages_conversation_conv_uuid_fk
            references conversation
            on update cascade on delete cascade,
    mess_sender    uuid                                not null
        constraint messages_user_user_uuid_fk
            references "user" (user_uuid)
            on update cascade on delete cascade,
    mess_message   text,
    mess_date      timestamp default CURRENT_TIMESTAMP not null,
    mess_file      uuid
        constraint messages_file_file_uuid_fk
            references file
            on update cascade on delete cascade,
    mess_read      boolean   default false             not null
);

alter table messages
    owner to postgres;

create unique index if not exists messages_mess_uuid_uindex
    on messages (mess_uuid);

create table if not exists my_doctor
(
    mydo_uuid      uuid not null
        constraint my_doctor_pk
            primary key,
    mydo_owner     uuid not null
        constraint my_doctor_user_user_uuid_fk
            references "user" (user_uuid)
            on update cascade on delete cascade,
    mydo_user_uuid uuid not null
        constraint my_doctor_user_user_uuid_fk_2
            references "user" (user_uuid)
            on update cascade on delete cascade
);

alter table my_doctor
    owner to postgres;

create unique index if not exists my_doctor_mydo_uuid_uindex
    on my_doctor (mydo_uuid);

create table if not exists my_professionals
(
    mypr_id           serial,
    mypr_uuid         uuid                                not null
        constraint my_proffessionals_user_user_uuid_fk
            references "user" (user_uuid),
    mypr_proffesional uuid                                not null
        constraint my_proffessionals_user_user_uuid_fk_2
            references "user" (user_uuid),
    mypr_allowed      boolean   default false             not null,
    mypr_date         timestamp default CURRENT_TIMESTAMP not null
);

alter table my_professionals
    owner to postgres;

create unique index if not exists user_user_mrn_uindex
    on "user" (user_mrn);

create unique index if not exists user_user_uuid_uindex
    on "user" (user_uuid);

create unique index if not exists user_role_usro_id_uindex
    on user_role (usro_id);

create unique index if not exists user_role_usro_key_uindex
    on user_role (usro_key);

create unique index if not exists user_role_usro_role_uindex
    on user_role (usro_role);

create table if not exists verification_code
(
    veco_id             serial
        constraint verification_code_pk
            primary key,
    veco_code           varchar(9)                                        not null,
    veco_user_uuid      uuid                                              not null
        constraint verification_code_user_user_uuid_fk
            references "user" (user_uuid)
            on update cascade on delete cascade,
    veco_reset_password boolean     default false                         not null,
    veco_type           varchar(15) default 'PASSWORD'::character varying not null,
    veco_date           timestamp   default CURRENT_DATE                  not null
);

alter table verification_code
    owner to postgres;

create unique index if not exists verification_code_veco_id_uindex
    on verification_code (veco_id);

create table if not exists refresh_token
(
    reto_uuid          uuid                                not null
        constraint refresh_token_pk
            primary key,
    reto_user_uuid     uuid                                not null
        constraint refresh_token_user_user_uuid_fk
            references "user" (user_uuid)
            on update cascade on delete cascade,
    reto_refresh_token uuid                                not null,
    reto_created_at    timestamp default CURRENT_TIMESTAMP not null,
    reto_ip_address    varchar(40)
);

alter table refresh_token
    owner to postgres;

create unique index if not exists refresh_token_reto_uuid_uindex
    on refresh_token (reto_uuid);

create table if not exists specialty
(
    spec_id        serial
        constraint specialty_pk
            primary key,
    spec_cate_id   integer     not null
        constraint specialty_category_cate_id_fk
            references category
            on update cascade on delete cascade,
    spec_specialty varchar(30) not null
);

alter table specialty
    owner to postgres;

create table if not exists professional
(
    profe_uuid            uuid                                not null
        constraint professional_pk
            primary key,
    profe_cate_id         integer                             not null,
    profe_user_uuid       uuid                                not null,
    profe_is_active       boolean   default false,
    profe_created_at      timestamp default CURRENT_TIMESTAMP not null,
    profe_update_at       timestamp default CURRENT_TIMESTAMP not null,
    profe_npi             varchar(10)                         not null,
    profe_pin             varchar(7),
    profe_specialty       varchar(60),
    profe_practice_name   varchar(60),
    profe_medical_license varchar(12),
    profe_license_state   varchar(30),
    profe_credentials     varchar(60),
    profe_email_sent      boolean   default false             not null,
    profe_pin_set         boolean   default false             not null,
    profe_spec_id         integer
        constraint professional_specialty_spec_id_fk
            references specialty
            on update set null on delete set null
);

alter table professional
    owner to postgres;

create unique index if not exists professional_profe_uuid_uindex
    on professional (profe_uuid);

create unique index if not exists specialty_spec_id_uindex
    on specialty (spec_id);

create table if not exists notification_type
(
    noty_id  serial
        constraint notification_type_pk
            primary key,
    noty_en  varchar(255) not null,
    noty_es  varchar(255) not null,
    noty_key varchar(30)  not null
);

alter table notification_type
    owner to postgres;

create table if not exists notification
(
    noti_uuid    uuid                                not null,
    noti_from    uuid,
    noti_to      uuid                                not null,
    noti_date    timestamp default CURRENT_TIMESTAMP not null,
    noti_noty_id integer
        constraint notification_notification_type_noty_id_fk
            references notification_type
            on delete restrict
);

alter table notification
    owner to postgres;

create unique index if not exists notification_noti_uuid_uindex
    on notification (noti_uuid);

create unique index if not exists notification_type_noty_id_uindex
    on notification_type (noty_id);

create unique index if not exists notification_type_noty_key_uindex
    on notification_type (noty_key);
