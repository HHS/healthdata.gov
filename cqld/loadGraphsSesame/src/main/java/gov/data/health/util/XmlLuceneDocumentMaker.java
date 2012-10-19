package gov.data.health.util;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 *
 * @author dougHHS
 */
public class XmlLuceneDocumentMaker extends LuceneDocumentMaker {
	private int hops = 1;
	private String fname = "/tmp/doc";
	private int count=0;
	private PrintWriter out = null;
	
	private String getNextFilename() {
		int ones = count%10;
		int tens = (count/10)%10;
		int hundreds =  (count/100)%10;
		int thousands = count/1000;
		count++;
		return String.format("%s_%d%d%d%d.xml", fname, thousands, hundreds, tens, ones);
	}
	
	public XmlLuceneDocumentMaker( String fname, int hops ) {
		this.fname = fname;
		this.hops = hops;
	}

	@Override
	public void addDoc( LuceneDoc doc) throws Exception {
		if (doc==null) return;
		List<List<String>> hopsLists = gatherLinks( doc, hops );
	
		out.println("<doc>");
		out.println( "  <field name=\"url\">"+doc.getUri()+"</field>");
		for (int i=0; i<hops; i++) {
			if (hopsLists.get(i).size() >0) {
				out.println( "  <field name=\""+fieldName[i]+"\">");
				for ( String triple : hopsLists.get(i) ) {
					out.println( "    "+encode( triple )+" .");
				}
				out.println( "  </field>");
			}
		}
		out.println("</doc>\n");
		pushIfReady();
	}
	
	private String encode( String triple ) {
		String enc = triple.replaceAll( "<", "&lt;" );
		String enc1 = enc.replaceAll(">", "&gt;");
		return enc1;
	}

	@Override
	public void init() throws Exception {
		String nextFilename = getNextFilename();
		FileWriter outFile = new FileWriter( nextFilename );
		out = new PrintWriter( outFile );
		out.println("\n<add>");
	}

	@Override
	public void done() {
		out.println("</add>\n");
		out.close();
		out = null;
	}

}
