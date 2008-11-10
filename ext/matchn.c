#include "ruby.h"

static VALUE
rb_reg_match_n(int argc, VALUE *argv, VALUE re)
{
    VALUE result, str, initpos;
    long pos;

    if (rb_scan_args(argc, argv, "11", &str, &initpos) == 2) {
	pos = NUM2LONG(initpos);
    }
    else {
	pos = 0;
    }

    if (pos >= 0)
      pos = rb_reg_adjust_startpos(re, str, pos, 0);
    else
      pos = 0;

    pos = rb_reg_search(re, str, pos, 0);
    if (pos < 0) {
	rb_backref_set(Qnil);
	return Qnil;
    }
    result = rb_backref_get();
    rb_match_busy(result);
    if (!NIL_P(result) && rb_block_given_p()) {
	return rb_yield(result);
    }
    return rb_ary_new3(2, INT2FIX(pos), result);
}

void
Init_matchn(void) {
  rb_define_method(rb_cRegexp, "matchn", rb_reg_match_n, -1);
}
