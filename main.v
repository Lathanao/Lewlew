module main

import rand
import sqlite
import vweb
import classe
import time
import os
import flag
import encoding.base64
import crypto.sha256
import json
import math
import mysql
import validate
import v.vcache
import x.json2

const (
	port = 8882
)

struct App {
	vweb.Context
	
mut:
	cnt 				int
	db   				mysql.Connection
	factory 		classe.Factory
	logged_in   bool
	nb_request  int
pub mut:
	error		 		[]string
	admin 			classe.Admin
	session  		classe.Session
	cm 					vcache.CacheManager
}

struct Criteria {
pub mut:
    where []Where
		orderby Orderby
		limit Limit
}

struct Where {
pub mut:
    attr string
		value string
}

struct Orderby {
pub mut:
    attr string
		way string
}

struct Limit {
pub mut:
    currentpage string
		rowsbypage string
}

// struct ApiResponse {
// 	token 			fn () gen_uuid_v4ish()
// 	content 		int
// }

const (
	BO_hash_key = 'set_your_secret_key_for_hashing'
	FO_hash_key = 'set_your_secret_key_for_hashing'
	vcache_folder = os.join_path(os.temp_dir(), 'vcache_folder')
	session_expire = 1*24*3600
)

fn main() {
	mut app := App{
		session: classe.Session{}
	}
	app.db = mysql.Connection{
		username: 'magento'
		password: 'magento'
		dbname: 'raw_pcw'
		}
	app.db.connect() ?

	// app.factory = classe.Factory{	
	// 	db: app.db,
	// 	adminfactory: classe.AdminFactory{db: &app.db}
	// }

	app.mount_static_folder_at(os.resource_abs_path('backend/dashboard'),'/backend')
	app.mount_static_folder_at(os.resource_abs_path('backend/account'), '/backend')
	app.mount_static_folder_at(os.resource_abs_path('backend/login'),   '/backend')
	app.mount_static_folder_at(os.resource_abs_path('backend/forget'),  '/backend')
	app.mount_static_folder_at(os.resource_abs_path('backend/order'),  	'/backend')
	
	app.mount_static_folder_at(os.resource_abs_path('static/component'), '/component')
	app.mount_static_folder_at(os.resource_abs_path('static/js'), 			'/js')
	app.mount_static_folder_at(os.resource_abs_path('static/css'), 			'/css')
	app.mount_static_folder_at(os.resource_abs_path('static/image'), 		'/image')
	app.mount_static_folder_at(os.resource_abs_path('static/'), 		    '/')
	app.mount_static_folder_at(os.resource_abs_path('templates'), 			'/templates')


	os.setenv('VCACHE', vcache_folder, true)
	eprintln('testsuite_begin, vcache_folder = $vcache_folder')
	os.rmdir_all(vcache_folder) or {}
	vcache.new_cache_manager([])


	vweb.run<App>(&app, port) 
}

pub fn (mut app App) index() vweb.Result {
	if app.is_logged() {
		return app.file(os.join_path(os.resource_abs_path('/templates/index.html')))
	}

	return app.redirect('/logout')
}

[post]
['/']
pub fn (mut app App) index_post() ?vweb.Result {

	email := app.form['email']
	password := app.form['password']

	// if !validate.is_email(email) {
	// 		app.error << 'Invalid email address.'
	// }
	// if !validate.is_password_admin(password) {
	// 		app.error << 'Invalid password.'
	// }
	// println('app.error.len' + app.error.len.str())
	if app.error.len == 0 {
			app.factory = classe.Factory{	
				adminfactory: classe.AdminFactory{db: app.db}
			}
			passhash := sha256.sum('$password$BO_hash_key'.bytes()).hex().str()
			admin := app.factory.fetch_admin({'password': passhash})?

			if admin.id == 0 || admin.email != email {
					app.error << 'The admin does not exist, or the password provided is incorrect.'
					return app.redirect('/logout')

			} else {
					tool := classe.Tool{}
					
					uuid := rand.uuid_v4()
					ses := classe.Session {
						uuid:      			uuid,
						ip:       			'127.0.0.1',
						created_at:    	time.ticks(),
						updated_at:    	time.ticks(),
					}

					ses_json := json2.encode<classe.Session>(ses)
					mut cm := vcache.new_cache_manager([])
					saved := cm.save('.session', 'admin/session/test', ses_json) or {
						assert false
						''
					}

					time_now := time.Time{unix: time.utc().unix_time()}
					app.set_cookie(
						name: 'uuid', 
						value: uuid,
						expires: time_now.add( time.offset() * time.second + (48*3600) * time.second )
						)
					return app.file(os.join_path(os.resource_abs_path('/templates/index.html')))
			}
			
	}
	return app.redirect('/logout')
}

['/login']
pub fn (mut app App) login() vweb.Result {
	app.clean_session()
	return app.file(os.join_path(os.resource_abs_path('/templates/login.html')))
}

['/logout']
pub fn (mut app App) logout() vweb.Result {
	return app.redirect('/login')
}

pub fn (mut app App) clean_session() bool {

	time_now := time.Time{unix: time.utc().unix_time()}
	app.set_cookie(
			name: 'uuid', 
			value: '',
			expires: time_now.add( - 1 * time.second )
			)

	uuid := app.get_cookie('uuid') or { return false }
	mut cm := vcache.new_cache_manager([])
	session_to_delete := cm.exists('.session', 'admin/session') or { return false }
	os.rm(session_to_delete) or { return false }
	return true
}

// pub fn (mut app App) check_session_exist() bool {

