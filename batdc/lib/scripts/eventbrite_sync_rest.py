#!/usr/bin/env python

import os
import sys
import argparse
import getpass
import json
import requests
import pprint
import mysql.connector
from datetime import datetime, date, timedelta
from mysql.connector import errorcode


################################################################################
#
# Eventbrite constants and credentials
#
################################################################################

eb_api_endpoint = "https://www.eventbriteapi.com/v3"
tori_oauth_token = os.environ['EB_API_KEY']

def eb_request(path, args={}):
    url = "%s/%s?token=%s" % (eb_api_endpoint, path, tori_oauth_token)
    url_params = []
    for (k,v) in args.items():
        url_params.append("%s=%s" % (k,v))
    if len(url_params) > 0:
        url_w_args = "%s&%s" % (url, "&".join(url_params))
    else:
        url_w_args = url

    print url_w_args
    r = requests.get(url_w_args)
    return json.loads(r.text.encode('utf8', 'replace'))

def headers():
    h = {"X-Auth-Token" : tori_oauth_token,
         "Content-Type": "application/json",
         "Accept": "application/json",}
    return h

def get_uid(oauth_token):
    r = requests.get("%s/users/me/?token=%s" % (eb_api_endpoint, oauth_token))
    return r.json()['id']

################################################################################
#
# BATDC Database constants & helpers
#
################################################################################

event_fields = [
    "eventbrite_id",
    "event_name",
    "start_date",
    "end_date",
    "url",
    "school_id",
    "description",
    "updated_at"]

contact_fields = [
    "last",
    "first",
    #"role",
    "title",
    "school_id",
    "eventbrite_id",
    "work_phone",
    "email_primary",
    #"email_secondary",
    #"notes",
    #"subject_area",
    #"other_subject",
    # gPK - g12
    "status",
    "updated_at"]

attendee_fields = [
    "contact_id",
    "event_id",
    "paid",
    "sponsor_school_id",
    "updated_at"]

def insert_event(cursor, e):    
    print "Adding Event: %s\t%s" % (e['eventbrite_id'], e['event_name'])

    fields = []
    values = []
    for f in e.keys():
        fields.append(f)
        values.append(e[f])

    cursor.execute("INSERT INTO events (%s)" % ", ".join(fields) +
                   "VALUES(%s)" % ", ".join(["%s"]*len(fields)), values)

def insert_contact(cursor, c):
    print "Adding Contact: %s %s" % (c['first'], c['last'])

    fields = []
    values = []
    for f in c.keys():
        fields.append(f)
        values.append(c[f])

    cursor.execute("INSERT INTO contacts (%s)" % ", ".join(fields) +
                   "VALUES(%s)" % ", ".join(["%s"]*len(fields)), values)

def update_event(cursor, event_id, e):
    print "Updating Event[%s]: %s\t%s" % (event_id, e['eventbrite_id'], e['event_name'])

    terms = []
    values = []
    for f in event_fields:
        terms.append(f+"=%s")
        values.append(e[f])
    update_str = ", ".join(terms)        
    cursor.execute("UPDATE events SET %s WHERE id = %s" % (update_str, event_id), values)  

def replace_attendee(cursor, a):
    print "Adding/Updating Attendance: %s %s" % (a['contact_id'], a['event_id'])
    
    values = []
    for f in attendee_fields:
        values.append(a[f])

    cursor.execute("REPLACE INTO attendees (%s)" % ", ".join(attendee_fields) +
                   "VALUES(%s)" % ", ".join(["%s"]*len(attendee_fields)), values)

def delete_attendee(cursor, contact_id, event_id):
    print "Deleting Attendance: contact=%s event=%s" % (contact_id, event_id)
    
    cursor.execute("DELETE from attendees WHERE contact_id=%s AND event_id=%s" % (contact_id, event_id))    

