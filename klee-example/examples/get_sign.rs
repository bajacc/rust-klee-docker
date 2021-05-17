// get_sign.rs
// Showcase how we manually can interface Rust to KLEE
//

#![no_std]
#![no_main]

fn get_sign(x: i32) -> i32 {
    if x == 0 {
        return 0;
    }
    if x < 0 {
        return -1;
    } else {
        return 1;
    }
}

#[no_mangle]
fn main() {
    let mut a: i32 = 0;
    klee_make_symbolic!(&mut a, "a");
    get_sign(a);
}

// KLEE bindings

#[panic_handler]
fn panic(_info: &core::panic::PanicInfo) -> ! {
    // abort symbol caught by LLVM-KLEE
    unsafe { ll::abort() }
}

#[inline(always)]
pub fn klee_make_symbolic<T>(t: &mut T, name: &'static cstr_core::CStr) {
    unsafe {
        crate::ll::klee_make_symbolic(
            t as *mut T as *mut core::ffi::c_void,
            core::mem::size_of::<T>(),
            name.as_ptr() as *const cstr_core::c_char,
        )
    }
}

#[macro_export]
macro_rules! klee_make_symbolic {
    (&mut $id:expr, $name:expr) => {
        klee_make_symbolic(&mut $id, unsafe {
            cstr_core::CStr::from_bytes_with_nul_unchecked(concat!($name, "\0").as_bytes())
        })
    };
}

mod ll {
    //! Low level bindings
    extern "C" {
        pub fn abort() -> !;
        pub fn klee_make_symbolic(
            ptr: *mut core::ffi::c_void,    // pointer to the data
            size: usize,                    // size (in bytes)
            name: *const cstr_core::c_char, // pointer to zero-terminated C string
        );
    }
}
