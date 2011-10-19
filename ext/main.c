#include <ruby.h>
#include "factorial_stub.h"

static VALUE rb_factorial(VALUE self, VALUE val)
{
  return UINT2NUM(factorial(NUM2UINT(val)));
}

void Init_factorial(void)
{
  hs_init(NULL, NULL);
  rb_define_module_function(rb_mMath, "factorial", RUBY_METHOD_FUNC(rb_factorial), 1);
}

static void Destroy_factorial(void) // never called.
{
  hs_exit();
}