def find_school_id(cursor, eb_company, eb_email=None):
    # Lookup school

    sponsor_school_id = None
    cursor.execute("SELECT id FROM schools "
                   "WHERE name = %s "
                   "or official_name = %s", [eb_company, eb_company])
    for row in cursor:
        sponsor_school_id = row[0]

    # Try Alias Table
    if not sponsor_school_id:
        cursor.execute("SELECT a.school_id, s.name "
                       "FROM school_alias a JOIN schools s "
                       "ON a.school_id = s.id "
                       "WHERE alias = %s", [eb_company])
        for row in cursor:
            sponsor_school_id = row[0]

    # Find school by email domain
    if eb_email and not sponsor_school_id:
        user, domain = eb_email.split('@')
        cursor.execute("select distinct school_id "
                       "from contacts "
                       "where email_primary like '%%@%s' "
                       "and school_id is not null" % domain)
        for row in cursor:
            sponsor_school_id = row[0]

    print "Find School ID %s - %s" % (eb_company, sponsor_school_id)
    return sponsor_school_id

def find_contact_id(cursor, eb_id, email, last, first):
    contact_id = None
    cursor.execute("SELECT id, eventbrite_id "
                   "FROM contacts WHERE eventbrite_id = %s", [eb_id]);

    # Find Contact by Eventbrite ID
    for row in cursor:
        contact_id = row[0]
        contact_eb_id = row[1]

    # Find Contact by Email
    if not contact_id:
        cursor.execute("SELECT id "
                       "FROM contacts WHERE "
                       "email_primary = %s OR "
                       "email_secondary = %s", [email, email])
        for row in cursor:
            contact_id = row[0]

    # Find Contact by Name
    if not contact_id:
        cursor.execute("SELECT id "
                       "FROM contacts WHERE "
                       "last = %s "
                       "AND first = %s ", [last, first])
        for row in cursor:
            contact_id = row[0]

    return contact_id
                       
def find_contact_school_id(cursor, contact_id):
    cursor.execute("select school_id "
                   "from contacts "
                   "where id = %s", [contact_id])

    school_id = None
    for row in cursor:
        school_id = row[0]

    return school_id

def find_event_id(cursor, eb_id):
    cursor.execute("select id from events "
                   "where eventbrite_id = %s", [eb_id])
    event_id = None
    for row in cursor:
        event_id = row[0]
    return event_id

def get_value_or_null(dict, key):
    val = None
    try:
        val = dict[key]
    except KeyError:
        pass
    return val

################################################################################
#
# Main
#
################################################################################

def main(argv):

    parser = argparse.ArgumentParser(description='Load guests and contacts tables.')
    parser.add_argument('-u', '--user', default='root', help='database user')
    parser.add_argument('--host', default='localhost', help='database host')
    parser.add_argument('-d', '--database', default='test', help='database name')
    parser.add_argument('-p', '--password', default=None, help='database password')
    parser.add_argument('-a', '--all', action='store_true', help='update all events')
    args = parser.parse_args(argv)

    if args.password:
        passwd = args.password
    else:
        passwd = getpass.getpass()


    cnx = mysql.connector.connect(user=args.user, password=passwd,
                                  host=args.host,
                                  database=args.database)
    cursor = cnx.cursor()
    eb_user_id = get_uid(tori_oauth_token)

################################################################################
# Sync Events Table
################################################################################

    # Find all Eventbrite events in BATDC Database
    cursor.execute("select id, eventbrite_id, event_name, updated_at "
                   "from events "
                   "where eventbrite_id is not null "
                   "order by id desc")

    db_data = {}
    for row in cursor:
        e = {}
        eb_id = row[1]
        e['id'] = row[0]
        e['eventbrite_id'] = eb_id
        e['event_name'] = row[2]
        e['updated_at'] = row[3]
        db_data[eb_id] = e

    # Find New Events (i.e. not yet in DB)

    if args.all:
        search_status = 'all'
    else:
        search_status = 'live'
        
    search_params = { 'status' : search_status }
        
    #event_list = eb_request("events/search", search_params)['events']
    event_list = eb_request("users/%s/owned_events/" % eb_user_id, search_params)
    event_list = event_list['events']
    eb_data = {}
    for event in event_list:        
        eb_id = event['id']
        e = {}

        e['eventbrite_id'] = eb_id
        e['event_name'] = event['name']['text']
        e['start_date'] = event['start']['local']
        e['end_date'] = event['end']['local']
        e['description'] = event['description']['text']
        e['school_id'] = find_school_id(cursor, event['venue']['name'].encode("utf8").strip())
        e['url'] = event['url']
        e['updated_at'] = datetime.now()

        eb_data[eb_id] = e

        if not db_data.has_key(eb_id):
            insert_event(cursor, e)
        elif args.all or db_data[eb_id]['updated_at'] > e['updated_at']:
            print e
            update_event(cursor, db_data[eb_id]['id'], e)

        event_id = find_event_id(cursor, eb_id)

