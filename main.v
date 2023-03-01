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

const (
	port = 8888
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
}

// struct ApiResponse {
// 	token 			fn () gen_uuid_v4ish()
// 	content 		int
// }

const (
	BO_hash_key = 'set_your_secret_key_for_hashing'
	FO_hash_key = 'set_your_secret_key_for_hashing'
	vcache_folder = os.join_path(os.temp_dir(), 'vcache_folder')
)

fn main() {
	mut app := App{}
	app.db = mysql.Connection{
			username: 'magento'
			password: 'magento'
			dbname: 'raw_pcw'
		}
	app.db.connect() ?

	app.factory = classe.Factory{	
		db: &app.db,
		adminfactory: classe.AdminFactory{db: &app.db}}

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


	vweb.run<App>(&app, port) 
}



pub fn (mut app App) index() vweb.Result {
	if app.logged_in() {
		println('if app.logged_in()')
		return app.file(os.join_path(os.resource_abs_path('/templates/index.html')))
	}
	else {
		println('else app.logged_in()')
		return app.redirect('/login')
	}

	// return app.text('index')
		
}

pub fn (mut app App) logged_in() bool {
	println('check logged_in')
	islogged := app.get_cookie('logged') or { return false }
	return islogged != ''
}



['/login']
pub fn (mut app App) login() vweb.Result {
	println("['/login']")
	if app.logged_in() {	
		return app.redirect('/')
	}
	else {
		return app.file(os.join_path(os.resource_abs_path('/templates/loginwall.html')))
	}
}


['/logout']
pub fn (mut app App) logout() vweb.Result {
		println("['/logout']")
		time_now := time.Time{unix: time.utc().unix_time()}

		app.set_cookie(
			name: 'logged', 
			value: '0',
			expires: time_now.add( time.offset() * time.second - (24*3600) * time.second ))

		app.set_cookie(
			name: 'test', 
			value: '0',
			expires: time_now.add( time.offset() * time.second - (48*3600) * time.second ))
		
		return app.file(os.join_path(os.resource_abs_path('/templates/loginwall.html')))
}


[post]
['/logout']
pub fn (mut app App) logout_post() vweb.Result {
		println("[post] ['/logout']")
		time_now := time.Time{unix: time.utc().unix_time()}

		app.set_cookie(
			name: 'logged', 
			value: '0',
			expires: time_now.add( time.offset() * time.second - (24*3600) * time.second ))

		app.set_cookie(
			name: 'test', 
			value: '0',
			expires: time_now.add( time.offset() * time.second - (48*3600) * time.second ))
		
		return app.file(os.join_path(os.resource_abs_path('/templates/loginwall.html')))
}

[post]
['/login']
pub fn (mut app App) login_post() ?vweb.Result {
	email := app.form['email']
	password := app.form['password']

	println(email)
	println(password)

	// if !validate.is_email(email) {
	// 		app.error << 'Invalid email address.'
	// }
	// if !validate.is_password_admin(password) {
	// 		app.error << 'Invalid password.'
	// }
	println(app.error)
	if app.error.len == 0 {

			admin := app.factory.fetch_admin({'email': email})?
			tool := classe.Tool{}

			if admin.id > 0 {
					app.error << 'The admin does not exist, or the password provided is incorrect.'
					return app.redirect('/logout')
			} else {
					// Logger::addLog(sprintf($this->l('Back Office connection from %s', 'AdminTab', false, false), Tools::getRemoteAddr()), 1, null, '', 0, true, (int) $this->context->employee->id);

					remote_addr := tool.get_remote_ip()
					// Update cookie
					

					// $cookie = $this->context->cookie;
					// $cookie->id_employee = $this->context->employee->id;
					// $cookie->email = $this->context->employee->email;
					// $cookie->profile = $this->context->employee->id_profile;
					// $cookie->passwd = $this->context->employee->passwd;
					// $cookie->remote_addr = $this->context->employee->remote_addr;

					// if !tool.get_value('stay_logged_in') {
					// 		app.set_cookie(name: 'last_activity', value: '1')
					// } 


					mut cm := vcache.new_cache_manager([])
					x := cm.save('.session', 'first/cache/entry', 'hello') or {
						assert false
						''
					}


					time_now := time.Time{unix: time.utc().unix_time()}
					
					app.set_cookie(
						name: 'logged', 
						value: '1',
						expires: time_now.add( time.offset() * time.second + (24*3600) * time.second ))

					app.set_cookie(
						name: 'test', 
						value: '1',
						expires: time_now.add( time.offset() * time.second + (48*3600) * time.second ))

					app.set_cookie(name: 'last_activity', value: time.utc().unix_time().str())

					return app.index()
			}
			return app.file(os.join_path(os.resource_abs_path('/templates/loginwall.html')))
	}

	// if email.len > 0 && password.len > 4 {
	// 	app.set_cookie(name: 'logged', value: '1')
	// 	return app.redirect('/')
	// }
	return app.redirect('/login')
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
		get_users_query_result := app.db.query('SELECT * FROM ps_orders LIMIT 10') ?
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