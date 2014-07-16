Clinical Quality Linked Data (CQLD)

An implementation of a Linked Data API. For more information see [Linked Data API](https://code.google.com/p/linked-data-api/)

[Clinical Quality Information about US Hospitals](http://www.healthdata.gov/cqld)

*Uses a SPARQL endpoint at http://healthdata.gov/sparql 
*Carves up each URI into parameters
*Substitutes parameters into a query string
*Sends the query string to the SPARQL endpoint
*XML results can be sent to an XSLT transform to create a web page
