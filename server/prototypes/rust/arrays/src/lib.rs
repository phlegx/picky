#![feature(libc)]

extern crate libc;
use std::ffi::CString;
pub use libc::types::os::arch::c95::c_char;
pub use libc::types::os::arch::c99::uintptr_t;

// A simple array-like thing that holds i16 numbers.
//

// #[no_mangle]
// pub extern "C" fn append(other: i16) {
//
// }

// #[no_mangle]
// pub extern "C" fn intersect(other: u64) { // (other: Vec<i16>) -> Vec<i16> {
//
// }

#[link(name = "ruby")]
extern {
  // static rb_cObject: &'static libc::c_void;
  fn rb_define_module(name: *const libc::c_char) -> libc::uintptr_t;
  // fn rb_define_class_under(
  //   module: libc::uintptr_t,
  //   name: *const libc::c_char,
  //   klass: &libc::c_void
  // ) -> libc::uintptr_t;
  // fn rb_define_method(
  //   klass: libc::uintptr_t,
  //   name: *const libc::c_char,
  //   function: extern fn(libc::uintptr_t),
  //   argc: libc::c_int
  // );
  // fn rb_define_singleton_method(
  //   klass: libc::uintptr_t,
  //   name: *const libc::c_char,
  //   callback: extern fn(libc::uintptr_t),
  //   argc: libc::c_int
  // );
}

// Allow non snake case for Init_...
#[allow(non_snake_case)]

#[no_mangle]
pub extern fn Init_libarrays() {
  // Module/Class structure.
  let rust_module_name = CString::new("Rust").unwrap().as_ptr();
  // let rust_module =
  unsafe { rb_define_module(rust_module_name) };
  // let rust_array_name  = CString::new("Array").unwrap().as_ptr();
  // let rust_array = unsafe {
  //   rb_define_class_under(rust_module, rust_array_name, rb_cObject)
  // };
  //
  // // Ruby methods.
  // let intersect_name = CString::new("intersect").unwrap().as_ptr();
  // unsafe { rb_define_method(rust_array, intersect_name, intersect, 1) }
}