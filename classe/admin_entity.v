module classes

//import crypto.sha256
//import rand
//import os
//import time
//import sqlite

struct AdminEntity {
// pub:
// 	id                  int
// mut:
//     last_name           string
//     name                string
//     first_name          string
//     email               string
//     accepts_marketing   int
//     addresses           int
//     addresses_count     int
//     default_address     int
//     has_account         int
//     last_order          int
//     orders              int
//     orders_count        int
//     phone               int
//     tags                int
//     total_spent         int
//     published_at        int 
//     created_at          int 
//     modified_at         int 


pub:
	id              					int
pub mut:
	id_profile								int
	id_lang										int
	lastname									string
	firstname									string	
	email											string	
	password									string
	last_passwd_gen						int

	optin											int
	id_last_order							int
	id_last_customer_message	int
	id_last_customer					int
	last_connection_date			string
	reset_password_token			string	
	reset_password_validity 	int
}
