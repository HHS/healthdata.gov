package gov.data.health.util;

import java.io.BufferedReader;

import java.io.File;
import java.io.FileReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.common.SolrInputDocument;
import org.apache.solr.client.solrj.impl.CommonsHttpSolrServer;
import org.apache.commons.io.FileUtils;

import java.io.IOException;

/**
 * @author dougHHS
 */
public class SolrLoader extends BulkLoader {
	String url = "http://localhost/siren";
	LuceneDocumentMaker docMaker = null;
	
	public SolrLoader( LuceneDocumentMaker docMaker ) {
		this.docMaker = docMaker;
	}

	@Override
	public void init() throws Exception {
		CommonsHttpSolrServer server = null;
		server = new CommonsHttpSolrServer(url);
		server.deleteByQuery("*:*");// CAUTION: deletes everything!
		server.commit();
	}

	@Override
	public void loadOne(File f, String graphName)
		throws Exception {

		Runtime rt = Runtime.getRuntime();
		Process proc = rt.exec("java -cp target/loadGraphsSesame-1.0.0-jar-with-dependencies.jar com.hp.hpl.jena.rdf.arp.NTriple "
				+ f.getAbsolutePath());
		BufferedReader bri = new BufferedReader(new InputStreamReader(proc.getInputStream()));
		List<String> list = new ArrayList<String>();
		String str;
		while ((str = bri.readLine()) != null) {
			list.add(str);
		}
		bri.close();
		LuceneDoc.addTriplesToMap( list );
	}

	public void done() throws Exception {
		System.out.println("Now generate Lucene documents");
		docMaker.init();
		Set<String> docNames = LuceneDoc.getDocNames();
		for (String name : docNames){
			docMaker.addDoc( LuceneDoc.getDoc( name ) );
		}
		docMaker.done();
	}
}
