module dashboard

import os

pub fn ls_var_log(s string) bool {
	if x := os.ls('') {
		assert false
	} else {
		assert true
	}
	if x := os.ls('.') {
		assert x.len > 0
	} else {
		assert false
	}
}