################################################################################
# Sync Attendance Table
################################################################################


        # First delete cancelled entries
        path = "events/%s/attendees/" % eb_id
        r = eb_request(path, { "status" : "not_attending" })
        print "%s - Not Attending:" % e['event_name']
        non_attendee_list = r['attendees']
        for attendee in non_attendee_list:
            eb_last = get_value_or_null(attendee['profile'], 'last_name')
            eb_first = get_value_or_null(attendee['profile'], 'first_name')
            eb_attendee_id = attendee['id']
            eb_email = get_value_or_null(attendee['profile'], 'email')

            # find contact
            contact_id = find_contact_id(cursor, eb_attendee_id, eb_email, eb_last, eb_first)

            print "Should remove: %s, %s id=%s" % (eb_last, eb_first, contact_id)

            if contact_id:
                delete_attendee(cursor, contact_id, event_id)
                cnx.commit()
        
        r = eb_request(path, { "status" : "attending"})
        page_info = r['pagination']
        count = page_info['object_count']
        tot_pages = page_info['page_count']
        cur_page = int(page_info['page_number'])
        
        attendee_list = r['attendees']
        for p in range(1, tot_pages + 1):
            if p > 1:
                r = eb_request(path, { "status" : "attending", "page" : p})
                attendee_list = r['attendees']
                cur_page = int(r['pagination']['page_number'])
                assert p==cur_page, "Page mismatch: p=%d, cur_page=%d" % (p, cur_page)
            
            for i, attendee in enumerate(attendee_list):
                c_ids = []
                a = {}
                eb_last = get_value_or_null(attendee['profile'], 'last_name')
                eb_first = get_value_or_null(attendee['profile'], 'first_name')
                eb_paid = float(attendee['costs']['gross']['value'])/100.0
                eb_event_id = attendee['event']['id']
                eb_attendee_id = attendee['id']
                eb_email = get_value_or_null(attendee['profile'], 'email')
                eb_company = get_value_or_null(attendee['profile'], 'company')

                #print "%s, %s at %s" % (eb_last, eb_first, eb_company)

                # find contact
                contact_id = find_contact_id(cursor, eb_attendee_id, eb_email, eb_last, eb_first)

                # find sponsor_school
                sponsor_school_id = find_school_id(cursor, eb_company, eb_email)

                # Add to contacts if new and school found
                if not contact_id:
                    c = {}
                    c['last'] = eb_last
                    c['first'] = eb_first                
                    c['title'] = get_value_or_null(attendee['profile'], 'job_title')
                    c['school_id'] = sponsor_school_id
                    c['eventbrite_id'] = eb_attendee_id
                    c['work_phone'] = get_value_or_null(attendee, 'work_phone')
                    c['email_primary'] = eb_email
                    c['status'] = 'Active'
                    c['updated_at'] = datetime.now()

                    insert_contact(cursor, c)
                    cnx.commit()
                    contact_id = find_contact_id(cursor, eb_attendee_id, eb_email, eb_last, eb_first)                

                if contact_id and not sponsor_school_id:
                    sponsor_school_id = find_contact_school_id(cursor, contact_id)

                # replace into attendees
                if contact_id:                
                    a['contact_id'] = contact_id
                    a['event_id'] = event_id
                    a['paid'] = eb_paid
                    a['sponsor_school_id'] = sponsor_school_id
                    a['updated_at'] = datetime.now()

                    replace_attendee(cursor, a)
                    cnx.commit()

                try:
                    print "A%d E[%s] C[%s] %s, %s" % (i, event_id, contact_id, eb_last, eb_first)
                except:
                    print "A%d E[%s] C[%s]" % (i, event_id, contact_id)

                assert contact_id, "No Contact ID!"
                if contact_id in c_ids:
                    print "Duplicate entry for event[%s] contact[%s]" % (event_id, contact_id)
                else:
                    c_ids.append(contact_id)
                
    cnx.commit()
    
if __name__ == "__main__":
  main(sys.argv[1:])
