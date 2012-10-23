package gov.data.health.util;

import java.io.File;
import java.net.URL;
import org.openrdf.model.ValueFactory;
import org.openrdf.repository.Repository;
import org.openrdf.repository.RepositoryConnection;
import org.openrdf.repository.http.HTTPRepository;
import org.openrdf.rio.RDFFormat;

public class SesameLoader extends BulkLoader {
	ValueFactory f;
	RepositoryConnection con;
	String repoId;

	public SesameLoader( String repoId ) {
		this.repoId = repoId;
	}
	
	@Override
	public void init() throws Exception {
		String sesameServer = "http://localhost/openrdf-sesame";
		Repository myRepository = new HTTPRepository(sesameServer, repoId);
		f = myRepository.getValueFactory();
		myRepository.initialize();
		con = myRepository.getConnection();
	}
	
	public void done() throws Exception {
	}

	@Override
	public void loadOne( File file, String graphName ) throws Exception {
		String oneFullName = file.getAbsolutePath();
		con.add(file, "file://"+oneFullName, 
				((file.getName().endsWith(".rdf")) ? (RDFFormat.RDFXML) : (RDFFormat.TURTLE)), 
				f.createURI(graphName));
/*
		String str = oneFullName.substring(oneFullName.indexOf("hhsFileSystem"));
		URL url = new URL("http://localhost/" + str);
		
		con.add(url, url.toString(), 
				((file.getName().endsWith(".rdf")) ? (RDFFormat.RDFXML) : (RDFFormat.TURTLE)), 
*/
	}
}
