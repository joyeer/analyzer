package io.decompile.testdata.trycatchfinally;

class NestedTryCatchFinallyTestData {

	void testcase_try_$_try_catch_$_finally() {
		try {
			
			try {
				int j = 0;
			}
			catch(Throwable ex) {
				System.out.print(ex);
			}
		}  finally {
			int i = 0;
			i += 1;
		}
	}

	int testcase_try_$_try_catch_$_catch() {
		try {
			
			try {
				int j = 0;
				return j;
			}
			catch(Throwable ex) {
				System.out.print(ex);
			}
			return 20;
		}  catch(Throwable ex) {
			int i = 0;
			i += 1;
		}		
		return 10;
	}

	void testcase_try_$_try_catch_$_catch_2() {
		try {
			
			try {
				int j = 0;
			}
			catch(Throwable ex) {
				System.out.print(ex);
			}
		}  catch(Throwable ex) {
			int i = 0;
			i += 1;
		}		
	}

	void testcase_try_finally_$_try_catch_$() {
		try {
			int i = 0;
			i += 1;
		}  finally {
			try {
				System.out.print("finally");
			}
			catch(Throwable ex) {
				System.out.print(ex);	
			}
		}
	}

	void testcase_try_throws_finally_$_try_catch_$() {
		try {
			int i = 0;
			i += 1;
			throw new RuntimeException("Runtime");
		}  finally {
			try {
				System.out.print("finally");
			}
			catch(Throwable ex) {
				System.out.print(ex);	
			}
		}
	}



	void testcase_try_catch_$_try_catch_$() {
		try {
			int j = 0;
		}
		catch(Throwable ex) {
			System.out.print(ex);

			try {
				int i = 0;
			} catch(Throwable e) {
				System.out.print(e);
			}
		}
	} 

	int testcase_try_catch_$_try_catch_$_return() {
		try {
			int j = 0;
			return j;
		}
		catch(Throwable ex) {
			System.out.print(ex);

			try {
				int i = 0;
				return 30;
			} catch(Throwable e) {
				System.out.print(e);
			}
			finally {
				System.out.print("finally2");	
			}

		}
		finally {
			System.out.print("finally");
		}

		
		return 10;
	} 

	int testcase_synchronized_try_catch_return() {
		synchronized(this) {
			int i = 0;
			try {
				while(true) {
					i ++;
				}
			} catch(Throwable e) {
				System.out.print(e);
			}
			return 10;
		}
	}

	int testcase_for_try_finally() {
		for (int i = 0 ; i < 10 ; i ++ ) {
			try {
				int j = 0;
				if(j > 13) {
					continue;
				}
			} 
			finally {
				System.out.print("finally");	
			}
		}
		return 20;
	}

	int testcase_try_catch_$_try_catch_$_catch_$_try_catch_$() {
		try {
			int i = 0;
			i += 1;
			return i;
		}  catch(IllegalStateException e) {
			try {
				System.out.print("finally1");
			}
			catch(Throwable ex) {
				System.out.print(ex);	
			}
		} catch(RuntimeException e) {
			try {
				System.out.print("finally2");
			}
			catch(Throwable ex) {
				System.out.print(ex);	
			}
		}

		return 10;
	}

}
