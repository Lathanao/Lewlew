module main

import rand
import vweb
import classe
import time
import os
// import flag
import crypto.sha256
// import json
import mysql
import v.vcache
import x.json2
import log
import validate

const (
	port           = 8882
	hash_key       = 'set_your_secret_key_for_hashing'
	vcache_folder  = os.join_path(os.temp_dir(), 'vcache_folder')
	session_expire = 1 * 24 * 3600
)

struct App {
	vweb.Context
mut:
	cnt        int
	factory    classe.Factory
	logged_in  bool
	nb_request int
pub mut:
	db      mysql.Connection
	buffer  []string
	store   []map[string]string
	error   []string
	admin   classe.Admin
	session classe.Session
	cm      vcache.CacheManager
}

struct Criteria {
pub mut:
	where   []Where [json: where]
	orderby Orderby [json: orderby]
	limit   Limit
}

struct Where {
pub mut:
	attr  string
	value string
}

struct Orderby {
pub mut:
	attr string
	way  string
}

struct Limit {
pub mut:
	currentpage string = '1'
	rowsbypage  string = '10'
}

fn main() {
	env_content := os.read_file(os.dir(@FILE) + os.path_separator + '.env') ?
	for line in env_content.split_into_lines() {
		a := line.split('=')
		os.setenv(a[0], a[1], true)
	}

	mut app := App{
		session: classe.Session{}
		db: mysql.Connection{
			username: os.getenv('DB_USERNAME')
			password: os.getenv('DB_PASSWORD')
			dbname: os.getenv('DB_DBNAME')
		}
	}

	app.mount_static_folder_at(os.resource_abs_path('/dashboard'), '/dashboard')
	app.mount_static_folder_at(os.resource_abs_path('backend/account'), '/account')
	app.mount_static_folder_at(os.resource_abs_path('backend/login'), '/login')
	app.mount_static_folder_at(os.resource_abs_path('backend/forget'), '/forget')
	app.mount_static_folder_at(os.resource_abs_path('backend/order'), '/order')

	app.mount_static_folder_at(os.resource_abs_path('static/component'), '/component')
	app.mount_static_folder_at(os.resource_abs_path('static/js'), '/js')
	app.mount_static_folder_at(os.resource_abs_path('static/css'), '/css')
	app.mount_static_folder_at(os.resource_abs_path('static/image'), '/image')
	app.mount_static_folder_at(os.resource_abs_path('static/'), '/')

	app.mount_static_folder_at(os.resource_abs_path('log/static'), '/log')

	os.setenv('VCACHE', vcache_folder, true)
	os.rmdir_all(vcache_folder) or {}
	vcache.new_cache_manager([])

	vweb.run<App>(&app, port)
}

pub fn (mut app App) index() vweb.Result {
	$if prod {
		if !app.is_logged() {
			return app.redirect('/logout')
		}
	}
	return app.file(os.join_path(os.resource_abs_path('/templates/index.html')))
}

['/intercome']
pub fn (mut app App) intercom() vweb.Result {
	return app.file(os.join_path(os.resource_abs_path('/templates/intercome.html')))
}

