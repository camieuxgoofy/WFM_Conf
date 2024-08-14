SELECT
    ticket_technical_support_id AS tx_field_operation_non_alarm_id,
    no_ticket,
    site_id,
    cluster_area,
    category,
    ticket_subject,
    job_details,
    job_targets,
    sla_start,
    sla_end,
    sla_range,
    sla_end - sla_start as sla_range_calc,
    created_by,
    created_at,
    modified_by,
    modified_at,
    activity_name,
    role_name,
    respone_time,
    submit_time,
    user_submitter,
    approve_time,
    user_approve,
    note,
    review,
    status,
    rootcause1,
    rootcause2,
    rootcause3,
    rootcause_remark,
    resolution_action,
    pic_id,
    pic_name,
    description,
    "name",
    issue_category,
    is_asset_change bool,
    take_over_at,
    checkin_at,
    follow_up_at,
    request_permit_at,
    is_exclude bool
FROM
    wfm_schema.ticket_technical_support