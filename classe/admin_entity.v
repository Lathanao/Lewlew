module classes

//import crypto.sha256
//import rand
//import os
//import time
//import sqlite

struct AdminEntity {
	id                  int
mut:
    last_name           string
    name                string
    first_name          string
    email               string
    accepts_marketing   int
    addresses           int
    addresses_count     int
    default_address     int
    has_account         int
    last_order          int
    orders              int
    orders_count        int
    phone               int
    tags                int
    total_spent         int
    published_at        int 
    created_at          int 
    modified_at         int 
}