// 	time_now := time.Time{unix: time.utc().unix_time()}
// 	mut cm := vcache.new_cache_manager([])
// 	session := cm.load('.session', 'admin/session') or { return false }
// 	os.rm(session_to_delete) or { return false }
// 	return true

// 	uuid := app.get_cookie('uuid') or { return false }
// 	println('================ check_session_exist ===================')
// 	println(uuid)
// 	return uuid != ''
// }

pub fn (mut app App) is_logged() bool {
	uuid := app.get_cookie('uuid') or { return false }

	mut cm := vcache.new_cache_manager([])
	session := cm.load('.session', 'admin/session/test') or { return false }
	println(session)
	time.sleep(500 * time.millisecond)
	app.session = json2.decode<classe.Session>(session) or { return false }
	app.session.updated_at = time.ticks()
	
	println(session)
	ses_json := json2.encode<classe.Session>(app.session)
	saved := cm.save('.session', 'admin/session/test', ses_json) or { return false }

	return saved.len > 0
}

['/api/order/setup']
pub fn (mut app App) api_order_setup() ?vweb.Result {
	// println("============= api_order_setup =============")
	count := app.db.query('SELECT COUNT(*) as count
							FROM `ps_orders` o
							LEFT JOIN `ps_customer` c ON (c.`id_customer` = o.`id_customer`)
							;') ?
	
	// fullcolumns := app.db.query('SHOW FULL COLUMNS FROM `ps_orders`;') ?
	// map_result := orders_result.maps()

	// println("============= api_order_setup =============")
	// println(map_result[0])
	// println(typeof(map_result[0]))

	return app.json(count.maps())
}

['/api/order/:order_id']
pub fn (mut app App) api_order_by_id(order_id string) ?vweb.Result {
	println("============= api_order_by_id =============")
	// println('id: $order_id')
	orders_result := app.db.query('SELECT *, (
									SELECT osl.`name`
									FROM `ps_order_state_lang` osl
									WHERE osl.`id_order_state` = o.`current_state`
									AND osl.`id_lang` = 2
									LIMIT 1
							) AS `state_name`, o.`date_add` AS `date_add`, o.`date_upd` AS `date_upd`
							FROM `ps_orders` o
							LEFT JOIN `ps_customer` c ON (c.`id_customer` = o.`id_customer`)
							LIMIT 10;') ?
	map_result := orders_result.maps()
	return app.json(map_result)
}

[post]
['/api/order']
pub fn (mut app App) api_order() ?vweb.Result {
		// if app.is_logged() {
		// 	return app.json('Resource not found')
		// }

		mut query := ''
		if app.form['json'] != '' {
			out := json.decode(map[string]string, app.form['json']) ?

			crit := json.decode(Criteria, app.form['json']) or { Criteria{where: [Where{'failled', 'failled'},],} }
			query = make_query(crit, 'o')
		}

		orders_result := app.db.query('SELECT *, (
                    SELECT osl.`name`
                    FROM `ps_order_state_lang` osl
                    WHERE osl.`id_order_state` = o.`current_state`
                    AND osl.`id_lang` = 2
                    LIMIT 1
                ) AS `state_name`, o.`date_add` AS `date_add`, o.`date_upd` AS `date_upd`
                FROM `ps_orders` o
                LEFT JOIN `ps_customer` c ON (c.`id_customer` = o.`id_customer`)
                ' + query + ';') ?
		map_result := orders_result.maps()
		return app.json(map_result)
}


// struct Limit {
// pub mut:
//     currentpage string
// 		rowsbypage string
// }
pub fn make_query(criteria Criteria, schema_name string) string {

	nb_page := 10
	mut conjonction := ' WHERE'
	mut condition := ''

	if criteria.where.len > 0 {
		for crit in criteria.where {
			if crit.attr.len > 0 {
				condition += conjonction + " $schema_name" + ".$crit.attr = $crit.value"
				conjonction = ' AND'
			}
		}
	}

	if criteria.orderby.attr.len > 0 {
		condition += ' ORDER BY $criteria.orderby.attr $criteria.orderby.way'
	}

	if criteria.limit.currentpage.len > 0 {
		page := criteria.limit.currentpage.int()
		number := criteria.limit.rowsbypage.int()
		min := page + ( number - 1 ) * ( page - 1 ) - 1
		max := page + ( number - 1 ) * ( page )
		condition += ' LIMIT $max OFFSET $min'
	}
	println(condition)
	return condition
}


['/api/employee']
pub fn (mut app App) api_employee() ?vweb.Result {
		get_users_query_result := app.db.query('SELECT * FROM ps_employee LIMIT 10') ?
		return app.json(get_users_query_result.maps())
}

pub fn (mut app App) account() vweb.Result {
		return app.index()
}

pub fn (mut app App) adminaccount() vweb.Result {
		return app.index()
}

pub fn (mut app App) order() vweb.Result {
		return app.index()
}

pub fn (mut app App) settings() vweb.Result {
		return app.index()
}

pub fn (mut app App) forget() vweb.Result {
		return app.file(os.join_path(os.resource_abs_path('/templates/login.html')))
}

pub fn (mut app App) before_request() {
		app.nb_request++
}

pub fn (mut app App) init_once() {
	
}

['/admin/forgot_password']
pub fn (mut app App) admin_forgotpassword() vweb.Result {
	// csrf := rand.string(30)
	// app.set_cookie(name: 'csrf', value: csrf)
	// return $vweb.html()
	return app.file(os.join_path(os.resource_abs_path('/templates/login.html')))
}