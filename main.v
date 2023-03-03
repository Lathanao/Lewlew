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



	app.mount_static_folder_at(os.resource_abs_path('backend/account'), '/backend')
	app.mount_static_folder_at(os.resource_abs_path('backend/login'),   '/backend')
	app.mount_static_folder_at(os.resource_abs_path('static/HTMLElement'), '/wc')
	app.mount_static_folder_at(os.resource_abs_path('static/js'), 			'/js')
	app.mount_static_folder_at(os.resource_abs_path('static/js'), 			'/js')
	app.mount_static_folder_at(os.resource_abs_path('static/css'), 			'/css')
	app.mount_static_folder_at(os.resource_abs_path('static/image'), 		'/image')
	app.mount_static_folder_at(os.resource_abs_path('templates'), 			'/templates')

	// for k, v in app.static_files {
	// 	println(k + " : " + v)
	// }

	// // app.admin = app.factory.create_admin()?

	// dump(app.admin)


	os.setenv('VCACHE', vcache_folder, true)
	eprintln('testsuite_begin, vcache_folder = $vcache_folder')
	os.rmdir_all(vcache_folder) or {}
	vcache.new_cache_manager([])

	// password := 'tanguy'
	// passhash := sha256.sum('$password$BO_hash_key'.bytes()).hex().str()
	// admin := app.factory.fetch_admin({'password': passhash})?

	// println("============== return main ===============")
	// println(admin)


	vweb.run<App>(&app, port) 
}



pub fn (mut app App) index() vweb.Result {
	if app.is_logged() {
		println('if app.logged_in()')
		return app.file(os.join_path(os.resource_abs_path('/templates/index.html')))
	}
	else {
		println('else app.logged_in()')
		return app.redirect('/login')
	}

	println('index redirect logout')
	return app.redirect('/logout')
}

pub fn (mut app App) is_logged() bool {
	println('check logged_in')
	uuid := app.get_cookie('uuid') or { return false }
	println('uuid: ' + uuid)

	println('load session from cache')
	mut cm := vcache.new_cache_manager([])
	session := cm.load('.session', 'admin/session/test') or { return false }
	
	println('load session from json')
	app.session = json2.decode<classe.Session>(session) or { return false }
	println('session: ' + session)

	println('return $app.session.id > 0')
	return app.session.id > 0
}


['/login']
pub fn (mut app App) login() vweb.Result {
	time_now := time.Time{unix: time.utc().unix_time()}
	// app.set_cookie(
	// 		name: 'uuid', 
	// 		value: '',
	// 		expires: time_now.add( - 1 * time.second )
	// 		)
	return app.file(os.join_path(os.resource_abs_path('/templates/loginwall.html')))
}


['/logout']
pub fn (mut app App) logout() vweb.Result {
		println("['/logout']")
		time_now := time.Time{unix: time.utc().unix_time()}

		// println('logout delete cookie')
		// app.set_cookie(
		// 		name: 'uuid', 
		// 		value: '',
		// 		expires: time_now.add( - 1 * time.second )
		// 		)
			
		return app.redirect('/login')
}


[post]
['/login']
pub fn (mut app App) login_post() ?vweb.Result {

	println("============== login_post ===============")
	// println(app.factory)


	email := app.form['email']
	password := app.form['password']


	// if !validate.is_email(email) {
	// 		app.error << 'Invalid email address.'
	// }
	// if !validate.is_password_admin(password) {
	// 		app.error << 'Invalid password.'
	// }
	println('app.error.len' + app.error.len.str())
	if app.error.len == 0 {
			println('yo')
			app.factory = classe.Factory{	
				adminfactory: classe.AdminFactory{db: app.db}
			}
			passhash := sha256.sum('$password$BO_hash_key'.bytes()).hex().str()
			println("test Admin")
			println(email)
			println(password)
			println(passhash.str())
			admin := app.factory.fetch_admin({'password': passhash})?
			println("admin.id: " + admin.id.str())

			if admin.id == 0 {
					println("dmin.id == 0 ")
					app.error << 'The admin does not exist, or the password provided is incorrect.'
					return app.redirect('/logout')

			} else {
					tool := classe.Tool{}
					
					uuid := rand.uuid_v4()
					println('create ses')
					ses := classe.Session {
						id:      			admin.id,
						ip:       		'127.0.0.1',
						timestamp:    time.ticks(),
						token:        uuid
					}

					println('save session in cache')
					ses_json := json2.encode<classe.Session>(ses)
					mut cm := vcache.new_cache_manager([])
					saved := cm.save('.session', 'admin/session/test', ses_json) or {
						assert false
						''
					}
					println('save session in cache: ' + saved)
					
					println('create cookie uuid')
					time_now := time.Time{unix: time.utc().unix_time()}
					app.set_cookie(
						name: 'uuid', 
						value: uuid,
						expires: time_now.add( time.offset() * time.second + (48*3600) * time.second )
						)
					println('return index /')
					return app.index()
			}
			
	}
	println('return /logout')
	return app.redirect('/logout')
}


fn hash_password(password string, username string) string {

	println(password)
	println(username)

	mut seed := [u32(username[0]), u32(username[1])]
	println(seed)
	rand.seed(seed)
	salt := rand.i64().str()
	pw := '$password$salt'
	println(pw.str())
	return sha256.sum(pw.bytes()).hex().str()
}


['/api/test']
pub fn (mut app App) api_test() vweb.Result {
		mut p := []classe.Product
		// p << classe.Product{
		// 	id                  : 10
		// 	sku                 : 'ABC'
		// 	ean13               : '123ABC'
		// }
		// p << classe.Product{
		// 	id                  : 11
		// 	sku                 : 'DEF'
		// 	ean13               : '456DEF'
		// }
		return app.text('yop')
}


['/api/order']
pub fn (mut app App) api_post() ?vweb.Result {
		get_users_query_result := app.db.query('SELECT * FROM ps_orders LIMIT 10;') ?
		return app.json(get_users_query_result.maps())
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



pub fn (mut app App) before_request() {
		app.nb_request++
		//println( app )
}

pub fn (mut app App) init_once() {
	
}

['/admin/forgot_password']
pub fn (mut app App) admin_forgotpassword() vweb.Result {
	// csrf := rand.string(30)
	// app.set_cookie(name: 'csrf', value: csrf)
	// return $vweb.html()
	return app.file(os.join_path(os.resource_abs_path('/templates/loginwall.html')))
}