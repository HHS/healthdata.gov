package gov.data.health.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;

/**
 *
 * @author dougHHS
 */
public class MulgaraLoader extends BulkLoader {
	final String dq = "\"";
	final String websvc = "http://localhost:8080/mulgara/webui/ExecuteQuery.html";

	@Override
	public void init() throws Exception {		
	}
	
	public void done() throws Exception {
	}

	@Override
	public void loadOne(File f, String graphName) throws Exception {
      String fname = f.getAbsolutePath();

		String[] commands = new String[]{"curl", "-F", "UploadGraph="+graphName, 
				"-F", "UploadFile=@"+fname, websvc };
		
		BufferedReader input = null;
		try {
			Process pr = Runtime.getRuntime().exec( commands );
			try {
				int exitStatus = pr.waitFor();
			} catch (Throwable ex) {
				System.exit(0);
			} 
			input = new BufferedReader(new InputStreamReader(pr.getInputStream()));
			String line = null;
			while ((line = input.readLine()) != null) {
//			   System.out.println(line);
			}
			int exitVal = pr.waitFor();
//			System.out.println("Exited with error code " + exitVal);
		} catch (Exception e) {
			System.out.println(e.toString());
			e.printStackTrace();
		} finally {
			try { input.close(); } catch (IOException e) { }
		}
	}
}
