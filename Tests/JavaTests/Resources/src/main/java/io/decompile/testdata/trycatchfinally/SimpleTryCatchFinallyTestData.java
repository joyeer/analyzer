package io.decompile.testdata.trycatchfinally;

class SimpleTryCatchFinallyTestData {

	void testcase_try_finally() {
		try {
			int i = 0;
			i += 1;
		}  finally {
			System.out.print("finally");
		}
	}

	void testcase_try_finally_2() {
		try {
			int i = 0;
			i += 1;
		}  finally {
			System.out.print("finally");
		}

		System.out.print("end");
	}

		void testcase_try_catch() {
			try {
				int i = 0;
				i += 1;
			} catch(Throwable ex) {
				System.out.print(ex);
			}
		}

	void testcase_try_catch_finally() {
		try {
			int i = 0;
			i += 1;
		} catch(Throwable ex) {
			System.out.print(ex);
		} finally {
			System.out.print("finally");
		}
	}

	void testcase_try_mutli_catch() {
		try {
			int i = 0;
			i += 1;
		} catch(IllegalThreadStateException ex) {
			System.out.print(ex);
		} catch(IllegalStateException ex) {
			System.out.print(ex);
		} catch(IllegalArgumentException ex) {
			System.out.print(ex);
		}
	}

	void testcase_try_multi_catch_finally() {
		try {
			int i = 0;
			i += 1;
		} catch(IllegalThreadStateException ex) {
			System.out.print(ex);
		} catch(IllegalStateException ex) {
			System.out.print(ex);
		} catch(IllegalArgumentException ex) {
			System.out.print(ex);
		} finally {
			System.out.print("finally");
		}
	}

	// return in 'Try' block
	int testcase_try_return_finally() {
		try {
			return 10;
		}  finally {
			System.out.print("finally");
		}
	}

	int testcase_try_return_catch() {
		try {
			return 10;
		}  
		catch(Throwable e) {
			System.out.print(e);
		}
		return 20;
	}

	int testcase_try_return_catch_finally() {
		try {
			return 10;
		}  catch(Throwable e) {
			System.out.print(e);
		} finally {
			System.out.print("finallly");
		}
		return 20;
	}

	//  throw in Try Block
	int testcase_try_throw_finally() {
		try {
			throw new RuntimeException("Runtime");
		}  finally {
			System.out.print("finally");
		}
	}

	int testcase_try_throw_catch() {
		try {
			throw new RuntimeException("Runtime");
		}  
		catch(Throwable e) {
			System.out.print(e);
		}
		return 20;	
	}

	int testcase_try_throw_catch_finally() {
		try {
			throw new RuntimeException("Runtime");
		}  
		catch(Throwable e) {
			System.out.print(e);
		} finally {
			System.out.print("finallly");
		}
		return 20;		
	}

	int testcase_try_throw_multi_catches() {
		try {
			throw new RuntimeException("Runtime");
		} catch(IllegalThreadStateException ex) {
			System.out.print(ex);
		} catch(IllegalStateException ex) {
			System.out.print(ex);
		} catch(IllegalArgumentException ex) {
			System.out.print(ex);
		} 
		return 20;		
	}

	int testcase_try_throw_multi_catches_finally() {
		try {
			throw new RuntimeException("Runtime");
		} catch(IllegalThreadStateException ex) {
			System.out.print(ex);
		} catch(IllegalStateException ex) {
			System.out.print(ex);
		} catch(IllegalArgumentException ex) {
			System.out.print(ex);
		} finally {
			System.out.print("finallly");	
		} 
		return 20;		
	}

	int testcase_try_return_multi_catches() {
		try {
			return 10;
		} catch(IllegalThreadStateException ex) {
			System.out.print(ex);
		} catch(IllegalStateException ex) {
			System.out.print(ex);
		} catch(IllegalArgumentException ex) {
			System.out.print(ex);
		} 
		return 20;
	}

	int testcase_try_return_multi_catches_finally () {
		try {
			return 10;
		} catch(IllegalThreadStateException ex) {
			System.out.print(ex);
		} catch(IllegalStateException ex) {
			System.out.print(ex);
		} catch(IllegalArgumentException ex) {
			System.out.print(ex);
		} finally {
			System.out.print("finallly");	
		} 
		return 20;
	}

	void testcase_try_return_void_finally() {
		try {
			int i = 0;
			i += 1;
			return ;
		}  finally {
			System.out.print("finally");			
		}
	}

	void testcase_try_return_void_catch() {
		try {
			int i = 0;
			i += 1;
			return ;
		}  catch(Throwable ex) {
			System.out.print(ex);
		}
	}

	void testcase_try_return_void_catch_finally() {
		try {
			int i = 0;
			i += 1;
			return ;
		}  catch(Throwable ex) {
			System.out.print(ex);
		} finally {
			System.out.print("finally");	
		} 
	}

