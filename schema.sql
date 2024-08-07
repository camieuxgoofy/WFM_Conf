-- Select User List
SELECT
    tx_user_management.username AS username,
    tx_user_management.email AS email,
    tx_user_management.employee_name AS employe_name,
    tm_regional.regional_name AS regional_name,
    tm_cluster.cluster_name AS cluster_name,
    tm_area.area_name AS area_name
FROM
    tx_user_management
    JOIN tm_regional ON tx_user_management.regional_id = tm_regional.regional_id
    JOIN tm_cluster ON tx_user_management.cluster_id = tm_cluster.cluster_id
    JOIN tm_area ON tx_user_management.area_id = tm_area.area_id;

-- Select Absent
select
    a.absendate,
    a.userid,
    b.timein,
    c.timeout,
    d.username,
    d.area_id,
    d.regional_id,
    d.network_service_name,
    d.cluster_name,
    d.rtp
from
    wfm_schema.tx_absen a
    left join (
        select
            absendate,
            userid,
            min(absentime) timein
        from
            wfm_schema.tx_absen
        where
            absentype = true
        group by
            userid,
            absendate
    ) b on a.userid = b.userid
    and a.absendate = b.absendate
    left join (
        select
            absendate,
            userid,
            max(absentime) timeout
        from
            wfm_schema.tx_absen
        where
            absentype = false
        group by
            userid,
            absendate
    ) c on a.userid = c.userid
    and a.absendate = c.absendate
    left join (
        select
            a.ref_user_id,
            a.username,
            a.area_id,
            a.regional_id,
            a.ns_id,
            b.network_service_name,
            a.cluster_id,
            c.cluster_name,
            a.rtp
        from
            wfm_schema.tx_user_management a
            left join wfm_schema.tm_network_service b on a.ns_id = b.network_service_id
            left join wfm_schema.tm_cluster c on a.cluster_id = c.cluster_id
        where
            a.is_active = true
    ) d on a.userid = d.ref_user_id
group by
    a.absendate,
    a.userid,
    b.timein,
    c.timeout,
    d.username,
    d.area_id,
    d.regional_id,
    d.network_service_name,
    d.cluster_name,
    d.rtp
order by
    a.absendate desc;

