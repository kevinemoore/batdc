alter table schools
drop index name;

insert into schools
(id, name, official_name, website,
office_phone, fax, address1, address2, city,
state, zip, country, updated_at, created_at)
select id, name, official_name, website,
office_phone, fax, address1, address2, city,
state, zip, country, now(), now() from batdc.schools;

insert into contacts
(id, last, first, role, title, school_id,
eventbrite_id, work_phone, email_primary,
email_secondary, notes, subject_area,
other_subject, gPK, gK, g01, g02, g03, g04,
g05, g06, g07, g08, g09, g10, g11, g12, status,
subscribed, updated_at)
select
c.id, c.last, c.first, c.role, c.title, s.id,
c.eventbrite_id, c.work_phone, c.email_primary,
c.email_secondary, c.notes, c.subject_area,
c.other_subject,
(case when c.gPK = 'YES' then true else false end),
(case when c.gK = 'YES' then true else false end),
(case when c.g01 = 'YES' then true else false end),
(case when c.g02 = 'YES' then true else false end),
(case when c.g03 = 'YES' then true else false end),
(case when c.g04 = 'YES' then true else false end),
(case when c.g05 = 'YES' then true else false end),
(case when c.g06 = 'YES' then true else false end),
(case when c.g07 = 'YES' then true else false end),
(case when c.g08 = 'YES' then true else false end),
(case when c.g09 = 'YES' then true else false end),
(case when c.g10 = 'YES' then true else false end),
(case when c.g11 = 'YES' then true else false end),
(case when c.g12 = 'YES' then true else false end),
c.status, c.subscribed, c.last_update
from batdc.contacts c join batdc.schools s on
c.school = s.name;

insert into events (
id,
eventbrite_id,
event_name,
event_type,
series,
start_date,
end_date,
venue,
url,
description,
num_sessions,
updated_at)
select
id,
eventbrite_id,
event_name,
event_type,
series,
start_date,
end_date,
venue,
url,
description,
num_sessions,
last_update
from batdc.events;

insert into attendees (
contact_id,
event_id,
paid,
sponsor_school_id,
updated_at )
select
a.contact_id,
a.event_id,
a.paid,
s.id,
a.last_update
from batdc.attendance a JOIN batdc.schools s
ON a.sponsor_school = s.name;
