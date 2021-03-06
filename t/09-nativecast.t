use lib '.';
use t::CompileTestLib;
use NativeCall;
use Test;

plan(10);

compile_test_lib('09-nativecast');

sub ReturnArray() returns OpaquePointer is native('./09-nativecast') { * }
my $carray = nativecast(CArray[uint32], ReturnArray());
is $carray[0..2], (1, 2, 3), 'casting int * to CArray[uint32] works';

sub ReturnStruct() returns OpaquePointer is native('./09-nativecast') { * };
class CUTE is repr('CStruct') {
    has int32 $.i;
}
is nativecast(CUTE, ReturnStruct()).i, 100, 'casting to CStruct works';

is nativecast(CUTE, nativecast(OpaquePointer, ReturnStruct())).i, 100, 'casting to CPointer works';

sub ReturnInt() returns OpaquePointer is native('./09-nativecast') { * }
is nativecast(int32, ReturnInt()), 101, 'casting to int32 works';

sub ReturnShort() returns OpaquePointer  is native('./09-nativecast') { * }
is nativecast(int16, ReturnShort()), 102, 'casting to int16 works';

sub ReturnByte() returns OpaquePointer is native('./09-nativecast') { * }
is nativecast(int8, ReturnByte()), -103, 'casting to int8 works';

sub ReturnDouble() returns OpaquePointer is native('./09-nativecast') { * }
is_approx nativecast(num64, ReturnDouble()), 99.9e0, 'casting to num64 works';

sub ReturnFloat() returns OpaquePointer is native('./09-nativecast') { * }
is_approx nativecast(num32, ReturnFloat()), -4.5e0, 'casting to num32 works';

sub ReturnString() returns OpaquePointer is native('./09-nativecast') { * }
is nativecast(str, ReturnString()), "epic cuteness", 'casting to str works';

sub ReturnNullString returns OpaquePointer is native('./09-nativecast') { * }
nok nativecast(str, ReturnNullString()).defined, 'casting null pointer to str';