-- Create user mobile management
CREATE TABLE wfm_schema.tx_user_mobile_management (
    tx_user_mobile_management_id SERIAL PRIMARY KEY,
    username VARCHAR(255),
    email VARCHAR(255),
    user_password VARCHAR(255),
    is_organic BOOLEAN,
    tx_user_management_id INT,
    role_id INT,
    ref_user_id INT,
    partner_id INT,
    description VARCHAR(255),
    created_by VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by VARCHAR(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    deleted_by VARCHAR(255),
    deleted_at TIMESTAMP WITHOUT TIME ZONE,
    is_active BOOLEAN,
    is_delete BOOLEAN,
    employee_name VARCHAR(255),
    area_id VARCHAR(5),
    regional_id VARCHAR(5),
    ns_id VARCHAR(30),
    cluster_id INT,
    deviceid VARCHAR(255),
    rtp VARCHAR(255)
) -- Create mapping_user_mobile_role unused
CREATE TABLE wfm_schema.mapping_user_mobile_role (
    mapping_user_mobile_role_id SERIAL PRIMARY KEY,
    tx_user_management_id INT,
    tx_user_mobile_management_id INT,
    role_id INT,
    ref_user_id INT,
    role_name VARCHAR(255),
    role_code VARCHAR(255)
) -- Create mapping_user_mobile_role
CREATE TABLE wfm_schema.tm_user_mobile_role (
    tm_user_mobile_role_id SERIAL PRIMARY KEY,
    code varchar(50),
    name varchar(255),
    description varchar(255),
    created_by varchar(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by varchar(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    deleted_by varchar(255),
    deleted_at TIMESTAMP WITHOUT TIME ZONE,
    is_active BOOLEAN,
    is_delete BOOLEAN
) ----------UP PROD 24/10/2023-----------------
CREATE TABLE IF NOT EXISTS wfm_schema.bps_exportpdf_form (
    bps_exportpdf_form_id SERIAL PRIMARY KEY,
    nama_vendor VARCHAR(255),
    job_title VARCHAR(255),
    responsibility_name1 VARCHAR(255),
    responsibility_job_title1 VARCHAR(255),
    responsibility_name2 VARCHAR(255),
    responsibility_job_title2 VARCHAR(255),
    created_by bigint,
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by bigint,
    modified_at time without time zone
) CREATE TABLE IF NOT EXISTS wfm_schema.bps_monitoring (
    bps_monitoring_id SERIAL PRIMARY KEY,
    no_ticket VARCHAR(255),
    status_ticket VARCHAR(255),
    ref_number VARCHAR(255),
    source_ticket VARCHAR(255),
    group_ticket VARCHAR(255),
    mbp_unit VARCHAR(255),
    site_class VARCHAR(255),
    site_id VARCHAR(255),
    site_name VARCHAR(255),
    user_requestor VARCHAR(255),
    role_name VARCHAR(255),
    assignee_name VARCHAR(255),
    cancel_note VARCHAR(255),
    last_alarm_clear VARCHAR(255),
    resolution_category1 VARCHAR(255),
    resolution_category2 VARCHAR(255),
    resolution_category3 VARCHAR(255),
    issue_category VARCHAR(255),
    root_category1 VARCHAR(255),
    root_category2 VARCHAR(255),
    root_category3 VARCHAR(255),
    resolution_action VARCHAR(255),
    user_submiter VARCHAR(255),
    preparation_time TIMESTAMP WITHOUT TIME ZONE,
    approve_time TIMESTAMP WITHOUT TIME ZONE,
    request_time TIMESTAMP WITHOUT TIME ZONE,
    ack_time TIMESTAMP WITHOUT TIME ZONE,
    departure_time TIMESTAMP WITHOUT TIME ZONE,
    arrival_time TIMESTAMP WITHOUT TIME ZONE,
    cancel_time TIMESTAMP WITHOUT TIME ZONE,
    rh_stop_time TIMESTAMP WITHOUT TIME ZONE,
    leave_time TIMESTAMP WITHOUT TIME ZONE,
    submit_time TIMESTAMP WITHOUT TIME ZONE,
    user_approver VARCHAR(255),
    running_hour_start_photo VARCHAR(50),
    running_hour_stop_photo VARCHAR(50),
    kwhphoto_before VARCHAR(50),
    kwhphoto_after VARCHAR(50),
    rectifierphoto_before VARCHAR(50),
    rectifierphoto_after VARCHAR(50),
    btsphoto_before VARCHAR(50),
    btsphoto_after VARCHAR(50),
    created_by bigint,
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by bigint,
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    rh_start_time TIMESTAMP WITHOUT TIME ZONE,
    note VARCHAR(255),
    need_key BOOLEAN,
    kwhmeter BOOLEAN,
    running_hour_start NUMERIC,
    running_hour_stop NUMERIC,
    assignee_id INT,
    note_mobile VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS wfm_schema.ticket_technical_support (
    ticket_technical_support_id SERIAL PRIMARY KEY,
    site_id VARCHAR(25),
    cluster_area VARCHAR(25),
    category VARCHAR(25),
    ticket_subject VARCHAR(50),
    job_details VARCHAR(255),
    job_targets VARCHAR(255),
    sla_start TIMESTAMP WITHOUT TIME ZONE,
    sla_end TIMESTAMP WITHOUT TIME ZONE,
    sla_range VARCHAR(25),
    created_by bigint,
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by bigint,
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    no_ticket UNIQUE VARCHAR(25),
    activity_name VARCHAR(255),
    role_name VARCHAR(255),
    respone_time TIMESTAMP WITHOUT TIME ZONE,
    submit_time TIMESTAMP WITHOUT TIME ZONE,
    user_submitter VARCHAR(255),
    approve_time TIMESTAMP WITHOUT TIME ZONE,
    user_approve VARCHAR(255),
    note VARCHAR(255),
    review VARCHAR(255),
    status VARCHAR(25),
    rootcause1 VARCHAR(255),
    rootcause2 VARCHAR(255),
    rootcause3 VARCHAR(255),
    rootcause_remark VARCHAR(255),
    resolution_action VARCHAR(255),
    pic_id VARCHAR(255),
    pic_name VARCHAR(255),
    description VARCHAR(255),
    name VARCHAR(255),
    issue_category VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS wfm_schema.ticket_technical_support_file (
    ticket_technical_support_file_id SERIAL PRIMARY KEY,
    ticket_technical_support_id INT,
    file_name VARCHAR(255),
    file_uploader VARCHAR(255),
    file_uploader_role VARCHAR(255),
    created_at VARCHAR(255),
    file_sftp_id VARCHAR(255) -- CONSTRAINT ticket_technical_support_file_pkey PRIMARY KEY (ticket_technical_support_file_id),
    -- CONSTRAINT ticket_technical_support_file_ticket_technical_support_id_fkey FOREIGN KEY (ticket_technical_support_id)
    -- REFERENCES wfm_schema.ticket_technical_support (ticket_technical_support_id) MATCH SIMPLE
    -- ON UPDATE NO ACTION
    -- ON DELETE NO ACTION
);

---------------END PROD 24/10/23
-- LAST PROD 29/OCT/23
CREATE TABLE IF NOT EXISTS wfm_schema.ticket_technical_support (
    ticket_technical_support_id INT nextval(
        'wfm_schema.ticket_technical_support_ticket_technical_support_id_seq' :: regclass
    ),
    site_id VARCHAR(25),
    cluster_area VARCHAR(25),
    category VARCHAR(25),
    ticket_subject VARCHAR(50),
    job_details VARCHAR(255),
    job_targets VARCHAR(255),
    sla_start TIMESTAMP WITHOUT TIME ZONE,
    sla_end TIMESTAMP WITHOUT TIME ZONE,
    sla_range VARCHAR(25),
    created_by bigint,
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by bigint,
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    no_ticket VARCHAR(25),
    activity_name VARCHAR(255),
    role_name VARCHAR(255),
    respone_time TIMESTAMP WITHOUT TIME ZONE,
    submit_time TIMESTAMP WITHOUT TIME ZONE,
    user_submitter VARCHAR(255),
    approve_time TIMESTAMP WITHOUT TIME ZONE,
    user_approve VARCHAR(255),
    note VARCHAR(255),
    review VARCHAR(255),
    status VARCHAR(25),
    rootcause1 VARCHAR(255),
    rootcause2 VARCHAR(255),
    rootcause3 VARCHAR(255),
    rootcause_remark VARCHAR(255),
    resolution_action VARCHAR(255),
    pic_id VARCHAR(255),
    pic_name VARCHAR(255),
    description VARCHAR(255),
    name VARCHAR(255),
    issue_category VARCHAR(255),
    is_asset_change BOOLEAN,
    CONSTRAINT ticket_technical_support_pkey PRIMARY KEY (ticket_technical_support_id),
    CONSTRAINT ticket_technical_support_no_ticket_key UNIQUE (no_ticket)
);

CREATE TABLE IF NOT EXISTS wfm_schema.ticket_technical_support_file (
    ticket_technical_support_file_id INT nextval(
        'wfm_schema.ticket_technical_support_file_ticket_technical_support_file_seq' :: regclass
    ),
    ticket_technical_support_id INT,
    file_name VARCHAR(255),
    file_uploader VARCHAR(255),
    file_uploader_role VARCHAR(255),
    created_at VARCHAR(255),
    file_sftp_id VARCHAR(255),
    CONSTRAINT ticket_technical_support_file_pkey PRIMARY KEY (ticket_technical_support_file_id)
);

END;

-- END LAST PROD 29/OCT/23
-- User and role mobile
BEGIN;

CREATE TABLE IF NOT EXISTS wfm_schema.mapping_user_mobile_role (
    mapping_user_mobile_role_id SERIAL PRIMARY KEY,
    tx_user_management_id INT,
    tx_user_mobile_management_id INT,
    role_id INT,
    ref_user_id INT,
    role_name VARCHAR(255),
    role_code VARCHAR(255),
    created_by VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by VARCHAR(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    deleted_by VARCHAR(255),
    deleted_at TIMESTAMP WITHOUT TIME ZONE,
    is_active BOOLEAN,
    is_delete BOOLEAN,
);

-- JSON Structure local var
{ "mapping_user_mobile_role": { "mapping_user_mobile_role_id": 1,
"tx_user_management": 1,
"tx_user_mobile_management_id": 1,
"role_id": 1,
"ref_user_id": 1 } } CREATE TABLE IF NOT EXISTS wfm_schema.tx_user_mobile_management (
    tx_user_mobile_management_id SERIAL PRIMARY KEY,
    username VARCHAR(255),
    email VARCHAR(255),
    user_password VARCHAR(255),
    is_organic BOOLEAN,
    tx_user_management_id INT,
    role_id INT,
    ref_user_id INT,
    partner_id INT,
    description VARCHAR(255),
    created_by VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by VARCHAR(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    deleted_by VARCHAR(255),
    deleted_at TIMESTAMP WITHOUT TIME ZONE,
    is_active BOOLEAN,
    is_delete BOOLEAN,
    employee_name VARCHAR(255),
    area_id VARCHAR(5),
    regional_id VARCHAR(5),
    ns_id VARCHAR(30),
    cluster_id INT,
    deviceid VARCHAR(255),
    rtp VARCHAR(255),
);

END;

-- End user role
-- Asset Safe Guard
CREATE TABLE IF NOT EXISTS wfm_schema.tx_asset_safe_guard (
    asset_safe_guard_id SERIAL PRIMARY KEY,
    no_ticket VARCHAR(25),
    site_id VARCHAR(25),
    nama_penjaga VARCHAR(255),
    phone_num VARCHAR(25),
    type_pengamanan_site_id INT,
    regular_fee INT,
    total_fee INT,
    type_payment VARCHAR(25),
    bank_name VARCHAR(25),
    bank_account VARCHAR(25),
    bank_account_name VARCHAR(25),
    notes VARCHAR(255),
    created_by BIGINT,
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by BIGINT,
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    approve_status VARCHAR(25),
    approver_name VARCHAR(25),
    approve_time TIMESTAMP WITHOUT TIME ZONE,
    review VARCHAR(255),
    --    CONSTRAINT asset_safe_guard_pkey PRIMARY KEY (asset_safe_guard_id),
    --    CONSTRAINT asset_safe_guard_no_ticket_key UNIQUE (no_ticket),
    --    CONSTRAINT asset_safe_guard_type_pengamanan_site_id_fkey FOREIGN KEY (type_pengamanan_site_id)
    --        REFERENCES wfm_schema.tm_type_pengamanan_site (tm_type_pengamanan_site_id) MATCH SIMPLE
    --        ON UPDATE NO ACTION
    --        ON DELETE NO ACTION
) CREATE TABLE IF NOT EXISTS wfm_schema.tx_asset_safe_guard_file (
    asset_safe_guard_file_id SERIAL PRIMARY KEY,
    asset_safe_guard INT,
    file_name VARCHAR(255),
    file_content BYTEA,
    file_sftp_id VARCHAR(50),
    file_category VARCHAR(255)
) -- End Asset Safe Guard
--#################### Migrasi mobile user ####################--
BEGIN;

CREATE TABLE IF NOT EXISTS wfm_schema.tx_user_management (
    tx_user_management_id SERIAL PRIMARY KEY,
    username VARCHAR(255),
    email VARCHAR(255),
    role_id INT,
    is_organic BOOLEAN,
    ref_user_id INT,
    partner_id INT,
    description VARCHAR(255),
    created_by VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by VARCHAR(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    deleted_by VARCHAR(255),
    deleted_at TIMESTAMP WITHOUT TIME ZONE,
    is_active BOOLEAN,
    is_delete BOOLEAN,
    employee_name VARCHAR(255),
    area_id VARCHAR(5),
    regional_id VARCHAR(5),
    ns_id VARCHAR(30),
    cluster_id INT,
    deviceid VARCHAR(255),
    rtp VARCHAR(255),
);

CREATE TABLE IF NOT EXISTS wfm_schema.tx_user_mobile_management (
    tx_user_mobile_management_id SERIAL PRIMARY KEY,
    username VARCHAR(255),
    email VARCHAR(255),
    user_password VARCHAR(255),
    is_organic BOOLEAN,
    tx_user_management_id INT,
    ref_user_id INT,
    ref_user_id_before INT,
    partner_id INT,
    description VARCHAR(255),
    -- New column phone number
    phone_number VARCHAR(25),
    created_by VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by VARCHAR(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    deleted_by VARCHAR(255),
    deleted_at TIMESTAMP WITHOUT TIME ZONE,
    is_active BOOLEAN,
    is_delete BOOLEAN,
    employee_name VARCHAR(255),
    area_id VARCHAR(5),
    regional_id VARCHAR(5),
    ns_id VARCHAR(30),
    cluster_id INT,
    deviceid VARCHAR(255),
    rtp VARCHAR(255),
);

CREATE TABLE IF NOT EXISTS wfm_schema.tx_user_role (
    id SERIAL PRIMARY KEY,
    role_id INT,
    ref_user_id INT,
    description VARCHAR(255),
    created_by VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by VARCHAR(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    deleted_by VARCHAR(255),
    deleted_at TIMESTAMP WITHOUT TIME ZONE,
    is_active BOOLEAN,
    is_delete BOOLEAN,
);

CREATE TABLE IF NOT EXISTS wfm_schema.mapping_user_mobile_role (
    mapping_user_mobile_role_id SERIAL PRIMARY KEY,
    tx_user_mobile_management_id INT,
    role_id INT,
    created_by VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by VARCHAR(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    deleted_by VARCHAR(255),
    deleted_at TIMESTAMP WITHOUT TIME ZONE,
    is_active BOOLEAN,
    is_delete BOOLEAN,
);

END;

--#################### End migration mobile user ####################--
-- 
-- NEW  CGL Imbas Petir --
CREATE TABLE IF NOT EXISTS wfm_schema.tx_cgl (
    tx_cgl_id SERIAL PRIMARY KEY,
    ticket_no VARCHAR(255),
    status VARCHAR(255),
    total_price DECIMAL,
    name VARCHAR(255),
    submit_time TIMESTAMP WITHOUT TIME ZONE,
    tower_height DECIMAL,
    site_id VARCHAR(255),
    site_name VARCHAR(255),
    building_height DECIMAL,
    incident_date TIMESTAMP WITHOUT TIME ZONE,
    total_resident INT,
    boq_file_name VARCHAR(255),
    boq_file BYTEA,
    boq_file_sftp_id VARCHAR(255),
    isapproveboq BOOLEAN,
    approveboq_at TIMESTAMP WITHOUT TIME ZONE,
    approveboq_by INT,
    isrejectedboq BOOLEAN,
    rejectedboq_at TIMESTAMP WITHOUT TIME ZONE,
    rejectedboq_by INT,
    stw_file_name VARCHAR(255),
    stw_file BYTEA,
    stw_file_sftp_id VARCHAR(255),
    evidence_date TIMESTAMP WITHOUT TIME ZONE,
    bmkg_file_name VARCHAR(255),
    bmkg_file BYTEA,
    bmkg_file_sftp_id VARCHAR(255),
    request_user VARCHAR(255),
    request_date TIMESTAMP WITHOUT TIME ZONE,
    jumlah_barang_terverifikaksi INT,
    spi_number VARCHAR(255),
    spi_file_name VARCHAR(255),
    spi_file BYTEA,
    spi_file_sftp_id VARCHAR(255),
    spph_file_name VARCHAR(255),
    spph_file BYTEA,
    spph_file_sftp_id VARCHAR(255),
    daisy_number VARCHAR(255),
    daisy_file_name VARCHAR(255),
    daisy_file BYTEA,
    daisy_file_sftp_id VARCHAR(255),
    sph_file_name VARCHAR(255),
    sph_file BYTEA,
    sph_file_sftp_id VARCHAR(255),
    ba_kesepakatan_negosiasi_file_name VARCHAR(255),
    ba_kesepakatan_negosiasi_file BYTEA,
    ba_kesepakatan_negosiasi_file_sftp_id VARCHAR(255),
    nodin_number VARCHAR(255),
    nodin_file_name VARCHAR(255),
    nodin_file BYTEA,
    nodin_file_sftp_id VARCHAR(255),
    notes TEXT,
    cluster_area VARCHAR(255),
    iscommcase BOOLEAN,
    isverify BOOLEAN,
    verifiy_at TIMESTAMP WITHOUT TIME ZONE,
    verifiy_by INT,
    isapprovenop BOOLEAN,
    approvenop_at TIMESTAMP WITHOUT TIME ZONE,
    approvenop_by INT,
    isapprovensmgr BOOLEAN,
    approvensmgr_at TIMESTAMP WITHOUT TIME ZONE,
    approvensmgr_by INT,
    isapprovenosmgr BOOLEAN,
    approvenosmgr_at TIMESTAMP WITHOUT TIME ZONE,
    approvenosmgr_by INT,
    is_submitted BOOLEAN,
    submitted_by INT,
    is_rejected BOOLEAN,
    rejected_by INT,
    keterangan_commcase VARCHAR(255),
    created_by VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by VARCHAR(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS wfm_schema.tx_cgl_tower_olo (
    tx_cgl_olo_id SERIAL PRIMARY KEY,
    ticket_no VARCHAR(255),
    tower_name VARCHAR(255),
    operator VARCHAR(255),
    foto_rumah BYTEA,
    foto_rumah_sftp_id VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS wfm_schema.tx_cgl_tower_grounding_site (
    tx_cgl_grounding_site_id SERIAL PRIMARY KEY,
    ticket_no VARCHAR(255),
    label VARCHAR(255),
    nilai_pengukuran DECIMAL,
    status_grounding VARCHAR(255),
    foto_rumah BYTEA,
    foto_rumah_sftp_id VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS wfm_schema.tx_cgl_residents_data_warga (
    tx_cgl_residents_data_warga_id SERIAL PRIMARY KEY,
    ticket_no VARCHAR(255),
    nama_warga VARCHAR(255),
    no_ktp VARCHAR(255),
    no_kk VARCHAR(255),
    alamat TEXT,
    koordinate_rumah TEXT,
    distance_status VARCHAR(255),
    distance_to_site_m VARCHAR(255),
    document_report_file_name VARCHAR(255),
    document_report_file BYTEA,
    document_report_file_sftp_id VARCHAR(255),
    document_ba_investigation_file_name VARCHAR(255),
    document_ba_investigation_file BYTEA,
    document_ba_investigation_file_sftp_id VARCHAR(255),
    report_date TIMESTAMP WITHOUT TIME ZONE,
    jumlah_barang INT,
    price_estimation DECIMAL,
    foto_rumah BYTEA,
    foto_rumah_sftp_id VARCHAR(255),
    foto_ktp BYTEA,
    foto_ktp_sftp_id VARCHAR(255),
    foto_kk BYTEA,
    foto_kk_sftp_id VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS wfm_schema.tx_cgl_residents_barang (
    tx_cgl_residents_barang_id SERIAL PRIMARY KEY,
    tx_cgl_residents_data_warga_id INT,
    pemilik VARCHAR(255),
    ticket_no VARCHAR(255),
    kode_barang VARCHAR(255),
    label VARCHAR(255),
    deskripsi_barang VARCHAR(255),
    nomor_part VARCHAR(255),
    nomor_serial VARCHAR(255),
    foto_barang BYTEA,
    foto_barang_sftp_id VARCHAR(255),
    claim_action VARCHAR(255),
    status VARCHAR(255),
    qty INT,
    estimation_price DECIMAL,
    approved_price DECIMAL,
    total_price DECIMAL,
    tm_catalogue_brand_id INT,
    tm_catalogue_brand_item_id INT,
    tm_catalogue_brand_type_id INT,
    tm_catalogue_brand_size_id INT
);

CREATE TABLE IF NOT EXISTS wfm_schema.tx_cgl_operational_fee (
    tx_cgl_operational_fee_id SERIAL PRIMARY KEY,
    ticket_no VARCHAR(255),
    item_description VARCHAR(255),
    qty INT,
    price DECIMAL,
    fee DECIMAL,
    total DECIMAL
);

-- CREATE TABLE IF NOT EXISTS wfm_schema.tx_cgl_olo (
--     tx_cgl_olo_id SERIAL PRIMARY KEY,
--     ticket_no VARCHAR(255),
--     tower_name VARCHAR(255),
--     operator VARCHAR(255),
--     foto_rumah BYTEA
-- );
CREATE TABLE IF NOT EXISTS wfm_schema.tm_catalogue_brand (
    tm_catalogue_brand_id SERIAL PRIMARY KEY,
    brand_name VARCHAR(255),
    brand_code VARCHAR(255),
    created_by VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by VARCHAR(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS wfm_schema.tm_catalogue_brand_item (
    tm_catalogue_brand_item_id SERIAL PRIMARY KEY,
    item_code VARCHAR(255),
    item_name VARCHAR(255),
    created_by VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by VARCHAR(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS wfm_schema.tm_catalogue_brand_type (
    tm_catalogue_brand_type_id SERIAL PRIMARY KEY,
    tm_catalogue_brand_item_id INT,
    type_code VARCHAR(255),
    type_name VARCHAR(255),
    created_by VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by VARCHAR(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS wfm_schema.tm_catalogue_brand_size (
    tm_catalogue_brand_size_id SERIAL PRIMARY KEY,
    tm_catalogue_brand_item_id INT,
    tm_catalogue_brand_type_id INT,
    size_code VARCHAR(255),
    size_name VARCHAR(255),
    created_by VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by VARCHAR(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE
);

-- CREATE TABLE IF NOT EXISTS wfm_schema.tx_cgl_mobile (
--     tx_cgl_mobile_id SERIAL PRIMARY KEY,
--     ticket_no VARCHAR(255),
--     site_id VARCHAR(255),
--     tower_height DECIMAL,
--     building_height DECIMAL,
--     catatan TEXT,
--     cluster_area VARCHAR(255),
--     incident_date TIMESTAMP WITHOUT TIME ZONE,
--     created_by VARCHAR(255),
--     created_at TIMESTAMP WITHOUT TIME ZONE,
--     modified_by VARCHAR(255),
--     modified_at TIMESTAMP WITHOUT TIME ZONE
-- )
-- 
-- TOWER INFO
-- 
CREATE TABLE wfm_schema.tm_tower_info (
    tower_info_id SERIAL PRIMARY KEY,
    site_id VARCHAR(25),
    tower_type VARCHAR(50),
    tower_height DECIMAL,
    land_type VARCHAR(25),
    building_type VARCHAR(25),
    building_height DECIMAL,
    building_space DECIMAL,
    building_floor DECIMAL,
    building_spot DECIMAL,
    systems VARCHAR(25),
    include_pool VARCHAR(25)
);

-- FROM IPAS
\ COPY wfm_schema.tm_tower_info (
    site_id,
    tower_type,
    tower_height,
    land_type,
    building_type,
    building_height,
    building_space,
    building_floor,
    building_spot,
    systems,
    include_pool
)
FROM
    'C:/Users/23358275/Documents/tower_info rmv id.csv' DELIMITER E '\t' CSV HEADER;

-- 
\ COPY wfm_schema.tm_tower_info (
    site_id,
    tower_type,
    tower_height,
    land_type,
    building_type,
    building_height,
    building_space,
    building_floor,
    building_spot,
    systems,
    include_pool
)
FROM
    'C:/Users/23358275/Documents/tower_info rmv id.csv' DELIMITER ';' CSV HEADER;

CREATE TABLE wfm_schema.tm_file_template (
    tm_file_template_id SERIAL PRIMARY KEY,
    file_name TEXT,
    file_binary BYTEA,
    file_sftp_id VARCHAR(50),
    file_action VARCHAR(25)
);

-- Recap PLN
-- wfm_schema.tx_recap_pln_ticket definition
-- Drop table
-- DROP TABLE wfm_schema.tx_recap_pln_ticket;
CREATE TABLE wfm_schema.tx_recap_pln_ticket (
    tx_ticket_recap_pln_id SERIAL PRIMARY KEY,
    ticket_no varchar(255),
    site_id varchar(50),
    created_by varchar(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by varchar(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    schedule_date TIMESTAMP WITHOUT TIME ZONE,
    actual_date TIMESTAMP WITHOUT TIME ZONE,
    type_power varchar(255),
    type_maintenance varchar(255),
    response_time TIMESTAMP WITHOUT TIME ZONE,
    submmit_at TIMESTAMP WITHOUT TIME ZONE,
    submit_by INT,
    approve_at TIMESTAMP WITHOUT TIME ZONE,
    approve_by INT,
    start_period_at TIMESTAMP WITHOUT TIME ZONE,
    end_period_at TIMESTAMP WITHOUT TIME ZONE,
    note varchar(255),
    status varchar(255),
    pic_id varchar(255),
    pic_name varchar(255),
    ref_ticket_no varchar(255)
);

CREATE TABLE wfm_schema.tx_recap_pln (
    tx_recap_pln_id SERIAL PRIMARY KEY,
    ticket_no varchar(255),
    site_id varchar(50),
    asset_terdapat_di_site varchar(50),
    asset_terpasang varchar(50),
    asset_rusak varchar(50),
    note_asset_rusak text,
    asset_aktif varchar(50),
    asset_dicuri varchar(50),
    tsel_barcode varchar(255),
    nama_asset varchar(255),
    merk_asset varchar(255),
    category_asset varchar(255),
    serial_number varchar(255),
    asset_owner varchar(255),
    status varchar(255),
    foto_dekat_tagging bytea,
    foto_dekat_tagging_name varchar(255),
    foto_dekat_tagging_location varchar(255),
    foto_jauh_tagging bytea,
    foto_jauh_tagging_name varchar(255),
    foto_jauh_tagging_location varchar(255),
    foto_dekat_saat_ini bytea,
    foto_dekat_saat_ini_name varchar(255),
    foto_dekat_saat_ini_location varchar(255),
    foto_jauh_saat_ini bytea,
    foto_jauh_saat_ini_name varchar(255),
    foto_jauh_saat_ini_location varchar(255),
    keterangan varchar(255),
    daya_listrik_ipas varchar(50),
    daya_sesuai varchar(50),
    daya_listrik varchar(50),
    foto_daya_listrik bytea,
    foto_daya_listrik_name varchar(255),
    foto_daya_listrik_location varchar(255),
    id_pelanggan_pln_ipas varchar(50),
    foto_id_pelanggan_pln_ipas bytea,
    foto_id_pelanggan_pln_ipas_name varchar(255),
    foto_id_pelanggan_pln_ipas_location varchar(255),
    id_pelanggan_sesuai varchar(50),
    id_pelanggan_terbaca varchar(50),
    id_pelanggan_pln varchar(50),
    foto_id_pelanggan_pln bytea,
    foto_id_pelanggan_pln_name varchar(255),
    foto_id_pelanggan_pln_location varchar(255),
    id_pelanggan_pln_perubahan varchar(50),
    foto_id_pelanggan_pln_perubahan bytea,
    foto_id_pelanggan_pln_perubahan_name varchar(255),
    foto_id_pelanggan_pln_perubahan_location varchar(255),
    sumber_catuan varchar(255),
    pengukuran_kwh_bulan_lalu numeric(8, 2),
    foto_pengukuran_kwh_bulan_lalu bytea,
    foto_pengukuran_kwh_bulan_lalu_name varchar(255),
    foto_pengukuran_kwh_bulan_lalu_location varchar(255),
    pengukuran_kwh_bulan_sekarang numeric(8, 2),
    foto_pengukuran_kwh_bulan_sekarang bytea,
    foto_pengukuran_kwh_bulan_sekarang_name varchar(255),
    foto_pengukuran_kwh_bulan_sekarang_location varchar(255),
    durasi_pengukuran_lalu_sekarang INT,
    sistem_tegangan numeric(8, 2),
    no_laporan varchar(255),
    foto_laporan bytea,
    foto_laporan_name varchar(255),
    foto_laporan_location varchar(255),
    schedule_date TIMESTAMP WITHOUT TIME ZONE,
    actual_date TIMESTAMP WITHOUT TIME ZONE,
    score DECIMAL,
    site_operator VARCHAR(255),
    type_power VARCHAR(255),
    type_maintenance VARCHAR(255),
    maintenance VARCHAR(100),
    rtp VARCHAR(255),
    response_time TIMESTAMP WITHOUT TIME ZONE,
    submmit_at TIMESTAMP WITHOUT TIME ZONE,
    submit_by INT,
    approve_at TIMESTAMP WITHOUT TIME ZONE,
    approve_by INT,
    start_period_at TIMESTAMP WITHOUT TIME ZONE,
    end_period_at TIMESTAMP WITHOUT TIME ZONE,
    note varchar(255),
    pic_id varchar(255),
    pic_name varchar(255),
    ref_ticket_no varchar(255),
    created_by VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by VARCHAR(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    deleted_by varchar(255),
    deleted_at TIMESTAMP WITHOUT TIME ZONE,
    is_active BOOLEAN,
    is_delete BOOLEAN,
    -- 
    -- unused
    panel_distribusi_utama varchar(50),
    cek_kabel varchar(50),
    cek_kabel_keterangan varchar(255),
    cek_baut_terminal varchar(50),
    cek_baut_terminal_keterangan varchar(255),
    cek_baut_mcb varchar(50),
    cek_baut_mcb_keterangan varchar(255),
    lampu_indikator_rst varchar(50),
    lampu_indikator_rst_keterangan varchar(255),
    cos_genset varchar(50),
    cos_genset_keterangan varchar(255),
    foto_checkpanel_distribusi_utama bytea,
    foto_checkpanel_distribusi_utama_name varchar(255),
    foto_checkpanel_distribusi_utama_location varchar(255),
    teg_phase_rn numeric(10, 2),
    foto_teg_phase_rn bytea,
    foto_teg_phase_rn_name varchar(255),
    foto_teg_phase_rn_location varchar(255),
    teg_phase_sn numeric(10, 2),
    foto_teg_phase_sn bytea,
    foto_teg_phase_sn_name varchar(255),
    foto_teg_phase_sn_location varchar(255),
    teg_phase_tn numeric(10, 2),
    foto_teg_phase_tn bytea,
    foto_teg_phase_tn_name varchar(255),
    foto_teg_phase_tn_location varchar(255),
    teg_phase_rt numeric(10, 2),
    foto_teg_phase_rt bytea,
    foto_teg_phase_rt_name varchar(255),
    foto_teg_phase_rt_location varchar(255),
    teg_phase_st numeric(10, 2),
    foto_teg_phase_st bytea,
    foto_teg_phase_st_name varchar(255),
    foto_teg_phase_st_location varchar(255),
    teg_phase_rs numeric(10, 2),
    foto_teg_phase_rs bytea,
    foto_teg_phase_rs_name varchar(255),
    foto_teg_phase_rs_location varchar(255),
    teg_phase_gn numeric(10, 2),
    foto_teg_phase_gn bytea,
    foto_teg_phase_gn_name varchar(255),
    foto_teg_phase_gn_location varchar(255),
    total_arus_phase_r numeric(10, 2),
    foto_total_arus_phase_r bytea,
    foto_total_arus_phase_r_name varchar(255),
    foto_total_arus_phase_r_location varchar(255),
    total_arus_phase_s numeric(10, 2),
    foto_total_arus_phase_s bytea,
    foto_total_arus_phase_s_name varchar(255),
    foto_total_arus_phase_s_location varchar(255),
    total_arus_phase_t numeric(10, 2),
    foto_total_arus_phase_t bytea,
    foto_total_arus_phase_t_name varchar(255),
    foto_total_arus_phase_t_location varchar(255),
    total_arus_frek numeric(10, 2),
    foto_total_arus_frek bytea,
    foto_total_arus_frek_name varchar(255),
    foto_total_arus_frek_location varchar(255),
    arester_phase_r varchar(50),
    arester_phase_s varchar(50),
    arester_phase_t varchar(50),
    arester_phase_n varchar(50),
    foto_arester_kwh bytea,
    foto_arester_kwh_name varchar(255),
    foto_arester_kwh_location varchar(255),
    description varchar(255)
);

CREATE TABLE IF NOT EXISTS wfm_schema.tm_power_pln_pelanggan (
    tm_power_pln_pelanggan SERIAL PRIMARY KEY,
    id_pelanggan_nomor VARCHAR(50),
    id_pelanggan_name VARCHAR(255),
    site_id VARCHAR(25),
    area_id VARCHAR(5),
    regional_id VARCHAR(5),
    nop_id VARCHAR(30),
    cluster_id VARCHAR(30),
    jenis_inquiry VARCHAR(100),
    tarif_terpasang VARCHAR(50),
    daya_terpasang VARCHAR(50),
    skema_bayar VARCHAR(100),
    prefix VARCHAR(100),
    wilayah_pln VARCHAR(255),
    area_pln VARCHAR(255),
    status_id_pelanggan VARCHAR(100),
    amr_status VARCHAR(100),
    asset_holder VARCHAR(100),
    denom_prepaid VARCHAR(100),
    status_ttc VARCHAR(100),
    tp_name VARCHAR(100),
    tower_type VARCHAR(100)
);

-- no	area	regional	nop	siteid	prefix	sitename	alamat	koordinat	towerholder	typepmsite	categorysite	idpelnomor	idpelnama	jenissite	jenisbill	tarif	daya	status
CREATE TABLE IF NOT EXISTS wfm_schema.dummy_pln_pelanggan (
    id SERIAL PRIMARY KEY,
    area VARCHAR,
    regional VARCHAR,
    nop VARCHAR,
    siteid VARCHAR,
    prefix VARCHAR,
    sitename VARCHAR,
    alamat VARCHAR,
    koordinat VARCHAR,
    towerholder VARCHAR,
    typepmsite VARCHAR,
    categorysite VARCHAR,
    idpelnomor VARCHAR,
    idpelnama VARCHAR,
    jenissite VARCHAR,
    jenisbill VARCHAR,
    tarif VARCHAR,
    daya VARCHAR,
    status VARCHAR
);

CREATE TABLE IF NOT EXISTS wfm_schema.tx -- 
CREATE TABLE wfm_schema.tx_tagihan_listrik (
    tx_tagihan_listrik_id INT,
    invoice_tp_id INT,
    site_id VARCHAR(100),
    id_kwh INT,
    mitra VARCHAR(100),
    bulan INT,
    tahun INT,
    tgl_request date,
    due_date date,
    meter_awal numeric(8, 2),
    meter_akhir numeric(8, 2),
    jumlah_kwh numeric(8, 2),
    harga_tagihan INT,
    materai INT,
    sub_total INT,
    link_voice_bm VARCHAR(100),
    link_bukti_bayar VARCHAR(100),
    keterangan VARCHAR(100),
    kategori_invoice VARCHAR(100),
    periodic VARCHAR(100),
    no_invoice_bm VARCHAR(100),
    tgl_invoice_bm date,
    tgl_terima_invoice_bm date,
    ppn INT,
    no_faktur_bm VARCHAR(100),
    tg_faktur_bm date,
    pph INT,
    ppj INT,
    tgl_pembayaran date,
    total_tagihan INT,
    wapu VARCHAR(100),
    denda INT,
    deposit INT,
    lebih_bayar INT,
    total_transfer INT,
    tgl_transfer INT,
    ket_mitra VARCHAR(100),
    tgl_reimburse date,
    status VARCHAR(100),
    daya_terpasang VARCHAR(100),
    nominal_per_kwh VARCHAR(100),
    created_by VARCHAR(100),
    created_at timestamp without time zone,
    updated_by VARCHAR(100),
    updated_at timestamp without time zone,
    no_tiket VARCHAR(100),
    bm_id INT,
    bank_name VARCHAR(50),
    bank_acc_name VARCHAR(255),
    is_WAPU boolean,
    attachment_ticket VARCHAR(40),
    Infra_type VARCHAR(20),
    bank_acc VARCHAR(100),
    akses_block boolean,
    putus_listrik boolean,
    attachment_buktibayar VARCHAR(40),
    attachment_kwh VARCHAR(40),
    PIC VARCHAR(100),
    sub_type VARCHAR(20),
    nama_bm VARCHAR(100),
    PIC_for_BM VARCHAR(100),
    id_pelanggan VARCHAR(35),
    kontak_bm VARCHAR(15),
    no_hp VARCHAR(15)
);

-- SVA ASSET LOST
CREATE TABLE IF NOT EXISTS wfm_schema.tx_sva_asset_lost (
    sva_asset_lost_id SERIAL PRIMARY KEY,
    ref_ticket_no VARCHAR(50),
    barcode_number VARCHAR(50),
    photo_dekat_sftp_id VARCHAR(40),
    photo_dekat_name VARCHAR(100),
    photo_jauh_sftp_id VARCHAR(40),
    photo_jauh_name VARCHAR(100),
    photo_dismantle_dekat_sftp_id VARCHAR(40),
    photo_dismantle_dekat_name VARCHAR(100),
    photo_dismantle_jauh_sftp_id VARCHAR(40),
    photo_dismantle_jauh_name VARCHAR(100),
    notes TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE,
    created_by BIGINT,
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    updated_by BIGINT
);

-- ALTER tx_cmsite_header
ALTER TABLE
    wfm_schema.tx_cmsite_header
ADD
    COLUMN service_level VARCHAR(25);

-- TX SITE WAREHOUSE
CREATE TABLE IF NOT EXISTS wfm_schema.tx_site_warehouse (
    site_id VARCHAR(30) PRIMARY KEY NOT NULL,
    code VARCHAR(30),
    name VARCHAR(255),
    active VARCHAR(10),
    type_name VARCHAR(50),
    site_name VARCHAR(255),
    site_address VARCHAR(255),
    area_id VARCHAR(10),
    regional_id VARCHAR(10),
    nop_id VARCHAR(10),
    cluster_id INT
);

CREATE TABLE IF NOT EXISTS wfm_schema.tx_cmsite_assetrelatedactivity_additional (
    tx_cmsite_assetrelatedactivity_additional_id SERIAL PRIMARY KEY,
    tx_cmsite_assetrelated_id BIGINT,
    attachment_sftp_id VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS wfm_schema.tx_cmsite_assetrelatedactivity (
    tx_cmsite_assetrelated_id SERIAL PRIMARY KEY,
    cmsite_header_id BIGINT,
    asset_activity_category_id VARCHAR(30),
    asset_activity_category_name VARCHAR(150),
    created_by VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by VARCHAR(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    deleted_by VARCHAR(255),
    deleted_at TIMESTAMP WITHOUT TIME ZONE,
    is_active boolean,
    is_delete boolean,
    site_as VARCHAR(100),
    site_id VARCHAR(50),
    fpbg_sftp_id VARCHAR(50),
    nodin_sftp_id VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS wfm_schema.tx_cmsite_assetrelatedactivity_additional (
    tx_cmsite_assetrelatedactivity_additional_id SERIAL PRIMARY KEY,
    cmsite_header_id BIGINT,
    tx_cmsite_assetrelated_id BIGINT,
    tx_cmsite_category_additional_key VARCHAR(25),
    attachment_sftp_id VARCHAR(50),
    attachment_file_name TEXT
);

-- wfm_schema.tx_recap_pln definition
-- Drop table
-- DROP TABLE wfm_schema.tx_recap_pln;
CREATE TABLE wfm_schema.tx_recap_pln (
    tx_recap_pln_id serial4 NOT NULL,
    ticket_no varchar(255) NULL,
    site_id varchar(50) NULL,
    asset_terdapat_di_site varchar(50) NULL,
    asset_terpasang varchar(50) NULL,
    asset_rusak varchar(50) NULL,
    note_asset_rusak text NULL,
    asset_aktif varchar(50) NULL,
    asset_dicuri varchar(50) NULL,
    tsel_barcode varchar(255) NULL,
    nama_asset varchar(255) NULL,
    merk_asset varchar(255) NULL,
    category_asset varchar(255) NULL,
    serial_number varchar(255) NULL,
    asset_owner varchar(255) NULL,
    status varchar(255) NULL,
    foto_dekat_tagging bytea NULL,
    foto_dekat_tagging_name varchar(255) NULL,
    foto_dekat_tagging_location varchar(255) NULL,
    foto_jauh_tagging bytea NULL,
    foto_jauh_tagging_name varchar(255) NULL,
    foto_jauh_tagging_location varchar(255) NULL,
    foto_dekat_saat_ini bytea NULL,
    foto_dekat_saat_ini_name varchar(255) NULL,
    foto_dekat_saat_ini_location varchar(255) NULL,
    foto_jauh_saat_ini bytea NULL,
    foto_jauh_saat_ini_name varchar(255) NULL,
    foto_jauh_saat_ini_location varchar(255) NULL,
    keterangan varchar(255) NULL,
    daya_listrik_ipas numeric NULL,
    daya_sesuai varchar(50) NULL,
    daya_listrik numeric NULL,
    foto_daya_listrik bytea NULL,
    foto_daya_listrik_name varchar(255) NULL,
    foto_daya_listrik_location varchar(255) NULL,
    id_pelanggan_pln_ipas varchar(50) NULL,
    foto_id_pelanggan_pln_ipas bytea NULL,
    foto_id_pelanggan_pln_ipas_name varchar(255) NULL,
    foto_id_pelanggan_pln_ipas_location varchar(255) NULL,
    id_pelanggan_sesuai varchar(50) NULL,
    id_pelanggan_terbaca varchar(50) NULL,
    id_pelanggan_pln varchar(50) NULL,
    foto_id_pelanggan_pln bytea NULL,
    foto_id_pelanggan_pln_name varchar(255) NULL,
    foto_id_pelanggan_pln_location varchar(255) NULL,
    id_pelanggan_pln_perubahan varchar(50) NULL,
    foto_id_pelanggan_pln_perubahan bytea NULL,
    foto_id_pelanggan_pln_perubahan_name varchar(255) NULL,
    foto_id_pelanggan_pln_perubahan_location varchar(255) NULL,
    sumber_catuan varchar(255) NULL,
    pengukuran_kwh_bulan_lalu numeric(8, 2) NULL,
    foto_pengukuran_kwh_bulan_lalu bytea NULL,
    foto_pengukuran_kwh_bulan_lalu_name varchar(255) NULL,
    foto_pengukuran_kwh_bulan_lalu_location varchar(255) NULL,
    pengukuran_kwh_bulan_sekarang numeric(8, 2) NULL,
    foto_pengukuran_kwh_bulan_sekarang bytea NULL,
    foto_pengukuran_kwh_bulan_sekarang_name varchar(255) NULL,
    foto_pengukuran_kwh_bulan_sekarang_location varchar(255) NULL,
    durasi_pengukuran_lalu_sekarang int4 NULL,
    sistem_tegangan numeric(8, 2) NULL,
    no_laporan varchar(255) NULL,
    foto_laporan bytea NULL,
    foto_laporan_name varchar(255) NULL,
    foto_laporan_location varchar(255) NULL,
    schedule_date timestamp NULL,
    actual_date timestamp NULL,
    score numeric NULL,
    site_operator varchar(255) NULL,
    type_power varchar(255) NULL,
    type_maintenance varchar(255) NULL,
    maintenance varchar(100) NULL,
    rtp varchar(255) NULL,
    response_time timestamp NULL,
    submmit_at timestamp NULL,
    submit_by int4 NULL,
    approve_at timestamp NULL,
    approve_by int4 NULL,
    start_period_at timestamp NULL,
    end_period_at timestamp NULL,
    note varchar(255) NULL,
    pic_id varchar(255) NULL,
    pic_name varchar(255) NULL,
    ref_ticket_no varchar(255) NULL,
    created_by varchar(255) NULL,
    created_at timestamp NULL,
    modified_by varchar(255) NULL,
    modified_at timestamp NULL,
    deleted_by varchar(255) NULL,
    deleted_at timestamp NULL,
    is_active bool NULL,
    is_delete bool NULL,
    panel_distribusi_utama varchar(50) NULL,
    cek_kabel varchar(50) NULL,
    cek_kabel_keterangan varchar(255) NULL,
    cek_baut_terminal varchar(50) NULL,
    cek_baut_terminal_keterangan varchar(255) NULL,
    cek_baut_mcb varchar(50) NULL,
    cek_baut_mcb_keterangan varchar(255) NULL,
    lampu_indikator_rst varchar(50) NULL,
    lampu_indikator_rst_keterangan varchar(255) NULL,
    cos_genset varchar(50) NULL,
    cos_genset_keterangan varchar(255) NULL,
    foto_checkpanel_distribusi_utama bytea NULL,
    foto_checkpanel_distribusi_utama_name varchar(255) NULL,
    foto_checkpanel_distribusi_utama_location varchar(255) NULL,
    teg_phase_rn numeric(10, 2) NULL,
    foto_teg_phase_rn bytea NULL,
    foto_teg_phase_rn_name varchar(255) NULL,
    foto_teg_phase_rn_location varchar(255) NULL,
    teg_phase_sn numeric(10, 2) NULL,
    foto_teg_phase_sn bytea NULL,
    foto_teg_phase_sn_name varchar(255) NULL,
    foto_teg_phase_sn_location varchar(255) NULL,
    teg_phase_tn numeric(10, 2) NULL,
    foto_teg_phase_tn bytea NULL,
    foto_teg_phase_tn_name varchar(255) NULL,
    foto_teg_phase_tn_location varchar(255) NULL,
    teg_phase_rt numeric(10, 2) NULL,
    foto_teg_phase_rt bytea NULL,
    foto_teg_phase_rt_name varchar(255) NULL,
    foto_teg_phase_rt_location varchar(255) NULL,
    teg_phase_st numeric(10, 2) NULL,
    foto_teg_phase_st bytea NULL,
    foto_teg_phase_st_name varchar(255) NULL,
    foto_teg_phase_st_location varchar(255) NULL,
    teg_phase_rs numeric(10, 2) NULL,
    foto_teg_phase_rs bytea NULL,
    foto_teg_phase_rs_name varchar(255) NULL,
    foto_teg_phase_rs_location varchar(255) NULL,
    teg_phase_gn numeric(10, 2) NULL,
    foto_teg_phase_gn bytea NULL,
    foto_teg_phase_gn_name varchar(255) NULL,
    foto_teg_phase_gn_location varchar(255) NULL,
    total_arus_phase_r numeric(10, 2) NULL,
    foto_total_arus_phase_r bytea NULL,
    foto_total_arus_phase_r_name varchar(255) NULL,
    foto_total_arus_phase_r_location varchar(255) NULL,
    total_arus_phase_s numeric(10, 2) NULL,
    foto_total_arus_phase_s bytea NULL,
    foto_total_arus_phase_s_name varchar(255) NULL,
    foto_total_arus_phase_s_location varchar(255) NULL,
    total_arus_phase_t numeric(10, 2) NULL,
    foto_total_arus_phase_t bytea NULL,
    foto_total_arus_phase_t_name varchar(255) NULL,
    foto_total_arus_phase_t_location varchar(255) NULL,
    total_arus_frek numeric(10, 2) NULL,
    foto_total_arus_frek bytea NULL,
    foto_total_arus_frek_name varchar(255) NULL,
    foto_total_arus_frek_location varchar(255) NULL,
    arester_phase_r varchar(50) NULL,
    arester_phase_s varchar(50) NULL,
    arester_phase_t varchar(50) NULL,
    arester_phase_n varchar(50) NULL,
    foto_arester_kwh bytea NULL,
    foto_arester_kwh_name varchar(255) NULL,
    foto_arester_kwh_location varchar(255) NULL,
    description varchar(255) NULL,
    year_period int4 NULL,
    month_period int4 NULL,
    tm_power_pln_pelanggan_id int4 NULL,
    CONSTRAINT tx_recap_pln_pkey PRIMARY KEY (tx_recap_pln_id)
);

CREATE TABLE wfm_schema.tx_recap_pln (
    tx_recap_pln_id SERIAL PRIMARY KEY,
    tm_power_pln_pelanggan_id INT,
    ticket_no varchar(255),
    ref_ticket_no varchar(255),
    site_id varchar(50),
    asset_terdapat_di_site varchar(50),
    asset_terpasang varchar(50),
    asset_rusak varchar(50),
    note_asset_rusak text,
    asset_aktif varchar(50),
    asset_dicuri varchar(50),
    tsel_barcode varchar(255),
    nama_asset varchar(255),
    merk_asset varchar(255),
    category_asset varchar(255),
    serial_number varchar(255),
    asset_owner varchar(255),
    status varchar(255),
    -- foto_dekat_tagging BYTEA,
    foto_dekat_tagging_name varchar(255),
    foto_dekat_tagging_guuid varchar(255),
    -- foto_jauh_tagging BYTEA,
    foto_jauh_tagging_name varchar(255),
    foto_jauh_tagging_guuid varchar(255),
    -- foto_dekat_saat_ini BYTEA,
    foto_dekat_saat_ini_name varchar(255),
    foto_dekat_saat_ini_guuid varchar(255),
    -- foto_jauh_saat_ini BYTEA,
    foto_jauh_saat_ini_name varchar(255),
    foto_jauh_saat_ini_guuid varchar(255),
    keterangan varchar(255),
    daya_listrik_master numeric,
    daya_sesuai varchar(50),
    daya_listrik numeric,
    -- foto_daya_listrik BYTEA,
    foto_daya_listrik_name varchar(255),
    foto_daya_listrik_guuid varchar(255),
    id_pelanggan_pln_master varchar(50),
    -- foto_id_pelanggan_pln_master BYTEA,
    foto_id_pelanggan_pln_master_name varchar(255),
    foto_id_pelanggan_pln_master_guuid varchar(255),
    id_pelanggan_sesuai varchar(50),
    id_pelanggan_terbaca varchar(50),
    id_pelanggan_pln varchar(50),
    -- foto_id_pelanggan_pln BYTEA,
    foto_id_pelanggan_pln_name varchar(255),
    foto_id_pelanggan_pln_guuid varchar(255),
    sumber_catuan varchar(255),
    pengukuran_kwh_bulan_lalu numeric(8, 2),
    -- foto_pengukuran_kwh_bulan_lalu BYTEA,
    foto_pengukuran_kwh_bulan_lalu_name varchar(255),
    foto_pengukuran_kwh_bulan_lalu_guuid varchar(255),
    pengukuran_kwh_bulan_sekarang numeric(8, 2),
    -- foto_pengukuran_kwh_bulan_sekarang BYTEA,
    foto_pengukuran_kwh_bulan_sekarang_name varchar(255),
    foto_pengukuran_kwh_bulan_sekarang_guuid varchar(255),
    durasi_pengukuran_lalu_sekarang INT,
    sistem_tegangan numeric(8, 2),
    laporan_by INT,
    laporan_at TIMESTAMP WITHOUT TIME ZONE,
    laporan_via_mobile BOOLEAN,
    no_laporan varchar(255),
    -- foto_laporan BYTEA,
    foto_laporan_name varchar(255),
    foto_laporan_guuid varchar(255),
    schedule_month INT,
    schedule_year INT,
    actual_date_at TIMESTAMP WITHOUT TIME ZONE,
    response_time_at TIMESTAMP WITHOUT TIME ZONE,
    submmit_at TIMESTAMP WITHOUT TIME ZONE,
    submit_by INT,
    is_approve BOOLEAN,
    approve_at TIMESTAMP WITHOUT TIME ZONE,
    approve_by INT,
    start_period_at TIMESTAMP WITHOUT TIME ZONE,
    end_period_at TIMESTAMP WITHOUT TIME ZONE,
    month_period INT,
    year_period INT,
    pic_id varchar(255),
    pic_name varchar(255),
    note varchar(255),
    created_by varchar(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    is_active bool,
    is_delete bool
);

CREATE TABLE wfm_schema.tx_tagihan_kwh_meter (
    tx_tagihan_kwh_meter_id SERIAL PRIMARY KEY,
    ticket_no VARCHAR(255),
    status VARCHAR(50),
    id_pelanggan VARCHAR(100),
    site_id VARCHAR(25)
);

CREATE TABLE IF NOT EXISTS wfm_schema.tm_anomaly_outlier (
    id_pel_pln VARCHAR(255),
    site_id VARCHAR(255),
    total_anomaly bigint,
    kwh_awal VARCHAR(255),
    kwh_akhir VARCHAR(255),
    kwh_pakai VARCHAR(255),
    rptag VARCHAR(255),
    tagihan VARCHAR(255),
    rptag_ideal VARCHAR(255),
    denda_percent VARCHAR(255),
    flat_kwh VARCHAR(255),
    zero_payment VARCHAR(255),
    fine_payment VARCHAR(255),
    increase_payment VARCHAR(255),
    increase_kwh VARCHAR(255),
    daya_vs_kwh VARCHAR(255),
    periode VARCHAR(255),
    priority VARCHAR(255),
    billing_id VARCHAR(255),
    region_name VARCHAR(255),
    priority_id VARCHAR(255),
    region_id VARCHAR(255)
);

-- NEW TM ANOMALY OUTLIER
CREATE TABLE IF NOT EXISTS wfm_schema.tm_anomaly_outlier (
    ticketid_ipas PRIMARY KEY VARCHAR(255),
    priority VARCHAR(255),
    idpel VARCHAR(255),
    siteid VARCHAR(255),
    periode VARCHAR(255),
    total_anomaly bigint,
    kwh_awal VARCHAR(255),
    kwh_akhir VARCHAR(255),
    kwh_pakai VARCHAR(255),
    rptag VARCHAR(255),
    tagihan VARCHAR(255),
    rptag_ideal VARCHAR(255),
    denda_percent VARCHAR(255),
    flat_kwh VARCHAR(255),
    zero_payment VARCHAR(255),
    fine_payment VARCHAR(255),
    increase_payment VARCHAR(255),
    increase_kwh VARCHAR(255),
    daya_vs_kwh VARCHAR(255),
    region_name VARCHAR(255),
    category_ticket VARCHAR(255),
    status_tiket VARCHAR(255),
    statusticketid VARCHAR(255),
    fmc VARCHAR(255),
    avg_flat_kwh VARCHAR(255),
    avg_Zero_payment VARCHAR(255),
    avg_Daya_vs_kwh VARCHAR(255),
    potensial_costsaving VARCHAR(255),
    potensial_costsaving_daya_group VARCHAR(255),
    dayapln VARCHAR(255),
    billing_id VARCHAR(255)
);

-- New PKM
CREATE TABLE IF NOT EXISTS wfm_schema.tx_recap_pln (
    tx_recap_pln_id SERIAL PRIMARY KEY,
    tm_power_pln_pelanggan_id INT,
    ticket_no VARCHAR(255),
    ref_ticket_no VARCHAR(255),
    site_id VARCHAR(50),
    asset_terdapat_di_site VARCHAR(50),
    asset_terpasang VARCHAR(50),
    asset_rusak VARCHAR(50),
    note_asset_rusak text,
    asset_aktif VARCHAR(50),
    asset_dicuri VARCHAR(50),
    tsel_barcode VARCHAR(255),
    nama_asset VARCHAR(255),
    merk_asset VARCHAR(255),
    category_asset VARCHAR(255),
    serial_number VARCHAR(255),
    asset_owner VARCHAR(255),
    status VARCHAR(255),
    foto_dekat_tagging_name VARCHAR(255),
    foto_dekat_tagging_guuid VARCHAR(255),
    foto_jauh_tagging_name VARCHAR(255),
    foto_jauh_tagging_guuid VARCHAR(255),
    foto_dekat_saat_ini_name VARCHAR(255),
    foto_dekat_saat_ini_guuid VARCHAR(255),
    foto_jauh_saat_ini_name VARCHAR(255),
    foto_jauh_saat_ini_guuid VARCHAR(255),
    keterangan VARCHAR(255),
    daya_listrik_master numeric,
    daya_sesuai VARCHAR(50),
    daya_listrik numeric,
    foto_daya_listrik_name VARCHAR(255),
    foto_daya_listrik_guuid VARCHAR(255),
    id_pelanggan_pln_master VARCHAR(50),
    foto_id_pelanggan_pln_master_name VARCHAR(255),
    foto_id_pelanggan_pln_master_guuid VARCHAR(255),
    id_pelanggan_sesuai VARCHAR(50),
    id_pelanggan_terbaca VARCHAR(50),
    id_pelanggan_pln VARCHAR(50),
    foto_id_pelanggan_pln_name VARCHAR(255),
    foto_id_pelanggan_pln_guuid VARCHAR(255),
    sumber_catuan VARCHAR(255),
    pengukuran_kwh numeric(8, 2),
    foto_pengukuran_kwh_name VARCHAR(255),
    foto_pengukuran_kwh_guuid VARCHAR(255),
    durasi_pengukuran_lalu_sekarang INT,
    sistem_tegangan numeric(8, 2),
    laporan_by INT,
    laporan_at timestamp without time zone,
    laporan_via VARCHAR(50),
    no_laporan VARCHAR(255),
    foto_laporan_name VARCHAR(255),
    foto_laporan_guuid VARCHAR(255),
    actual_date_at timestamp without time zone,
    response_time_at timestamp without time zone,
    submmit_at timestamp without time zone,
    submit_by INT,
    is_approve boolean,
    approve_at timestamp without time zone,
    approve_by INT,
    start_period_at date,
    end_period_at date,
    year_period INT,
    pic_id INT,
    pic_name VARCHAR(255),
    note VARCHAR(255),
    created_by INT,
    created_at timestamp without time zone,
    is_active boolean,
    is_delete boolean,
    flag_period VARCHAR(25),
    is_has_schedule boolean,
    month_schedule INT,
    year_schedule INT,
    date_schedule date,
    is_has_release boolean
);

CREATE TABLE wfm_schema.tx_pengisian_token_listrik (
    tx_pengisian_token_listrik_id SERIAL PRIMARY KEY,
    ref_ticket_no VARCHAR(255),
    ref_ticket_no_last VARCHAR(150),
    id_pelanggan VARCHAR(50),
    id_pelanggan_name VARCHAR(255),
    billing_id VARCHAR(100),
    no_token VARCHAR(50),
    kwh_token NUMERIC(12, 2),
    daya VARCHAR(50),
    status_pengisian_token VARCHAR(100),
    foto_evidence_guuid VARCHAR(255),
    note TEXT,
    bulan INT,
    tahun INT,
    daya_terpasang VARCHAR(50),
    kwh_sebelum_pengisian NUMERIC(15, 2),
    foto_kwh_sebelum_pengisian_guuid VARCHAR(255),
    kwh_setelah_pengisian NUMERIC(15, 2),
    foto_kwh_setelah_pengisian_guuid VARCHAR(255),
    tanggal_pengisian TIMESTAMP WITHOUT TIME ZONE,
    selisih_hari INT,
    pemakaian_kwh_perhari NUMERIC(12, 2),
    estimasi_pengisian_selanjutnya TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE wfm_schema.tx_pengisian_token_listrik_header (
    tx_pengisian_token_listrik_header_id SERIAL PRIMARY KEY,
    ticket_no VARCHAR(255),
    id_pelanggan VARCHAR(50),
    site_id VARCHAR(25),
    status VARCHAR(100),
    created_by INT,
    created_at TIMESTAMP WITHOUT TIME ZONE,
    response_by INT,
    response_at TIMESTAMP WITHOUT TIME ZONE,
    submitted_by INT,
    submitted_at TIMESTAMP WITHOUT TIME ZONE,
    approved_by INT,
    approved_at TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS wfm_schema.tm_all_tagihan_listrik (
    tm_all_tagihan_listrik_id SERIAL primary key,
    idpel varchar(255),
    pelname varchar(255),
    goltarif varchar(255),
    daya varchar(255),
    billtype varchar(255),
    siteid varchar(255),
    towerprovider varchar(255),
    periode varchar(255),
    status varchar(255),
    billstatus varchar(255),
    kwhawal varchar(255),
    kwhakhir varchar(255),
    kwhpakai varchar(255),
    tagihan varchar(255),
    pathevidence varchar(255),
    token varchar(255)
);

ALTER TABLE
    wfm_schema.tx_recap_pln
ADD
    COLUMN teg_phase_rn numeric(10, 2),
ADD
    COLUMN foto_teg_phase_rn_name varchar(255),
ADD
    COLUMN foto_teg_phase_rn_guuid varchar(255),
ADD
    COLUMN teg_phase_sn numeric(10, 2),
ADD
    COLUMN foto_teg_phase_sn_name varchar(255),
ADD
    COLUMN foto_teg_phase_sn_guuid varchar(255),
ADD
    COLUMN teg_phase_tn numeric(10, 2),
ADD
    COLUMN foto_teg_phase_tn_name varchar(255),
ADD
    COLUMN foto_teg_phase_tn_guuid varchar(255),
ADD
    COLUMN teg_phase_rt numeric(10, 2),
ADD
    COLUMN foto_teg_phase_rt_name varchar(255),
ADD
    COLUMN foto_teg_phase_rt_guuid varchar(255),
ADD
    COLUMN teg_phase_st numeric(10, 2),
ADD
    COLUMN foto_teg_phase_st_name varchar(255),
ADD
    COLUMN foto_teg_phase_st_guuid varchar(255),
ADD
    COLUMN teg_phase_rs numeric(10, 2),
ADD
    COLUMN foto_teg_phase_rs_name varchar(255),
ADD
    COLUMN foto_teg_phase_rs_guuid varchar(255),
ADD
    COLUMN teg_phase_gn numeric(10, 2),
ADD
    COLUMN foto_teg_phase_gn_name varchar(255),
ADD
    COLUMN foto_teg_phase_gn_guuid varchar(255),
ADD
    COLUMN total_arus_phase_r numeric(10, 2),
ADD
    COLUMN foto_total_arus_phase_r_name varchar(255),
ADD
    COLUMN foto_total_arus_phase_r_guuid varchar(255),
ADD
    COLUMN total_arus_phase_s numeric(10, 2),
ADD
    COLUMN foto_total_arus_phase_s_name varchar(255),
ADD
    COLUMN foto_total_arus_phase_s_guuid varchar(255),
ADD
    COLUMN total_arus_phase_t numeric(10, 2),
ADD
    COLUMN foto_total_arus_phase_t_name varchar(255),
ADD
    COLUMN foto_total_arus_phase_t_guuid varchar(255),
ADD
    COLUMN total_arus_frek numeric(10, 2),
ADD
    COLUMN foto_total_arus_frek_name varchar(255),
ADD
    COLUMN foto_total_arus_frek_guuid varchar(255) CREATE TABLE wfm_schema.tm_power_pln_pelanggan (
        tm_power_pln_pelanggan_id SERIAL PRIMARY KEY,
        id_pelanggan_nomor varchar(50),
        id_pelanggan_name varchar(255),
        site_id varchar(25),
        jenis_inquiry varchar(100),
        tarif_terpasang varchar(50),
        daya_terpasang varchar(50),
        skema_bayar varchar(100),
        wilayah_pln varchar(255),
        area_pln varchar(255),
        status_id_pelanggan varchar(100),
        amr_status varchar(100),
        asset_holder varchar(100),
        denom_prepaid varchar(100),
        status_ttc varchar(100),
        tp_name varchar(100),
        tower_type varchar(100),
        is_delete bool,
        gol_tarif varchar(255),
        daya varchar(50),
        bill_type varchar(50),
        plafond varchar(255),
        status_site varchar(100),
        tower varchar(100),
        tx_request_powerid BIGINT,
        tm_powerid BIGINT,
        bill_responsibility varchar(100),
        site_owner varchar(255)
    );

-- wfm_schema.vw_ticket_technical_support source
CREATE
OR REPLACE VIEW wfm_schema.vw_ticket_technical_support AS
SELECT
    tts.no_ticket,
    tts.site_id,
    ts.site_name,
    tts.cluster_area,
    tma.area_name,
    tmr.regional_name,
    tmn.nop_name,
    tmc.cluster_name,
    tts.category,
    tts.ticket_subject,
    tts.job_details,
    tts.job_targets,
    CASE
        WHEN EXTRACT(
            YEAR
            FROM
                tts.submit_time
        ) = 1900 THEN 'IN SLA'
        WHEN tts.submit_time > tts.sla_end THEN 'OUT SLA'
        ELSE 'IN SLA'
    END AS sla,
    tts.sla_start,
    tts.sla_end,
    tts.sla_range,
    tts.created_by,
    tts.created_at,
    tts.modified_by,
    tts.modified_at,
    tts.no_ticket,
    tts.activity_name,
    tts.role_name,
    tts.respone_time,
    tts.submit_time,
    tts.user_submitter,
    tts.approve_time,
    tts.user_approve,
    tts.note,
    tts.review,
    tts.status,
    tts.rootcause1,
    tts.rootcause2,
    tts.rootcause3,
    tts.rootcause_remark,
    tts.resolution_action,
    tts.pic_id,
    tts.pic_name,
    tts.description,
    tts.name,
    tts.issue_category,
    tts.is_asset_change,
    tts.take_over_at,
    tts.checkin_at,
    string_agg(DISTINCT tmur.name :: text, ', ' :: text) AS created_role_name
FROM
    wfm_schema.ticket_technical_support tts
    LEFT JOIN wfm_schema.tx_user_role txur ON tts.created_by = txur.ref_user_id
    LEFT JOIN wfm_schema.tm_user_role tmur ON txur.role_id = tmur.tm_user_role_id
    INNER JOIN wfm_schema.tx_site ts ON tts.site_id = ts.site_id
    LEFT JOIN wfm_schema.tm_area tma ON ts.area_id = tma.area_id
    LEFT JOIN wfm_schema.tm_regional tmr ON ts.regional_id = tmr.regional_id
    LEFT JOIN wfm_schema.tm_nop tmn ON ts.nop_id = tmn.nop_id
    LEFT JOIN wfm_schema.tm_cluster tmc ON ts.cluster_id = tmc.cluster_id
WHERE
    tts.is_exclude = false
GROUP BY
    tts.ticket_technical_support_id,
    ts.site_id,
    tma.area_id,
    tmr.regional_id,
    tmn.nop_id,
    tmc.cluster_id;

SELECT
    tts.no_ticket,
    tts.site_id,
    ts.site_name,
    tts.cluster_area,
    tma.area_name,
    tmr.regional_name,
    tmn.nop_name,
    tmc.cluster_name,
    tts.category,
    tts.ticket_subject,
    tts.job_details,
    tts.job_targets,
    CASE
        WHEN EXTRACT(
            YEAR
            FROM
                tts.submit_time
        ) = 1900 THEN 'IN SLA'
        WHEN tts.submit_time > tts.sla_end THEN 'OUT SLA'
        ELSE 'IN SLA'
    END AS sla,
    tts.sla_start,
    tts.sla_end,
    tts.sla_range,
    tts.created_by,
    tts.created_at,
    tts.modified_by,
    tts.modified_at,
    tts.no_ticket,
    tts.activity_name,
    tts.role_name,
    tts.respone_time,
    tts.submit_time,
    tts.user_submitter,
    tts.approve_time,
    tts.user_approve,
    tts.note,
    tts.review,
    tts.status,
    tts.rootcause1,
    tts.rootcause2,
    tts.rootcause3,
    tts.rootcause_remark,
    tts.resolution_action,
    tts.pic_id,
    tts.pic_name,
    tts.description,
    tts.name,
    tts.issue_category,
    tts.is_asset_change,
    tts.take_over_at,
    tts.checkin_at,
    string_agg(DISTINCT tmur.name :: text, ', ' :: text) AS created_role_name
FROM
    { ticket_technical_support } tts
    LEFT JOIN { tx_user_role } txur ON tts.created_by = txur.ref_user_id
    LEFT JOIN { tm_user_role } tmur ON txur.role_id = tmur.tm_user_role_id
    INNER JOIN { tx_site } ts ON tts.site_id = ts.site_id
    LEFT JOIN { tm_area } tma ON ts.area_id = tma.area_id
    LEFT JOIN { tm_regional } tmr ON ts.regional_id = tmr.regional_id
    LEFT JOIN { tm_nop } tmn ON ts.nop_id = tmn.nop_id
    LEFT JOIN { tm_cluster } tmc ON ts.cluster_id = tmc.cluster_id
WHERE
    tts.is_exclude = false
GROUP BY
    tts.ticket_technical_support_id,
    ts.site_id,
    tma.area_id,
    tmr.regional_id,
    tmn.nop_id,
    tmc.cluster_id;

{ "no_ticket": "tts.no_ticket",
"site_id": "tts.site_id",
"site_name": "ts.site_name",
"cluster_area": "tts.cluster_area",
"area_name": "tma.area_name",
"regional_name": "tmr.regional_name",
"nop_name": "tmn.nop_name",
"cluster_name": "tmc.cluster_name",
"category": "tts.category",
"ticket_subject": "tts.ticket_subject",
"job_details": "tts.job_details",
"job_targets": "tts.job_targets",
"sla": "asd",
"sla_start": "tts.sla_start",
"sla_end": "tts.sla_end",
"sla_range": "tts.sla_range",
"created_by": "tts.created_by",
"created_at": "tts.created_at",
"modified_by": "tts.modified_by",
"modified_at": "tts.modified_at",
"no_ticket_duplicated": "tts.no_ticket",
"activity_name": "tts.activity_name",
"role_name": "tts.role_name",
"response_time": "tts.respone_time",
"submit_time": "tts.submit_time",
"user_submitter": "tts.user_submitter",
"approve_time": "tts.approve_time",
"user_approve": "tts.user_approve",
"note": "tts.note",
"review": "tts.review",
"status": "tts.status",
"rootcause1": "tts.rootcause1",
"rootcause2": "tts.rootcause2",
"rootcause3": "tts.rootcause3",
"rootcause_remark": "tts.rootcause_remark",
"resolution_action": "tts.resolution_action",
"pic_id": "tts.pic_id",
"pic_name": "tts.pic_name",
"description": "tts.description",
"name": "tts.name",
"issue_category": "tts.issue_category",
"is_asset_change": "tts.is_asset_change",
"take_over_at": "tts.take_over_at",
"checkin_at": "tts.checkin_at",
"created_role_name": "string_agg(DISTINCT tmur.name :: text, ', ' :: text)" } -- FIXED EXPORT FIELD OPERATION
SELECT
    tts.no_ticket,
    tts.site_id,
    ts.site_name,
    tts.cluster_area,
    tma.area_name,
    tmr.regional_name,
    tmn.nop_name,
    tmc.cluster_name,
    tts.category,
    tts.ticket_subject,
    tts.job_details,
    tts.job_targets,
    CASE
        WHEN EXTRACT(
            YEAR
            FROM
                tts.submit_time
        ) = 1900 THEN 'IN SLA'
        WHEN tts.submit_time > tts.sla_end THEN 'OUT SLA'
        ELSE 'IN SLA'
    END AS sla,
    tts.sla_start,
    tts.sla_end,
    tts.sla_range,
    tts.created_by,
    tts.created_at,
    tts.modified_by,
    tts.modified_at,
    tts.no_ticket,
    tts.activity_name,
    tts.role_name,
    tts.respone_time,
    tts.submit_time,
    tts.user_submitter,
    tts.approve_time,
    tts.user_approve,
    tts.note,
    tts.review,
    tts.status,
    tts.rootcause1,
    tts.rootcause2,
    tts.rootcause3,
    tts.rootcause_remark,
    tts.resolution_action,
    tts.pic_id,
    tts.pic_name,
    tts.description,
    tts.name,
    tts.issue_category,
    tts.is_asset_change,
    tts.take_over_at,
    tts.checkin_at,
    string_agg(DISTINCT tmur.name :: text, ', ' :: text) AS created_role_name
FROM
    { ticket_technical_support } tts
    LEFT JOIN { tx_user_role } txur ON tts.created_by = txur.ref_user_id
    LEFT JOIN { tm_user_role } tmur ON txur.role_id = tmur.tm_user_role_id
    INNER JOIN { tx_site } ts ON tts.site_id = ts.site_id
    LEFT JOIN { tm_area } tma ON ts.area_id = tma.area_id
    LEFT JOIN { tm_regional } tmr ON ts.regional_id = tmr.regional_id
    LEFT JOIN { tm_nop } tmn ON ts.nop_id = tmn.nop_id
    LEFT JOIN { tm_cluster } tmc ON ts.cluster_id = tmc.cluster_id
WHERE
    tts.is_exclude = false
GROUP BY
    tts.ticket_technical_support_id,
    ts.site_id,
    tma.area_id,
    tmr.regional_id,
    tmn.nop_id,
    tmc.cluster_id;

-- 
CREATE TABLE wfm_schema.tx_pengisian_token_listrik_header (
    tx_pengisian_token_listrik_header_id SERIAL PRIMARY KEY,
    ticket_no varchar(100),
    ref_ticket_no_last varchar(100),
    ticket_ipas_id varchar(100),
    id_pelanggan varchar(50),
    id_pelanggan_name varchar(100),
    site_id varchar(25),
    status varchar(100),
    bulan INT,
    tahun INT,
    kwh_awal numeric(15, 2),
    kwh_akhir numeric(15, 2),
    tanggal_pengisian TIMESTAMP WITHOUT TIME ZONE,
    tanggal_pengisian_terakhir TIMESTAMP WITHOUT TIME ZONE,
    selisih_hari INT,
    pemakaian_kwh_perhari numeric(15, 2),
    estimasi_pengisian_selanjutnya TIMESTAMP WITHOUT TIME ZONE,
    total_kwh_token numeric(15, 2),
    total_kwh_token_terakhir numeric(15, 2),
    total_denom_prepaid BIGINT,
    daya_terpasang varchar(50),
    created_by INT,
    created_at TIMESTAMP WITHOUT TIME ZONE,
    take_over_by INT,
    take_over_at TIMESTAMP WITHOUT TIME ZONE,
    request_permit_by INT,
    request_permit_at TIMESTAMP WITHOUT TIME ZONE,
    follow_up_by INT,
    follow_up_at TIMESTAMP WITHOUT TIME ZONE,
    checkin_by INT,
    checkin_at TIMESTAMP WITHOUT TIME ZONE,
    submitted_by INT,
    submitted_at TIMESTAMP WITHOUT TIME ZONE,
    approved_by INT,
    approved_at TIMESTAMP WITHOUT TIME ZONE,
    acknowledge_nop_by INT,
    acknowledge_nop_at TIMESTAMP WITHOUT TIME ZONE,
    acknowledge_nos_name varchar(255),
    acknowledge_nos_at TIMESTAMP WITHOUT TIME ZONE,
    created_name varchar(150),
    take_over_name varchar(150),
    request_permit_name varchar(150),
    follow_up_name varchar(150),
    checkin_name varchar(150),
    submitted_name varchar(150),
    approved_name varchar(150),
    acknowledge_nop_name varchar(150)
) -- 
CREATE TABLE wfm_schema.tx_pengisian_token_listrik (
    tx_pengisian_token_listrik_id SERIAL PRIMARY KEY,
    ref_ticket_no varchar(100),
    id_pelanggan varchar(50),
    billing_id varchar(100),
    no_token varchar(50),
    kwh_token numeric(15, 2),
    denom_prepaid BIGINT,
    daya varchar(50),
    status_pengisian_token varchar(100),
    foto_evidence_guuid varchar(255),
    note text,
    kwh_sebelum_pengisian numeric(15, 2),
    foto_kwh_sebelum_pengisian_guuid varchar(255),
    kwh_setelah_pengisian numeric(15, 2),
    foto_kwh_setelah_pengisian_guuid varchar(255)
);

-- wfm_schema.tx_pengisian_token_listrik_header definition
-- Drop table
-- DROP TABLE wfm_schema.tx_pengisian_token_listrik_header;
CREATE TABLE wfm_schema.tx_pengisian_token_listrik_header (
    tx_pengisian_token_listrik_header_id SERIAL PRIMARY KEY,
    ticket_no varchar(100),
    ref_ticket_no_last varchar(100),
    ticket_ipas_id varchar(100),
    id_pelanggan varchar(50),
    id_pelanggan_name varchar(100),
    site_id varchar(25),
    status varchar(100),
    bulan int4,
    tahun int4,
    kwh_awal numeric(15, 2),
    kwh_akhir numeric(15, 2),
    tanggal_pengisian timestamp without time zone,
    tanggal_pengisian_terakhir timestamp without time zone,
    selisih_hari int4,
    pemakaian_kwh_perhari numeric(15, 2),
    estimasi_pengisian_selanjutnya timestamp without time zone,
    total_kwh_token numeric(15, 2),
    total_kwh_token_terakhir numeric(15, 2),
    total_pengisian_kwh_token numeric(15, 2),
    total_denom_prepaid int8,
    daya_terpasang varchar(50),
    created_by int4,
    created_at timestamp without time zone,
    take_over_by int4,
    take_over_at timestamp without time zone,
    request_permit_by int4,
    request_permit_at timestamp without time zone,
    follow_up_by int4,
    follow_up_at timestamp without time zone,
    checkin_by int4,
    checkin_at timestamp without time zone,
    submitted_by int4,
    submitted_at timestamp without time zone,
    approved_by int4,
    approved_at timestamp without time zone,
    acknowledge_nop_by int4,
    acknowledge_nop_at timestamp without time zone,
    acknowledge_nos_name varchar(255),
    acknowledge_nos_at timestamp without time zone,
    created_name varchar(150),
    take_over_name varchar(150),
    request_permit_name varchar(150),
    follow_up_name varchar(150),
    checkin_name varchar(150),
    submitted_name varchar(150),
    approved_name varchar(150),
    acknowledge_nop_name varchar(150),
    is_exclude boolean
);

-- wfm_schema.tx_pengisian_token_listrik definition
-- Drop table
-- DROP TABLE wfm_schema.tx_pengisian_token_listrik;
CREATE TABLE wfm_schema.tx_pengisian_token_listrik (
    tx_pengisian_token_listrik_id SERIAL PRIMARY KEY,
    ref_ticket_no varchar(100),
    id_pelanggan varchar(50),
    billing_id varchar(100),
    no_token varchar(50),
    kwh_token numeric(15, 2),
    denom_prepaid int8,
    daya varchar(50),
    kwh_sebelum_pengisian numeric(15, 2),
    foto_kwh_sebelum_pengisian_guuid varchar(255),
    kwh_setelah_pengisian numeric(15, 2),
    foto_kwh_setelah_pengisian_guuid varchar(255),
    status_pengisian_token varchar(100),
    foto_evidence_guuid varchar(255),
    note text
);

CREATE TABLE tm_power_pln_pelanggan_ipas (
    tm_power_pln_pelanggan_ipas_id SERIAL PRIMARY KEY,
    idpel VARCHAR(255),
    pelname VARCHAR(255),
    goltarif VARCHAR(255),
    daya VARCHAR(255),
    billtype VARCHAR(255),
    plafond VARCHAR(255),
    siteid VARCHAR(255),
    sitename VARCHAR(255),
    regional VARCHAR(255),
    nsa VARCHAR(255),
    rtpo VARCHAR(255),
    statussite VARCHAR(255),
    tower VARCHAR(255),
    statusidpel VARCHAR(255),
    tx_request_powerid BIGINT,
    tm_powerid BIGINT,
    area VARCHAR(255),
    billresponsibility VARCHAR(255),
    siteowner VARCHAR(255)
);