['/'; post]
pub fn (mut app App) index_post() ?vweb.Result {
	email := app.form['email']
	password := app.form['password']

	if !validate.is_email(email) {
		app.error << 'Invalid email address.'
	}
	if !validate.is_password_admin(password) {
		app.error << 'Invalid password.'
	}

	if app.error.len == 0 {
		app.factory = classe.Factory{
			adminfactory: classe.AdminFactory{
				db: app.db
			}
		}
		passhash := sha256.sum('$password$hash_key'.bytes()).hex().str()
		admin := app.factory.fetch_admin({
			'password': passhash
		}) ?

		if admin.id == 0 || admin.email != email {
			app.error << 'The admin does not exist, or the password provided is incorrect.'
			return app.redirect('/logout')
		} else {
			// tool := classe.Tool{}

			uuid := rand.uuid_v4()
			// ses := classe.Session{
			// 	uuid: uuid
			// 	ip: '127.0.0.1'
			// 	created_at: time.ticks()
			// 	updated_at: time.ticks()
			// }

			// ses_json := json2.encode<classe.Session>(ses)
			// mut cm := vcache.new_cache_manager([])
			// saved := cm.save('.session', 'admin/session/test', ses_json) or {
			// 	assert false
			// 	''
			// }

			time_now := time.Time{
				unix: time.utc().unix_time()
			}
			app.set_cookie(
				name: 'uuid'
				value: uuid
				expires: time_now.add(time.offset() * time.second + (48 * 3600) * time.second)
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
	// time_now := time.Time{
	// 	unix: time.utc().unix_time()
	// }
	// app.set_cookie(
	// 	name: 'uuid'
	// 	value: ''
	// 	expires: time_now.add(-1 * time.second)
	// )

	// uuid := app.get_cookie('uuid') or { return false }
	// mut cm := vcache.new_cache_manager([])
	// session_to_delete := cm.exists('.session', 'admin/session') or { return false }
	// os.rm(session_to_delete) or { return false }
	return true
}

// pub fn (mut app App) check_session_exist() bool {

// 	time_now := time.Time{unix: time.utc().unix_time()}
// 	mut cm := vcache.new_cache_manager([])
// 	session := cm.load('.session', 'admin/session') or { return false }
// 	os.rm(session_to_delete) or { return false }
// 	return true

// 	uuid := app.get_cookie('uuid') or { return false }
// 	return uuid != ''
// }

pub fn (mut app App) is_logged() bool {
	// uuid := app.get_cookie('uuid') or { return false }

	mut cm := vcache.new_cache_manager([])
	session := cm.load('.session', 'admin/session/test') or { return false }

	time.sleep(500 * time.millisecond)
	app.session = json2.decode<classe.Session>(session) or { return false }
	app.session.updated_at = time.ticks()

	ses_json := json2.encode<classe.Session>(app.session)
	saved := cm.save('.session', 'admin/session/test', ses_json) or { return false }

	return saved.len > 0
}

['/api/order/count'; post]
pub fn (mut app App) api_order_count() vweb.Result {
	mut count := map[string]int{}
	count['count'] = 1999
	return app.json(count)
}

['/api/order/column'; post]
pub fn (mut app App) api_order_column() vweb.Result {
	mut col := map[string]string{}
	col['id_order'] = 'Id Order'
	col['reference'] = 'Reference'
	col['delivery_number'] = 'Delivery Number'
	col['email'] = 'Email'
	col['valid'] = 'Valid'
	col['date_add'] = 'Date Add'
	col['Sup'] = 'Sup'

	return app.json(col)
}

['/api/order/setup']
pub fn (mut app App) api_order_setup() ?vweb.Result {
	app.db.connect() or { panic(err) }
	count := app.db.query('SELECT COUNT(*) as count
							FROM `ps_orders` o
							LEFT JOIN `ps_customer` c ON (c.`id_customer` = o.`id_customer`)
							;') or {
		panic(err)
	}
	app.db.close()
	// fullcolumns := app.db.query('SHOW FULL COLUMNS FROM `ps_orders`;') ?
	// map_result := orders_result.maps()

	return app.json(count.maps())
}

['/api/order/:order_id']
pub fn (mut app App) api_order_by_id(order_id string) ?vweb.Result {
	app.db.connect() or { panic(err) }
	orders_result := app.db.query('SELECT *, (
									SELECT osl.`name`
									FROM `ps_order_state_lang` osl
									WHERE osl.`id_order_state` = o.`current_state`
									AND osl.`id_lang` = 2
									LIMIT 1
							) AS `state_name`, o.`date_add` AS `date_add`, o.`date_upd` AS `date_upd`
							FROM `ps_orders` o
							LEFT JOIN `ps_customer` c ON (c.`id_customer` = o.`id_customer`)
							LIMIT 10;') or {
		panic(err)
	}
	app.db.close()
	map_result := orders_result.maps()
	return app.json(map_result)
}

['/api/order'; post]
pub fn (mut app App) api_order() ?vweb.Result {
	// if app.is_logged() {
	// 	return app.json('Resource not found')
	// }

	// out := json.decode(map[string]string, app.form['json']) ?

	// criteria := json.decode(Criteria, app.form['json']) or { Criteria{} }
	// query := make_query(criteria, 'o')

	sql :=
		'SELECT *, (
                    SELECT osl.`name`
                    FROM `ps_order_state_lang` osl
                    WHERE osl.`id_order_state` = o.`current_state`
                    AND osl.`id_lang` = 2
                    LIMIT 1
                ) AS `state_name`, o.`date_add` AS `date_add`, o.`date_upd` AS `date_upd`
                FROM `ps_orders` o
                LEFT JOIN `ps_customer` c ON (c.`id_customer` = o.`id_customer`)
                ' +
		' LIMIT 10 OFFSET 0' + ';'

	app.db.connect() or { panic(err) }
	orders_result := app.db.query(sql) or { panic(err) }
	app.db.close()
	map_result := orders_result.maps()
	return app.json(map_result)
}

pub fn make_query(criteria Criteria, schema_name string) string {
	mut conjonction := ' WHERE'
	mut condition := ''

	if criteria.where.len > 0 {
		for crit in criteria.where {
			if crit.attr.len > 0 {
				condition += conjonction + ' $schema_name' + '.$crit.attr = $crit.value'
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
		min := page + (number - 1) * (page - 1) - 1
		max := page + (number - 1) * page
		condition += ' LIMIT $max OFFSET $min'
	} else {
		condition += ' LIMIT 10 OFFSET 0'
	}

	return condition
}

['/api/log/menu']
pub fn (mut app App) api_log_menu() vweb.Result {
	return app.json(log.api_log_menu())
}

['/api/log/count'; post]
pub fn (mut app App) api_log_count() vweb.Result {
	return app.json(log.api_ufw_log_count())
}

['/api/log/column'; post]
pub fn (mut app App) api_log_column() vweb.Result {
	return app.json(log.api_ufw_log_column())
}

['/api/log/stat']
pub fn (mut app App) api_log_stat() vweb.Result {
	return app.json(log.api_ufw_log_stat())
}

['/api/log'; post]
pub fn (mut app App) api_log() ?vweb.Result {
	return app.json(log.api_ufw_log())
}

['/api/ufw-log'; post]
pub fn (mut app App) api_log_ufw() vweb.Result {
	return app.json(log.api_ufw_log())
}

['/account']
pub fn (mut app App) account() vweb.Result {
	return app.index()
}

// ['/post/account'; post]
// pub fn (mut app App) post_account() ?vweb.Result {
// 	return app.json(post_account())
// }

pub fn (mut app App) adminaccount() vweb.Result {
	return app.index()
}

pub fn (mut app App) order() vweb.Result {
	return app.index()
}

pub fn (mut app App) log() vweb.Result {
	return app.index()
}

['/dictionary']
pub fn (mut app App) dictionary() vweb.Result {
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
	return app.file(os.join_path(os.resource_abs_path('/templates/login.html')))
}
