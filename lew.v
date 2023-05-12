module main

import rand
import vweb
import classe
import time
import os
// import flag
import crypto.sha256
import json
import mysql
import v.vcache
import x.json2
import log

const (
	port           = 8882
	hash_key       = 'set_secret_key'
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

pub struct Row {
pub mut:
	date         time.Time
	host_name    string
	state        string
	in_          string
	out_         string
	mac_         string
	src_         string
	dst_         string
	len_         string
	tos_         string
	prec_        string
	ttl_         string
	id_          string
	proto_       string
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
	app.mount_static_folder_at(os.resource_abs_path('backend/account'), '/backend')
	app.mount_static_folder_at(os.resource_abs_path('backend/login'), '/backend')
	app.mount_static_folder_at(os.resource_abs_path('backend/forget'), '/backend')
	app.mount_static_folder_at(os.resource_abs_path('backend/order'), '/backend')

	app.mount_static_folder_at(os.resource_abs_path('static/component'), '/component')
	app.mount_static_folder_at(os.resource_abs_path('static/js'), '/js')
	app.mount_static_folder_at(os.resource_abs_path('static/css'), '/css')
	app.mount_static_folder_at(os.resource_abs_path('static/image'), '/image')
	app.mount_static_folder_at(os.resource_abs_path('static/'), '/')

	app.mount_static_folder_at(os.resource_abs_path('log'), '/log')

	os.setenv('VCACHE', vcache_folder, true)
	eprintln('testsuite_begin, vcache_folder = $vcache_folder')
	os.rmdir_all(vcache_folder) or {}
	vcache.new_cache_manager([])

	vweb.run<App>(&app, port)
}

pub fn (mut app App) index() vweb.Result {
	// if app.is_logged() {
	return app.file(os.join_path(os.resource_abs_path('/templates/index.html')))
	// }

	// return app.redirect('/logout')
}

['/intercome']
pub fn (mut app App) intercom() vweb.Result {
	return app.file(os.join_path(os.resource_abs_path('/templates/intercome.html')))
}

['/'; post]
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
			tool := classe.Tool{}

			uuid := rand.uuid_v4()
			ses := classe.Session{
				uuid: uuid
				ip: '127.0.0.1'
				created_at: time.ticks()
				updated_at: time.ticks()
			}

			ses_json := json2.encode<classe.Session>(ses)
			mut cm := vcache.new_cache_manager([])
			saved := cm.save('.session', 'admin/session/test', ses_json) or {
				assert false
				''
			}

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
// 	println('================ check_session_exist ===================')
// 	println(uuid)
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

	// println("============= api_order_setup =============")
	// println(map_result[0])
	// println(typeof(map_result[0]))

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
	mut query := ''

	// out := json.decode(map[string]string, app.form['json']) ?

	criteria := json.decode(Criteria, app.form['json']) or { Criteria{} }
	query = make_query(criteria, 'o')

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
	println(sql)
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

['/api/log/count'; post]
pub fn (mut app App) api_log_count() vweb.Result {
	return app.json(log.api_log_count())
}

['/api/log/column'; post]
pub fn (mut app App) api_log_column() vweb.Result {
	return app.json(log.api_log_column())
}

['/api/log'; post]
pub fn (mut app App) api_log() ?vweb.Result {
	println('============== api_log() ===============')

	raw_list := os.execute_or_panic('cat ' + '/home/tanguy/logs/ufw.light.log')
	mut list := []Row{}

	for line in raw_list.output.split_into_lines() {
		slitted := line.split(' ')

		year := time.utc().year
		month := line[0..3]
		day := line[4..6]
		oclock := line[7..15]

		host_name := slitted[4]
		state := slitted[7] + ' ' + slitted[8]

		month_names := ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov',
			'Dec']
		mut month_nb := 0
		for i, name in month_names {
			if month == name {
				month_nb = i + 1
				break
			}
		}

		date := time.Time{
			year: year
			month: month_nb
			day: day.trim_space().int()
			hour: oclock[..2].int()
			minute: oclock[3..5].int()
			second: oclock[6..8].int()
		}

		param := line.split('] ')

		mut mapp := map[string]string{}

		mut result := Row{
			date: date
			host_name: host_name
			state: state
		}

		for attr in line.split(' ') {
			if !attr.contains('=') {
				continue
			}

			val := attr.split('=')
			mapp[val[0]] = val[1]

			$for field in Row.fields {
				$if field.typ is string {
					if field.name == val[0].to_lower() + '_' {
						result.$(field.name) = val[1]
						continue
					}
				}
			}
		}
		list << result
	}

	println(list.len)

	yo := list.filter(it.src_.contains('192.168.1.34'))

	println(yo.len)

	return app.json(yo)
}

['/api/ufw-log'; post]
pub fn (mut app App) api_log_ufw() vweb.Result {
	return app.json(log.api_log_ufw())
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
