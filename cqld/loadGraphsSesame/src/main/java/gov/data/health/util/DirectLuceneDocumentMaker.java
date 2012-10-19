/*
 * Copyright Aduna (http://www.aduna-software.com/) (c) 2011.
 *
 * Licensed under the Aduna BSD-style license.
 */
package gov.data.health.util;

import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;

import org.apache.solr.client.solrj.impl.CommonsHttpSolrServer;
import org.apache.solr.common.SolrInputDocument;


/**
 *
 * @author dougHHS
 */
public class DirectLuceneDocumentMaker extends LuceneDocumentMaker {
	Collection<SolrInputDocument> docs = null;
	String serverUrl = "http://localhost:8080/siren";
   private int hops = 1;
	
	public DirectLuceneDocumentMaker( int hops ) {
		this.hops = hops;
	}
	
	@Override
	public void addDoc( LuceneDoc doc ) throws Exception {
		if (doc==null) return;
		List<List<String>> hopsLists = gatherLinks( doc, hops );
	
		String url = doc.getUri();
		SolrInputDocument document = new SolrInputDocument();
		document.addField("url", url);
		
		for (int i=0; i<hops; i++) {
			if (hopsLists.get(i).size() >0) {
				StringBuilder sb = new StringBuilder();
				for ( String triple : hopsLists.get(i) ) {
					sb.append(triple).append(" .\n");
				}
				document.addField( fieldName[i], sb );
			}
		}
		docs.add( document );
		pushIfReady();
		
//		String url = doc.getUri();
//		List<String> nTriples = doc.getTriples();
//		SolrInputDocument document = new SolrInputDocument();
//		document.addField("url", url);
//		StringBuilder sb = new StringBuilder();
//      for (String triple : nTriples ) {
//      	sb.append(triple).append(" .\n");
//      }
//
//      indirectLinks( doc.getLinks(), hops-1, sb);
//		document.addField("ntriple", sb );
//		docs.add(document);
//		pushIfReady();
	}
	
	private void indirectLinks( Iterator<String> links, int hops, StringBuilder sb ) {
//		System.out.println( "indirectLinks( "+links+", "+hops);
		if (hops<=0) return;
		if (links==null) return;
		while( links.hasNext() ) {
			String link = links.next();
			LuceneDoc linked = LuceneDoc.getDoc( link );
			if (linked!=null) {
//				System.out.println( "uri="+linked.getUri());
				List<String> nestedTriples = linked.getTriples();
				if (nestedTriples!=null) for ( String triple : nestedTriples ) {
					if (LuceneDoc.parseDirectObjectUrl(triple)==null) {
						sb.append(triple).append(" .\n");
					}
				}
				indirectLinks( linked.getLinks(), hops-1, sb);
			}
		}
	}

	@Override
	public void init() {
		docs = new ArrayList<SolrInputDocument>();
	}

	@Override
	public void done() throws Exception {
		CommonsHttpSolrServer server = new CommonsHttpSolrServer( serverUrl );
		server.add(docs);
		server.commit();
	}

}