	void testcase_try_return_void_mutli_catches() {
		try {
			int i = 0;
			i += 1;
			return ;
		}  catch(IllegalThreadStateException ex) {
			System.out.print(ex);
		} catch(IllegalStateException ex) {
			System.out.print(ex);
		} catch(IllegalArgumentException ex) {
			System.out.print(ex);
		} 
	}


	void testcase_try_return_void_mutli_catches_finally () {
		try {
			int i = 0;
			i += 1;
			return ;
		}  catch(IllegalThreadStateException ex) {
			System.out.print(ex);
		} catch(IllegalStateException ex) {
			System.out.print(ex);
		} catch(IllegalArgumentException ex) {
			System.out.print(ex);
		}  finally {
			System.out.print("finally");	
		}
	}

	int testcase_try_finally_return() {
		try {
			int i = 0;
			i += 1;
		}  finally {
			System.out.print("finally");
			return 20;
		}
	}

	int testcase_try_catch_finally_return() {
		try {
			int i = 0;
			i += 1;
		}  catch(Throwable ex) {
			System.out.print(ex);
		}  finally {
			System.out.print("finally");
			return 20;
		}
	}

	int testcase_try_mutli_catches_finally_return() {
		try {
			int i = 0;
			i += 1;
		}  catch(IllegalThreadStateException ex) {
			System.out.print(ex);
		} catch(IllegalStateException ex) {
			System.out.print(ex);
		} catch(IllegalArgumentException ex) {
			System.out.print(ex);
		} finally {
			System.out.print("finally");
			return 20;
		}
	}

	int testcase_try_catch_return() {
		try {
			int i = 0;
			i += 1;
		}  catch(Throwable ex) {
			System.out.print(ex);
			return 20;
		}  
		return 10;
	}

	int testcase_try_catch_return_2() {
		try {
			int i = 0;
			i += 1;
			return 10;
		}  catch(Throwable ex) {
			System.out.print(ex);
			return 20;
		}  
	}	

	int testcase_try_catch_return_finally() {
		try {
			int i = 0;
			i += 1;
		}  catch(Throwable ex) {
			System.out.print(ex);
			return 10;
		}  finally {
			System.out.print("finally");
			return 20;
		}
	}

	int testcase_try_catch_return_finally_2() {
		try {
			int i = 0;
			i += 1;
			return 30;
		}  catch(Throwable ex) {
			System.out.print(ex);
			return 10;
		}  finally {
			System.out.print("finally");
			return 20;
		}

	}

	int testcase_try_mutli_catches_return_finally() {
		try {
			int i = 0;
			i += 1;
		}  catch(IllegalThreadStateException ex) {
			System.out.print(ex);
			return 20;
		} catch(IllegalStateException ex) {
			System.out.print(ex);
			return 30;
		} catch(IllegalArgumentException ex) {
			System.out.print(ex);
			return 40;
		} finally {
			System.out.print("finally");
			return 20;
		}
	}

	int testcase_try_mutli_catches_return_finally_2() {
		try {
			int i = 0;
			i += 1;
		}  catch(IllegalThreadStateException ex) {
			System.out.print(ex);
			return 20;
		} catch(IllegalStateException ex) {
			System.out.print(ex);
		} catch(IllegalArgumentException ex) {
			System.out.print(ex);
		} finally {
			System.out.print("finally");
			return 20;
		}
	}

	int testcase_try_return_catch_throw() {
		try {
			return 10;
		} catch(IllegalArgumentException ex) {
			throw new RuntimeException("Rutnime");
		} 
	}

	int testcase_try_return_mutli_catches_throw() {
		try {
			return 10;
		} catch(IllegalThreadStateException ex) {
			throw new RuntimeException("Rutnime");
		} catch(IllegalStateException ex) {
			throw new RuntimeException("Rutnime2");
		} catch(IllegalArgumentException ex) {
			throw new RuntimeException("Rutnime3");
		} 
	}

	int testcase_try_return_catch_throw_finally() {
		try {
			return 10;
		} catch(IllegalArgumentException ex) {
			throw new RuntimeException("Rutnime");
		} finally {
			System.out.print("finally");
			return 20;
		}
	}

	int testcase_try_return_mutli_catches_throw_finally() {
		try {
			return 10;
		} catch(IllegalThreadStateException ex) {
			throw new RuntimeException("Rutnime");
		} catch(IllegalStateException ex) {
			throw new RuntimeException("Rutnime2");
		} catch(IllegalArgumentException ex) {
			throw new RuntimeException("Rutnime3");
		} finally {
			System.out.print("finally");
			return 20;
		}
	}


	int testcase_try_return_multi_catches_2() {
		try {
			return 10;
		} catch(IllegalThreadStateException | IllegalStateException ex) {
			System.out.print(ex);
		} catch(IllegalArgumentException ex) {
			System.out.print(ex);
		} 
		return 20;
	}
	
}