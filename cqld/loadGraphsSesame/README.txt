#
# To build the all in one jar
#

mvn clean install assembly:single

# 
# To load into sesame a single RDF file (or all RDF files rooted at the specified directory)
#

java -jar target/loadGraphsSesame-1.0.0-jar-with-dependencies.jar CQLD /Users/dougHHS/work/apache-tomcat-6.0.33/webapps/ROOT/hhsFileSystem/cacn/2011-06-07/Final_CAC_National_File_2011_06_07.rdf


#
# To load into Lucene/SOLR/Siren a single RDF file (or all RDF files rooted at the specified directory)
#

 java  -Xms2048m -Xmx2048m  -jar target/loadGraphsSesame-1.0.0-jar-with-dependencies.jar siren /Users/dougHHS/Desktop/rdf/deployTree/20110916/patched/2011-09-16RDF

#
# To load into Lucene/SOLR/Siren a single RDF file (or all RDF files rooted at the specified directory), and include triples up to 3 hops away.
#

 java  -Xms2048m -Xmx2048m  -jar target/loadGraphsSesame-1.0.0-jar-with-dependencies.jar siren /Users/dougHHS/Desktop/rdf/deployTree/20110916/patched/2011-09-16RDF  hops=3

#
# To generate XML files for Lucene/SOLR/Siren a single RDF file (or all RDF files rooted at the specified directory)
#
# In this example, the files are generated as /tmp/myFile_0000.xml, /tmp/myFile_0001.xml, /tmp/myFile_0002.xml, etc.
#

 java  -Xms2048m -Xmx2048m  -jar target/loadGraphsSesame-1.0.0-jar-with-dependencies.jar xml /Users/dougHHS/Desktop/rdf/deployTree/20110916/patched/2011-09-16RDF /tmp/myFile

#
# To generate XML files for Lucene/SOLR/Siren a single RDF file (or all RDF files rooted at the specified directory), and include triples up to 4 hops away
#
# In this example, the files are generated as /tmp/myFile_0000.xml, /tmp/myFile_0001.xml, /tmp/myFile_0002.xml, etc.
#

 java  -Xms2048m -Xmx2048m  -jar target/loadGraphsSesame-1.0.0-jar-with-dependencies.jar xml /Users/dougHHS/Desktop/rdf/deployTree/20110916/patched/2011-09-16RDF   /tmp/myFile hops=4

#
# to manually load the XML files generated above, you need to execute the post.sh in a loop, For example, 
#

 for f in /tmp/myFile*.xml ; do echo posting $f ; ./post.sh $f ; done


#
#
# To run the SPARQL timing test against the Health.data.gov Virtuoso server
#

java -cp target/loadGraphsSesame-1.0.0-jar-with-dependencies.jar gov.data.health.util.CqldTimingTest http://health.data.gov/sparql?query=

#
# To run the SPARQL timing test against the GeoCloud Sesame server
#

java -cp target/loadGraphsSesame-1.0.0-jar-with-dependencies.jar gov.data.health.util.CqldTimingTest http://hprod.dyndns.org:8080/openrdf-workbench/repositories/CQLDUnpersisted/query?query=


