module session

import time
import rand
import math
import x.json2
import crypto.sha256
// import net

pub const (
	version = 0xBA // Magic byte, BrancA.
	private = 'sdfdsfsfqwewq'
	nonce   = ''
)

pub struct Session {
pub mut:
	uuid       string
	ip         string
	created_at i64
	updated_at i64
}

pub fn (s Session) to_json() string {
	mut mp := map[string]json2.Any{}
	mp['uuid'] = json2.Any(s.uuid)
	mp['ip'] = json2.Any(s.ip)
	mp['created_at'] = json2.Any(s.created_at)
	mp['updated_at'] = json2.Any(s.updated_at)
	/*
	$for field in Employee.fields {
		d := e.$(field.name)

		$if field.typ is JobTitle {
			mp[field.name] = json.encode<int>(d)
		} $else {
			mp[field.name] = d
		}
	}
	*/
	return mp.str()
}

pub fn (mut s Session) from_json(any json2.Any) {
	mp := any.as_map()
	s.uuid = mp['uuid'] or { json2.Any('') }.str()
	s.ip = mp['ip'] or { json2.Any(0) }.str()
	s.created_at = mp['created_at'] or { json2.Any(0) }.i64()
	s.updated_at = mp['updated_at'] or { json2.Any(0) }.i64()
}

// pub fn (mut ses Session) logout() vweb.Result {
// 	ses.set_cookie(name: 'SESSION', value: '')
// 	return ses.redirect('/login')
// }

// pub fn (mut ses Session) client_ip(username string) ?string {
// 	ip := ses.conn.peer_ip() or { return none }
// 	return make_password(ip, '${username}token')
// }

// pub fn (mut ses Session) check_user_blocked(user_id int) bool {
// 	//user := app.find_user_by_id(user_id) or { return false }
// 	return false
// }

// pub fn (mut ses Session) make_password(password string, username string) string {
// 	return make_password(password, username)
// }

// fn make_password(password string, username string) string {
// 	mut seed := [u32(username[0]), u32(username[1])]
// 	rand.seed(seed)
// 	salt := rand.i64().str()
// 	pw := '$password$salt'
// 	return sha256.sum(pw.bytes()).hex().str()
// }

// pub fn (mut ses Session) get_user_from_cookies()  {
// 	// id := ses.get_cookie('id') or { return none }
// 	// token := ses.get_cookie('token') or { return none }
// 	// mut user := ses.find_user_by_id(id.int()) or { return none }
// 	// ip := app.client_ip(id) or { return none }
// 	// if token != ses.find_user_token(user.id, ip) {
// 	// 	return none
// 	// }
// 	// user.b_avatar = user.avatar != ''
// 	// if !user.b_avatar {
// 	// 	user.avatar = user.username.bytes()[0].str()
// 	// }

// }

// fn encode_cookie() Session {
// 	ticknow := time.ticks()
// 	ses := Session{
// 		user_id: 1010,
// 		user_ip: '127.0.0.1',
// 		timestamp: ticknow  + i64(3600 * 1000),
// 		token: gen_uuid_v4ish()
// 	}
// 	return ses
// }

// fn decode_cookie(jsoned_session string) Session {
// 	//session := json.decode(Session, jsoned_session) or { exit(1) }
// 	// if session.user_id > 0{
// 	// 	return session
// 	// }
// 	return Session{}
// }
