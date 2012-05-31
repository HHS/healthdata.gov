-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- hhsRewriter.sql
-- 
-- Orignal creation date: April 20, 2011
-- Original author: Doug Whitehead
-- 
-- This file contains all of the rewrite rules needed to help
-- HHS serve up Linked Data on Virtuoso.
--
-- This file destroys and re-installs rewriting rules in the 
-- health.data.gov interface for the following contexts:
--    /DAV
--    /cqld
--    /dataset
--    /def
--    /describe
--    /doc
--    /facet
--    /facet/service
--    /file
--    /id
--    /search
--    /sparql
--
-- This file destroys and re-installs rewriting rules in the 
-- reference.data.gov interface for the following contexts:
--    /DAV
--    /cqld
--    /dataset
--    /def
--    /describe
--    /doc
--    /facet
--    /facet/service
--    /file
--    /id
--    /search
--    /sparql
--
-- This file assumes the following vad files are loaded into Virtuoso:
--    fct_dav.vad
--
-- This file can be installed in Virtuoso conductor, by:
--    Bring up ISQL
--       Click on "Interactive SQL (ISQL)", top of the left panel in Virtuoso
--       Check the "Local file" checkbox, near the "Local scipt" label
--       Click the "Browse" button and find this file.
--       Click the "Load" button, near the "Local script" label
--       Click the "Execute" button
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- Change the default for links in facet.vad
-- 
-- This turns off the use of rdfs:label for facet browsing links
-- As such it will default back to dcterms:title
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
registry_set( 'fct_desc_value_labels', '0' );

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- DB.DBA.REDIR_DECODE_URL Stored Procedure
-- 
-- The /describe Rewrite Rules need this procedure to decode a 
-- URL encoded string, so that it may redirect to a proper URL.
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
drop procedure DB.DBA.REDIR_DECODE_URL ;

create procedure DB.DBA.REDIR_DECODE_URL (in par varchar, in fmt varchar, in val varchar) {
  declare arr, i any; 
  declare ret varchar;
  if (0 = length (val))
    return sprintf (fmt, val);   
  arr := split_and_decode ('uri=' || val);
  ret := arr[1];
  if (length(arr) <=2) 
     return sprintf (fmt, ret);
  ret := ret || '?'; 
  for (i := 2; i < length (arr)-2; i := i + 2) 
     ret := ret || sprintf ('%U=%U&', arr[i], arr[i+1]);
  ret := ret || sprintf ('%U=%U', arr[length(arr)-2], arr[length(arr)-1]);
  return sprintf (fmt, ret);   
} ;


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ***************************************************** 
-- Rules for the "reference.data.gov"  interface
-- *****************************************************
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- /DAV
-- 
-- Access WebDAV in the reference.data.gov interface
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
DB.DBA.VHOST_REMOVE (
	 lhost=>'*ini*',
	 vhost=>'reference.data.gov',
	 lpath=>'/DAV'
);

DB.DBA.VHOST_DEFINE (
	 lhost=>'*ini*',
	 vhost=>'reference.data.gov',
	 lpath=>'/DAV',
	 ppath=>'/DAV/',
	 is_dav=>1,
	 vsp_user=>'dba',
	 ses_vars=>0,
	 is_default_host=>NULL
);


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- /cqld
--              Rewrite Rules in the reference.data.gov interface
-- 
-- /cqld is a file system mount point for static content such as web pages
-- The files found there should be readable by all.
--
-- If one wanted to retrieve a filename called about.html, then a rewrite 
-- rule can access it by merely performing a 303 redirect to /cqld/about.html
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
DB.DBA.VHOST_REMOVE (
	 lhost=>'*ini*',
	 vhost=>'reference.data.gov',
	 lpath=>'/cqld'
);

DB.DBA.VHOST_DEFINE (
	 lhost=>'*ini*',
	 vhost=>'reference.data.gov',
	 lpath=>'/cqld',
	 ppath=>'/hhsStaticFiles/',
	 is_dav=>0,
	 def_page=>'about.html',
	 vsp_user=>'dba',
	 ses_vars=>0,
	 opts=>vector ('browse_sheet', ''),
	 is_default_host=>0
);


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- /dataset 
--              Rewrite Rules in the reference.data.gov interface
--
-- Anything that ends in .html is sent to the facet browser for rendering.
-- Other filename extensions include:
--    .n3, .ttl, .json, .csv, .rdf, .txt, .atom, and .ajson
-- 
-- if a resource does not have a file name extension, and if the 
-- Accept Header has been specified, then these rules will redirect
-- to the same resource with the proper filename extension.
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
DB.DBA.VHOST_REMOVE (
	 lhost=>'*ini*',
	 vhost=>'reference.data.gov',
	 lpath=>'/dataset'
);

DB.DBA.VHOST_DEFINE (
	 lhost=>'*ini*',
	 vhost=>'reference.data.gov',
	 lpath=>'/dataset',
	 ppath=>'/',
	 is_dav=>0,
	 def_page=>'',
	 vsp_user=>'dba',
	 ses_vars=>0,
	 opts=>vector ('xml_templates', 'yes', 'browse_sheet', '', 'url_rewrite', 'http_rule_list_7'),
	 is_default_host=>0
);
   

DB.DBA.URLREWRITE_CREATE_RULELIST ( 
'http_rule_list_7', 1, 
  vector ('http_rule_232', 'http_rule_56', 'http_rule_150', 'http_rule_57', 'http_rule_58', 'http_rule_59', 'http_rule_172', 'http_rule_60', 'http_rule_61', 'http_rule_176', 'http_rule_62', 'http_rule_63', 'http_rule_64', 'http_rule_233', 'http_rule_145', 'http_rule_234', 'http_rule_69', 'http_rule_235', 'http_rule_65', 'http_rule_236', 'http_rule_66', 'http_rule_237', 'http_rule_164', 'http_rule_238', 'http_rule_67', 'http_rule_239', 'http_rule_68', 'http_rule_240', 'http_rule_124', 'http_rule_241', 'http_rule_125', 'http_rule_242', 'http_rule_243', 'http_rule_244', 'http_rule_154', 'http_rule_126'));

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_232', 1, 
  '/(dataset/[^.?]*)[.][hH][tT][mM][lL]?[?](.*)$', 
vector ('par_1', 'par_2'), 
2, 
'/fct/rdfdesc/description.vsp?g=http://reference.data.gov/%s&%s', 
vector ('par_1', 'par_2'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_56', 1, 
  '/(dataset/[^.?]*)[.][hH][tT][mM][lL]?$', 
vector ('par_1'), 
1, 
'/fct/rdfdesc/description.vsp?g=http://reference.data.gov/%U', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_150', 1, 
  '/dataset/([^.?]*[0-9][0-9][0-9][0-9]_[0-9][0-9]_[0-9][0-9])[.][rR][dD][fF]$', 
vector ('par_1'), 
1, 
'/file/%s.rdf', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_57', 1, 
  '/(dataset/[^.?]*)[.][rR][dD][fF]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2Freference.data.gov%%2F%U%%3E&format=application/rdf%%2Bxml', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_58', 1, 
  '/(dataset/[^.?]*)[.][nN]3$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2Freference.data.gov%%2F%U%%3E&format=text/rdf%%2Bn3', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_59', 1, 
  '/(dataset/[^.?]*)[.][tT][tT][lL]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2Freference.data.gov%%2F%U%%3E&format=text/rdf%%2Bn3', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_172', 1, 
  '/(dataset/[^.?]*)[.][jJ][sS][oO][nN]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2Freference.data.gov%%2F%U%%3E&format=application/json', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_60', 1, 
  '/(dataset/[^.?]*)[.][rR][jJ][sS][oO][nN]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2Freference.data.gov%%2F%U%%3E&format=application/rdf%%2Bjson', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_61', 1, 
  '/(dataset/[^.?]*)[.][cC][sS][vV]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2Freference.data.gov%%2F%U%%3E&format=text/csv', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_176', 1, 
  '/dataset/([^.?_]*[^0123456789?]*[0-9][0-9][0-9][0-9]_[0-9][0-9]_[0-9][0-9])[.][tT][xX][tT]$', 
vector ('par_1'), 
1, 
'/file/%s.txt', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_62', 1, 
  '/(dataset/[^.?]*)[.][tT][xX][tT]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2Freference.data.gov%%2F%U%%3E&format=text/plain', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_63', 1, 
  '/(dataset/[^.?]*)[.][aA][tT][oO][mM]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2Freference.data.gov%%2F%U%%3E&format=application/atom%%2Bxml', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_64', 1, 
  '/(dataset/[^.?]*)[.][oO][jJ][sS][oO][nN]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2Freference.data.gov%%2F%U%%3E&format=application/odata%%2Bjson', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_233', 1, 
  '(/dataset/[^.?]*)[.]([^?]*)[?].*$', 
vector ('par_1', 'par_2'), 
2, 
'%s.%s', 
vector ('par_1', 'par_2'), 
NULL, 
NULL, 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_145', 1, 
  '(/dataset[^?]*)/$', 
vector ('par_1'), 
1, 
'%s', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_234', 1, 
  '/(dataset/[^.?]*)[?](.*)$', 
vector ('par_1', 'par_2'), 
2, 
'/fct/rdfdesc/description.vsp?g=http://reference.data.gov/%s&%s', 
vector ('par_1', 'par_2'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_69', 1, 
  '/(dataset/[^.?]*)$', 
vector ('par_1'), 
1, 
'/fct/rdfdesc/description.vsp?g=http://reference.data.gov/%s', 
vector ('par_1'), 
NULL, 
'text/html', 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_235', 1, 
  '(/dataset/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.rdf', 
vector ('par_1'), 
NULL, 
'application/rdf+xml', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_65', 1, 
  '(/dataset/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.rdf', 
vector ('par_1'), 
NULL, 
'application/rdf+xml', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_236', 1, 
  '(/dataset/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.n3', 
vector ('par_1'), 
NULL, 
'text/rdf+n3', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_66', 1, 
  '(/dataset/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.n3', 
vector ('par_1'), 
NULL, 
'text/rdf+n3', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_237', 1, 
  '(/dataset/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.json', 
vector ('par_1'), 
NULL, 
'application/json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_164', 1, 
  '(/dataset/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.json', 
vector ('par_1'), 
NULL, 
'application/json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_238', 1, 
  '(/dataset/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.rjson', 
vector ('par_1'), 
NULL, 
'application/rdf+json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_67', 1, 
  '(/dataset/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.rjson', 
vector ('par_1'), 
NULL, 
'application/rdf+json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_239', 1, 
  '(/dataset/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.csv', 
vector ('par_1'), 
NULL, 
'text/csv', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_68', 1, 
  '(/dataset/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.csv', 
vector ('par_1'), 
NULL, 
'text/csv', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_240', 1, 
  '(/dataset/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.atom', 
vector ('par_1'), 
NULL, 
'application/atom+xml', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_124', 1, 
  '(/dataset/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.atom', 
vector ('par_1'), 
NULL, 
'application/atom+xml', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_241', 1, 
  '(/dataset/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.ojson', 
vector ('par_1'), 
NULL, 
'application/odata+json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_125', 1, 
  '(/dataset/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.ojson', 
vector ('par_1'), 
NULL, 
'application/odata+json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_242', 1, 
  '/(dataset)[?](.*)$', 
vector ('par_1', 'par_2'), 
2, 
'/fct/rdfdesc/description.vsp?g=http://reference.data.gov/%s&%s', 
vector ('par_1', 'par_2'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_243', 1, 
  '/(dataset)$', 
vector ('par_1'), 
1, 
'/fct/rdfdesc/description.vsp?g=http://reference.data.gov/%s', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_244', 1, 
  '/(dataset/[^?]*)[?](.*)$', 
vector ('par_1', 'par_2'), 
2, 
'/fct/rdfdesc/description.vsp?g=http://reference.data.gov/%s&%s', 
vector ('par_1', 'par_2'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_154', 1, 
  '/(dataset/.*)$', 
vector ('par_1'), 
1, 
'/fct/rdfdesc/description.vsp?g=http://reference.data.gov/%s', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_126', 1, 
  '/dataset/(.*)$', 
vector ('par_1'), 
1, 
'%s', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
406, 
'' 
);

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- /def 
--              Rewrite Rules in the reference.data.gov interface
--
-- Anything that ends in .html is sent to the facet browser for rendering.
-- Other filename extensions include:
--    .n3, .ttl, .json, .csv, .rdf, .txt, .atom, and .ajson
-- 
-- if a resource does not have a file name extension, and if the 
-- Accept Header has been specified, then these rules will redirect
-- to the same resource with the proper filename extension.
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
DB.DBA.VHOST_REMOVE (
	 lhost=>'*ini*',
	 vhost=>'reference.data.gov',
	 lpath=>'/def'
);

DB.DBA.VHOST_DEFINE (
	 lhost=>'*ini*',
	 vhost=>'reference.data.gov',
	 lpath=>'/def',
	 ppath=>'/',
	 is_dav=>0,
	 def_page=>'',
	 vsp_user=>'dba',
	 ses_vars=>0,
	 opts=>vector ('xml_templates', 'yes', 'browse_sheet', '', 'url_rewrite', 'http_rule_list_8'),
	 is_default_host=>0
);
   

DB.DBA.URLREWRITE_CREATE_RULELIST ( 
'http_rule_list_8', 1, 
  vector ('http_rule_245', 'http_rule_70', 'http_rule_71', 'http_rule_72', 'http_rule_73', 'http_rule_74', 'http_rule_173', 'http_rule_75', 'http_rule_76', 'http_rule_77', 'http_rule_78', 'http_rule_79', 'http_rule_105', 'http_rule_246', 'http_rule_152', 'http_rule_146', 'http_rule_247', 'http_rule_104', 'http_rule_248', 'http_rule_127', 'http_rule_249', 'http_rule_128', 'http_rule_250', 'http_rule_165', 'http_rule_251', 'http_rule_129', 'http_rule_252', 'http_rule_130', 'http_rule_253', 'http_rule_131', 'http_rule_254', 'http_rule_132', 'http_rule_255', 'http_rule_156', 'http_rule_133'));

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_245', 1, 
  '/def/([^.?]*)[.][hH][tT][mM][lL]?[?](.*)$', 
vector ('par_1', 'par_2'), 
2, 
'/fct/rdfdesc/description.vsp?g=http://reference.data.gov/def/%s&%s', 
vector ('par_1', 'par_2'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_70', 1, 
  '/def/([^.?]*)[.][hH][tT][mM][lL]?$', 
vector ('par_1'), 
1, 
'/fct/rdfdesc/description.vsp?g=http://reference.data.gov/def/%U', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_71', 1, 
  '/def/([^.?/]*)[.][rR][dD][fF][sS]$', 
vector ('par_1'), 
1, 
'/file/%s.rdf', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_72', 1, 
  '/(def/[^.?]*)[.][rR][dD][fF]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2Freference.data.gov%%2F%U%%3E&format=application/rdf%%2Bxml', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_73', 1, 
  '/(def/[^.?]*)[.][nN]3$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2Freference.data.gov%%2F%U%%3E&format=text/rdf%%2Bn3', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_74', 1, 
  '/(def/[^.?]*)[.][tT][tT][lL]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2Freference.data.gov%%2F%U%%3E&format=text/rdf%%2Bn3', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_173', 1, 
  '/(def/[^.?]*)[.][jJ][sS][oO][nN]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2Freference.data.gov%%2F%U%%3E&format=application/json', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_75', 1, 
  '/(def/[^.?]*)[.][rR][jJ][sS][oO][nN]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2Freference.data.gov%%2F%U%%3E&format=application/rdf%%2Bjson', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_76', 1, 
  '/(def/[^.?]*)[.][cC][sS][vV]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2Freference.data.gov%%2F%U%%3E&format=text/csv', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_77', 1, 
  '/(def/[^.?]*)[.][tT][xX][tT]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2Freference.data.gov%%2F%U%%3E&format=text/plain', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_78', 1, 
  '/(def/[^.?]*)[.][aA][tT][oO][mM]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2Freference.data.gov%%2F%U%%3E&format=application/atom%%2Bxml', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_79', 1, 
  '/(def/[^.?]*)[.][oO][jJ][sS][oO][nN]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2Freference.data.gov%%2F%U%%3E&format=application/odata%%2Bjson', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_105', 1, 
  '/def/([^.?/]*)/.*[.][rR][dD][fF][sS]$', 
vector ('par_1'), 
1, 
'/def/%s.rdfs', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_246', 1, 
  '/def/([^.?]*)[.]([^?]*)[?].*$', 
vector ('par_1', 'par_2'), 
2, 
'/def/%s.%s', 
vector ('par_1', 'par_2'), 
NULL, 
NULL, 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_152', 1, 
  '/def/([^/]*)/(.*)/$', 
vector ('par_1', 'par_2'), 
2, 
'/def/%s/%s', 
vector ('par_1', 'par_2'), 
NULL, 
NULL, 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_146', 1, 
  '/def/([^?/]+)$', 
vector ('par_1'), 
1, 
'/def/%s/', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_247', 1, 
  '/def/([^.?]*)[?](.*)$', 
vector ('par_1', 'par_2'), 
2, 
'/fct/rdfdesc/description.vsp?g=http://reference.data.gov/def/%s&%s', 
vector ('par_1', 'par_2'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_104', 1, 
  '/def/([^.?]*)$', 
vector ('par_1'), 
1, 
'/fct/rdfdesc/description.vsp?g=http://reference.data.gov/def/%s', 
vector ('par_1'), 
NULL, 
'text/html', 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_248', 1, 
  '(/def/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.rdf', 
vector ('par_1'), 
NULL, 
'application/rdf+xml', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_127', 1, 
  '(/def/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.rdf', 
vector ('par_1'), 
NULL, 
'application/rdf+xml', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_249', 1, 
  '(/def/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.n3', 
vector ('par_1'), 
NULL, 
'text/rdf+n3', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_128', 1, 
  '(/def/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.n3', 
vector ('par_1'), 
NULL, 
'text/rdf+n3', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_250', 1, 
  '(/def/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.json', 
vector ('par_1'), 
NULL, 
'application/json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_165', 1, 
  '(/def/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.json', 
vector ('par_1'), 
NULL, 
'application/json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_251', 1, 
  '(/def/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.rjson', 
vector ('par_1'), 
NULL, 
'application/rdf+json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_129', 1, 
  '(/def/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.rjson', 
vector ('par_1'), 
NULL, 
'application/rdf+json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_252', 1, 
  '(/def/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.csv', 
vector ('par_1'), 
NULL, 
'text/csv', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_130', 1, 
  '(/def/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.csv', 
vector ('par_1'), 
NULL, 
'text/csv', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_253', 1, 
  '(/def/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.atom', 
vector ('par_1'), 
NULL, 
'application/atom+xml', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_131', 1, 
  '(/def/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.atom', 
vector ('par_1'), 
NULL, 
'application/atom+xml', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_254', 1, 
  '(/def/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.ojson', 
vector ('par_1'), 
NULL, 
'application/odata+json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_132', 1, 
  '(/def/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.ojson', 
vector ('par_1'), 
NULL, 
'application/odata+json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_255', 1, 
  '/def/([^?]*)[?](.*)$', 
vector ('par_1', 'par_2'), 
2, 
'/fct/rdfdesc/description.vsp?g=http://reference.data.gov/def/%s&%s', 
vector ('par_1', 'par_2'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_156', 1, 
  '/def/(.*)$', 
vector ('par_1'), 
1, 
'/fct/rdfdesc/description.vsp?g=http://reference.data.gov/def/%s', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_133', 1, 
  '/def/(.*)$', 
vector ('par_1'), 
1, 
'%s', 
vector ('par_1'), 
NULL, 
NULL, 
2, 
406, 
'' 
);


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- /describe 
--              Rewrite Rules in the reference.data.gov interface
-- 
-- The Facet Browser library fct_dav.vad generates all of its links
-- with /describe/?url=whatever
-- This rule simply goes to the embedded URL.
--
-- Note - This rule uses the DB.DBA.REDIR_DECODE_URL stored procedure.
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
DB.DBA.VHOST_REMOVE (
	 lhost=>'*ini*',
	 vhost=>'reference.data.gov',
	 lpath=>'/describe'
);

DB.DBA.VHOST_DEFINE (
	 lhost=>'*ini*',
	 vhost=>'reference.data.gov',
	 lpath=>'/describe',
	 ppath=>'/SOAP/Http/EXT_HTTP_PROXY_1',
	 is_dav=>0,
	 soap_user=>'PROXY',
	 ses_vars=>0,
	 opts=>vector ('url_rewrite', 'http_rule_list_11'),
	 is_default_host=>0
);


DB.DBA.URLREWRITE_CREATE_RULELIST ( 
'http_rule_list_11', 1, 
  vector ('http_rule_102', 'http_rule_101'));

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_102', 1, 
  '/describe/[?]ur[li]=(.*)$', 
vector ('par_1'), 
1, 
'%s', 
vector ('par_1'), 
'DB.DBA.REDIR_DECODE_URL', 
NULL, 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_101', 1, 
  '/describe/[?]ur[li]=(http%3A%2F%2F.*data.gov%2Fdef%2F.*)$', 
vector ('par_1'), 
1, 
'%s', 
vector ('par_1'), 
'DB.DBA.REDIR_DECODE_URL_ADD_HTML', 
NULL, 
1, 
303, 
'' 
);


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- /doc 
--              Rewrite Rules in the reference.data.gov interface
-- 
-- /doc is a parallel tree to /id that contains documents about /id things.
--
-- Anything that ends in .html is sent to the facet browser for rendering.
-- Other filename extensions include:
--    .n3, .ttl, .json, .csv, .rdf, .txt, .atom, and .ajson
-- 
-- if a resource does not have a file name extension, and if the 
-- Accept Header has been specified, then these rules will redirect
-- to the same resource with the proper filename extension.
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
DB.DBA.VHOST_REMOVE (
	 lhost=>'*ini*',
	 vhost=>'reference.data.gov',
	 lpath=>'/doc'
);

DB.DBA.VHOST_DEFINE (
	 lhost=>'*ini*',
	 vhost=>'reference.data.gov',
	 lpath=>'/doc',
	 ppath=>'/',
	 is_dav=>0,
	 def_page=>'',
	 vsp_user=>'dba',
	 ses_vars=>0,
	 opts=>vector ('xml_templates', 'yes', 'browse_sheet', '', 'url_rewrite', 'http_rule_list_9'),
	 is_default_host=>0
);


DB.DBA.URLREWRITE_CREATE_RULELIST ( 
'http_rule_list_9', 1, 
  vector ('http_rule_256', 'http_rule_81', 'http_rule_82', 'http_rule_83', 'http_rule_174', 'http_rule_84', 'http_rule_85', 'http_rule_86', 'http_rule_87', 'http_rule_88', 'http_rule_89', 'http_rule_257', 'http_rule_147', 'http_rule_258', 'http_rule_94', 'http_rule_259', 'http_rule_90', 'http_rule_260', 'http_rule_91', 'http_rule_261', 'http_rule_166', 'http_rule_262', 'http_rule_92', 'http_rule_263', 'http_rule_93', 'http_rule_264', 'http_rule_158', 'http_rule_136'));

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_256', 1, 
  '/doc/([^.?]*)[.][hH][tT][mM][lL]?[?](.*)$', 
vector ('par_1', 'par_2'), 
2, 
'/fct/rdfdesc/description.vsp?g=http://reference.data.gov/id/%s&%s', 
vector ('par_1', 'par_2'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_81', 1, 
  '/doc/([^.?]*)[.][hH][tT][mM][lL]?$', 
vector ('par_1'), 
1, 
'/fct/rdfdesc/description.vsp?g=http://reference.data.gov/id/%s', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_82', 1, 
  '/doc/([^.?]*)[.][nN]3$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2Freference.data.gov%%2Fid%%2F%s%%3E&format=text/rdf%%2Bn3', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_83', 1, 
  '/doc/([^.?]*)[.][tT][tT][lL]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2Freference.data.gov%%2Fid%%2F%s%%3E&format=text/rdf%%2Bn3', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_174', 1, 
  '/doc/([^./]*)[.][jJ][sS][oO][nN]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2Freference.data.gov%%2Fid%%2F%s%%3E&format=application/json', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_84', 1, 
  '/doc/([^.?]*)[.][rR][jJ][sS][oO][nN]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2Freference.data.gov%%2Fid%%2F%s%%3E&format=application/rdf%%2Bjson', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_85', 1, 
  '/doc/([^.?]*)[.][cC][sS][vV]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2Freference.data.gov%%2Fid%%2F%s%%3E&format=text/csv', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_86', 1, 
  '/doc/([^.?]*)[.][rR][dD][fF]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2Freference.data.gov%%2Fid%%2F%s%%3E&format=application/rdf%%2Bxml', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_87', 1, 
  '/doc/([^.?]*)[.][tT][xX][tT]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2Freference.data.gov%%2Fid%%2F%s%%3E&format=text/plain', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_88', 1, 
  '/doc/([^.?]*)[.][aA][tT][oO][mM]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2Freference.data.gov%%2Fid%%2F%s%%3E&format=application/atom%%2Bxml', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_89', 1, 
  '/doc/([^.?]*)[.][oO][jJ][sS][oO][nN]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2Freference.data.gov%%2Fid%%2F%s%%3E&format=application/odata%%2Bjson', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_257', 1, 
  '(/doc/[^.?]*)[.]([^?]*)[?].*$', 
vector ('par_1', 'par_2'), 
2, 
'%s.%s', 
vector ('par_1', 'par_2'), 
NULL, 
NULL, 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_147', 1, 
  '/doc/([^?]*)/$', 
vector ('par_1'), 
1, 
'/doc/%s', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_258', 1, 
  '/doc/([^.?]*)[?](.*)$', 
vector ('par_1', 'par_2'), 
2, 
'/fct/rdfdesc/description.vsp?g=http://reference.data.gov/id/%s&%s', 
vector ('par_1', 'par_2'), 
NULL, 
'text/html', 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_94', 1, 
  '/doc/([^.?]*)$', 
vector ('par_1'), 
1, 
'/fct/rdfdesc/description.vsp?g=http://reference.data.gov/id/%s', 
vector ('par_1'), 
NULL, 
'text/html', 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_259', 1, 
  '(/doc/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.rdf', 
vector ('par_1'), 
NULL, 
'application/rdf+xml', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_90', 1, 
  '(/doc/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.rdf', 
vector ('par_1'), 
NULL, 
'application/rdf+xml', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_260', 1, 
  '(/doc/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.n3', 
vector ('par_1'), 
NULL, 
'text/rdf+n3', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_91', 1, 
  '(/doc/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.n3', 
vector ('par_1'), 
NULL, 
'text/rdf+n3', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_261', 1, 
  '(/doc/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.json', 
vector ('par_1'), 
NULL, 
'application/json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_166', 1, 
  '(/doc/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.json', 
vector ('par_1'), 
NULL, 
'application/json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_262', 1, 
  '(/doc/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.rjson', 
vector ('par_1'), 
NULL, 
'application/rdf+json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_92', 1, 
  '(/doc/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.rjson', 
vector ('par_1'), 
NULL, 
'application/rdf+json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_263', 1, 
  '(/doc/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.csv', 
vector ('par_1'), 
NULL, 
'text/csv', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_93', 1, 
  '(/doc/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.csv', 
vector ('par_1'), 
NULL, 
'text/csv', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_264', 1, 
  '/doc/([^?]*)[?](.*)$', 
vector ('par_1', 'par_2'), 
2, 
'/fct/rdfdesc/description.vsp?g=http://reference.data.gov/id/%s&%s', 
vector ('par_1', 'par_2'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_158', 1, 
  '/doc/(.*)$', 
vector ('par_1'), 
1, 
'/fct/rdfdesc/description.vsp?g=http://reference.data.gov/id/%s', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_136', 1, 
  '/doc/(.*)$', 
vector ('par_1'), 
1, 
'%s', 
vector ('par_1'), 
NULL, 
NULL, 
2, 
406, 
'' 
);


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- /facet
-- 
-- Access the facet browser in the reference.data.gov interface
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
DB.DBA.VHOST_REMOVE (
	 lhost=>'*ini*',
	 vhost=>'reference.data.gov',
	 lpath=>'/facet'
);

DB.DBA.VHOST_DEFINE (
	 lhost=>'*ini*',
	 vhost=>'reference.data.gov',
	 lpath=>'/facet',
	 ppath=>'/DAV/VAD/fct/',
	 is_dav=>1,
	 def_page=>'facet.vsp',
	 vsp_user=>'dba',
	 ses_vars=>0,
	 is_default_host=>0
);


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- /facet/service
-- 
-- Access the facet web service in the reference.data.gov interface
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
DB.DBA.VHOST_REMOVE (
	 lhost=>'*ini*',
	 vhost=>'reference.data.gov',
	 lpath=>'/facet/service'
);

DB.DBA.VHOST_DEFINE (
	 lhost=>'*ini*',
	 vhost=>'reference.data.gov',
	 lpath=>'/facet/service',
	 ppath=>'/SOAP/Http/fct_svc',
	 is_dav=>0,
	 soap_user=>'dba',
	 ses_vars=>0,
	 is_default_host=>0
);


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- /fct
-- 
-- Access the facet browser in the reference.data.gov interface
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
DB.DBA.VHOST_REMOVE (
	 lhost=>'*ini*',
	 vhost=>'reference.data.gov',
	 lpath=>'/fct'
);

DB.DBA.VHOST_DEFINE (
	 lhost=>'*ini*',
	 vhost=>'reference.data.gov',
	 lpath=>'/fct',
	 ppath=>'/DAV/VAD/fct/',
	 is_dav=>1,
	 def_page=>'facet.vsp',
	 vsp_user=>'dba',
	 ses_vars=>0,
	 is_default_host=>0
);


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- /fct/service
-- 
-- Access the facet web service in the reference.data.gov interface
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
DB.DBA.VHOST_REMOVE (
	 lhost=>'*ini*',
	 vhost=>'reference.data.gov',
	 lpath=>'/fct/service'
);

DB.DBA.VHOST_DEFINE (
	 lhost=>'*ini*',
	 vhost=>'reference.data.gov',
	 lpath=>'/fct/service',
	 ppath=>'/SOAP/Http/fct_svc',
	 is_dav=>0,
	 soap_user=>'dba',
	 ses_vars=>0,
	 is_default_host=>0
);


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- /file 
--              Rewrite Rules in the reference.data.gov interface
-- 
-- /file is a file system mount point for rdfs and rdf files used in CQLD
-- The files found there should be readable by all.
--
-- If one wanted to retrieve a filename called foo.rdfs, then a rewrite 
-- rule can access it by merely performing a 303 redirect to /file/foo.rdfs
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
DB.DBA.VHOST_REMOVE (
	 lhost=>'*ini*',
	 vhost=>'reference.data.gov',
	 lpath=>'/file'
);

DB.DBA.VHOST_DEFINE (
	 lhost=>'*ini*',
	 vhost=>'reference.data.gov',
	 lpath=>'/file',
	 ppath=>'/hhsFileSystem/',
	 is_dav=>0,
	 def_page=>'',
	 vsp_user=>'dba',
	 ses_vars=>0,
	 opts=>vector ('browse_sheet', ''),
	 is_default_host=>0
);


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- /id 
--              Rewrite Rules in the reference.data.gov interface
-- 
-- /id has a parallel tree, namely /doc for documents about /id things.
-- So most anything requested will be redirected to the proper /doc document.
--
-- Anything that ends in .html is sent to the facet browser for rendering.
-- Other filename extensions include:
--    .n3, .ttl, .json, .csv, .rdf, .txt, .atom, and .ajson
-- 
-- if a resource does not have a file name extension, and if the 
-- Accept Header has been specified, then these rules will redirect
-- to the same resource with the proper filename extension.
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
DB.DBA.VHOST_REMOVE (
	 lhost=>'*ini*',
	 vhost=>'reference.data.gov',
	 lpath=>'/id'
);

DB.DBA.VHOST_DEFINE (
	 lhost=>'*ini*',
	 vhost=>'reference.data.gov',
	 lpath=>'/id',
	 ppath=>'/',
	 is_dav=>0,
	 def_page=>'',
	 vsp_user=>'dba',
	 ses_vars=>0,
	 opts=>vector ('xml_templates', 'yes', 'browse_sheet', '', 'url_rewrite', 'http_rule_list_10'),
	 is_default_host=>0
);


DB.DBA.URLREWRITE_CREATE_RULELIST ( 
'http_rule_list_10', 1, 
  vector ('http_rule_265', 'http_rule_148', 'http_rule_266', 'http_rule_95', 'http_rule_267', 'http_rule_100', 'http_rule_268', 'http_rule_96', 'http_rule_269', 'http_rule_97', 'http_rule_270', 'http_rule_98', 'http_rule_271', 'http_rule_167', 'http_rule_272', 'http_rule_99', 'http_rule_273', 'http_rule_137', 'http_rule_274', 'http_rule_138', 'http_rule_160', 'http_rule_139'));

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_265', 1, 
  '/id/([^?]*)/[?](.*)$', 
vector ('par_1', 'par_2'), 
2, 
'/id/%s?%s', 
vector ('par_1', 'par_2'), 
NULL, 
NULL, 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_148', 1, 
  '/id/([^?]*)/$', 
vector ('par_1'), 
1, 
'/id/%s', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_266', 1, 
  '/id/([^.?]*[.][^.?]*)[?](.*)$', 
vector ('par_1', 'par_2'), 
2, 
'/doc/%s?%s', 
vector ('par_1', 'par_2'), 
NULL, 
NULL, 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_95', 1, 
  '/id/([^.?]*[.][^.?]*)$', 
vector ('par_1'), 
1, 
'/doc/%s', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_267', 1, 
  '/id/([^.?]*)[?](.*)$', 
vector ('par_1', 'par_2'), 
2, 
'/doc/%s?%s', 
vector ('par_1', 'par_2'), 
NULL, 
'text/html', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_100', 1, 
  '/id/([^.?]*)$', 
vector ('par_1'), 
1, 
'/doc/%s', 
vector ('par_1'), 
NULL, 
'text/html', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_268', 1, 
  '/id/([^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'/doc/%s.n3', 
vector ('par_1'), 
NULL, 
'text/rdf+n3', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_96', 1, 
  '/id/([^.?]*)$', 
vector ('par_1'), 
1, 
'/doc/%s.n3', 
vector ('par_1'), 
NULL, 
'text/rdf+n3', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_269', 1, 
  '/id/([^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'/doc/%s.csv', 
vector ('par_1'), 
NULL, 
'text/csv', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_97', 1, 
  '/id/([^.?]*)$', 
vector ('par_1'), 
1, 
'/doc/%s.csv', 
vector ('par_1'), 
NULL, 
'text/csv', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_270', 1, 
  '/id/([^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'/doc/%s.rdf', 
vector ('par_1'), 
NULL, 
'application/rdf+xml', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_98', 1, 
  '/id/([^.?]*)$', 
vector ('par_1'), 
1, 
'/doc/%s.rdf', 
vector ('par_1'), 
NULL, 
'application/rdf+xml', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_271', 1, 
  '/id/([^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'/doc/%s.json', 
vector ('par_1'), 
NULL, 
'application/json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_167', 1, 
  '/id/([^.?]*)$', 
vector ('par_1'), 
1, 
'/doc/%s.json', 
vector ('par_1'), 
NULL, 
'application/json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_272', 1, 
  '/id/([^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'/doc/%s.rjson', 
vector ('par_1'), 
NULL, 
'application/rdf+json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_99', 1, 
  '/id/([^.?]*)$', 
vector ('par_1'), 
1, 
'/doc/%s.rjson', 
vector ('par_1'), 
NULL, 
'application/rdf+json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_273', 1, 
  '/id/([^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'/doc/%s.atom', 
vector ('par_1'), 
NULL, 
'application/atom+xml', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_137', 1, 
  '/id/([^.?]*)$', 
vector ('par_1'), 
1, 
'/doc/%s.atom', 
vector ('par_1'), 
NULL, 
'application/atom+xml', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_274', 1, 
  '/id/([^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'/doc/%s.ojson', 
vector ('par_1'), 
NULL, 
'application/odata+json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_138', 1, 
  '/id/([^.?]*)$', 
vector ('par_1'), 
1, 
'/doc/%s.ojson', 
vector ('par_1'), 
NULL, 
'application/odata+json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_160', 1, 
  '/id/(.*)$', 
vector ('par_1'), 
1, 
'/doc/%s', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_139', 1, 
  '/id/(.*)$', 
vector ('par_1'), 
1, 
'%s', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
406, 
'' 
);


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- /search
-- 
-- Access the sparql processor in the reference.data.gov interface
-- This is equivalent to /fct (search just seems like a better name)
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
DB.DBA.VHOST_REMOVE (
	 lhost=>'*ini*',
	 vhost=>'reference.data.gov',
	 lpath=>'/search'
);

DB.DBA.VHOST_DEFINE (
	 lhost=>'*ini*',
	 vhost=>'reference.data.gov',
	 lpath=>'/search',
	 ppath=>'/',
	 is_dav=>0,
	 def_page=>'',
	 vsp_user=>'dba',
	 ses_vars=>0,
	 opts=>vector ('xml_templates', 'yes', 'browse_sheet', '', 'url_rewrite', 'http_rule_list_13'),
	 is_default_host=>0
);
   

DB.DBA.URLREWRITE_CREATE_RULELIST ( 
'http_rule_list_13', 1, 
  vector ('http_rule_109'));

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_109', 1, 
  '/search(/.*)$', 
vector ('par_1'), 
1, 
'/fct%s', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- /sparql
-- 
-- Access the sparql processor in the reference.data.gov interface
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
DB.DBA.VHOST_REMOVE (
	 lhost=>'*ini*',
	 vhost=>'reference.data.gov',
	 lpath=>'/sparql'
);

DB.DBA.VHOST_DEFINE (
	 lhost=>'*ini*',
	 vhost=>'reference.data.gov',
	 lpath=>'/sparql',
	 ppath=>'/!sparql/',
	 is_dav=>1,
	 vsp_user=>'dba',
	 ses_vars=>0,
	 opts=>vector ('noinherit', 1),
	 is_default_host=>0
);


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ***************************************************** 
-- Rules for the health.data.gov interface
-- *****************************************************
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- /DAV
-- 
-- Access to webDAV in the health.data.gov interface
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
DB.DBA.VHOST_REMOVE (
	 lhost=>'*ini*',
	 vhost=>'health.data.gov',
	 lpath=>'/DAV'
);

DB.DBA.VHOST_DEFINE (
	 lhost=>'*ini*',
	 vhost=>'health.data.gov',
	 lpath=>'/DAV',
	 ppath=>'/DAV/',
	 is_dav=>1,
	 vsp_user=>'dba',
	 ses_vars=>0,
	 is_default_host=>NULL
);

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- /cqld
--              Rewrite Rules in the health.data.gov interface
-- 
-- /cqld is a file system mount point for static content such as web pages
-- The files found there should be readable by all.
--
-- If one wanted to retrieve a filename called about.html, then a rewrite 
-- rule can access it by merely performing a 303 redirect to /cqld/about.html
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
DB.DBA.VHOST_REMOVE (
	 lhost=>'*ini*',
	 vhost=>'health.data.gov',
	 lpath=>'/cqld'
);

DB.DBA.VHOST_DEFINE (
	 lhost=>'*ini*',
	 vhost=>'health.data.gov',
	 lpath=>'/cqld',
	 ppath=>'/hhsStaticFiles/',
	 is_dav=>0,
	 def_page=>'about.html',
	 vsp_user=>'dba',
	 ses_vars=>0,
	 opts=>vector ('browse_sheet', ''),
	 is_default_host=>0
);

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- /
--              Rewrite Rules in the health.data.gov interface
--
-- Anything that ends in .html is sent to the facet browser for rendering.
-- Other filename extensions include:
--    .n3, .ttl, .json, .csv, .rdf, .txt, .atom, and .ajson
-- 
-- if a resource does not have a file name extension, and if the 
-- Accept Header has been specified, then these rules will redirect
-- to the same resource with the proper filename extension.
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
DB.DBA.VHOST_REMOVE (
	 lhost=>'*ini*',
	 vhost=>'health.data.gov',
	 lpath=>'/'
);

DB.DBA.VHOST_DEFINE (
	 lhost=>'*ini*',
	 vhost=>'health.data.gov',
	 lpath=>'/',
	 ppath=>'/',
	 is_dav=>0,
	 def_page=>'',
	 vsp_user=>'dba',
	 ses_vars=>0,
	 opts=>vector ('xml_templates', 'yes', 'browse_sheet', '', 'url_rewrite', 'http_rule_list_14'),
	 is_default_host=>0
);


    

DB.DBA.URLREWRITE_CREATE_RULELIST ( 
'http_rule_list_14', 1, 
  vector ('http_rule_275', 'http_rule_276', 'http_rule_277', 'http_rule_278', 'http_rule_279', 'http_rule_280', 'http_rule_281'));

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_275', 1, 
  '/(dataset).[rR][dD][fF]$', 
vector (), 
0, 
'http://health.data.gov/sparql?default-graph-uri=&query=define+sql%%3Adescribe-mode+%%22CBD%%22+DESCRIBE+%%3Chttp%%3A%%2F%%2Fhealth.data.gov%%2Fdataset%%3E&format=text%%2Fplain&timeout=0', 
vector (), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_276', 1, 
  '/(dataset)[.][nN]3$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2F^{URIQADefaultHost}^%%2F%U%%3E&format=text/rdf%%2Bn3', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_277', 1, 
  '/(dataset)[.][tT][tT][lL]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2F^{URIQADefaultHost}^%%2F%U%%3E&format=text/rdf%%2Bn3', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_278', 1, 
  '/(dataset)[.][jJ][sS][oO][nN]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2F^{URIQADefaultHost}^%%2F%U%%3E&format=application/json', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_279', 1, 
  '/(dataset)[.][rR][jJ][sS][oO][nN]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2F^{URIQADefaultHost}^%%2F%U%%3E&format=application/rdf%%2Bjson', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_280', 1, 
  '/(dataset)[.][cC][sS][vV]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2F^{URIQADefaultHost}^%%2F%U%%3E&format=text/csv', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_281', 1, 
  '/(dataset)[.][tT][xX][tT]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2F^{URIQADefaultHost}^%%2F%U%%3E&format=text/plain', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- /dataset 
--              Rewrite Rules in the health.data.gov interface
--
-- Anything that ends in .html is sent to the facet browser for rendering.
-- Other filename extensions include:
--    .n3, .ttl, .json, .csv, .rdf, .txt, .atom, and .ajson
-- 
-- if a resource does not have a file name extension, and if the 
-- Accept Header has been specified, then these rules will redirect
-- to the same resource with the proper filename extension.
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
DB.DBA.VHOST_REMOVE (
	 lhost=>'*ini*',
	 vhost=>'health.data.gov',
	 lpath=>'/dataset'
);

DB.DBA.VHOST_DEFINE (
	 lhost=>'*ini*',
	 vhost=>'health.data.gov',
	 lpath=>'/dataset',
	 ppath=>'/',
	 is_dav=>0,
	 def_page=>'',
	 vsp_user=>'dba',
	 ses_vars=>0,
	 opts=>vector ('xml_templates', 'yes', 'browse_sheet', '', 'url_rewrite', 'http_rule_list_2'),
	 is_default_host=>0
);


DB.DBA.URLREWRITE_CREATE_RULELIST ( 
'http_rule_list_2', 1, 
  vector ('http_rule_201', 'http_rule_2', 'http_rule_149', 'http_rule_3', 'http_rule_4', 'http_rule_5', 'http_rule_170', 'http_rule_6', 'http_rule_7', 'http_rule_175', 'http_rule_8', 'http_rule_9', 'http_rule_10', 'http_rule_202', 'http_rule_141', 'http_rule_203', 'http_rule_15', 'http_rule_204', 'http_rule_11', 'http_rule_205', 'http_rule_12', 'http_rule_206', 'http_rule_161', 'http_rule_207', 'http_rule_13', 'http_rule_208', 'http_rule_14', 'http_rule_209', 'http_rule_110', 'http_rule_210', 'http_rule_111', 'http_rule_211', 'http_rule_140', 'http_rule_212', 'http_rule_153', 'http_rule_112'));

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_201', 1, 
  '/(dataset/[^.?]*)[.][hH][tT][mM][lL]?[?](.*)$', 
vector ('par_1', 'par_2'), 
2, 
'/fct/rdfdesc/description.vsp?g=http://^{URIQADefaultHost}^/%s&%s', 
vector ('par_1', 'par_2'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_2', 1, 
  '/(dataset/[^.?]*)[.][hH][tT][mM][lL]?$', 
vector ('par_1'), 
1, 
'/fct/rdfdesc/description.vsp?g=http://^{URIQADefaultHost}^/%U', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_149', 1, 
  '/dataset/([^.?]*[0-9][0-9][0-9][0-9]_[0-9][0-9]_[0-9][0-9])[.][rR][dD][fF]$', 
vector ('par_1'), 
1, 
'/file/%s.rdf', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_3', 1, 
  '/(dataset/[^.?]*)[.][rR][dD][fF]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2F^{URIQADefaultHost}^%%2F%U%%3E&format=application/rdf%%2Bxml', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_4', 1, 
  '/(dataset/[^.?]*)[.][nN]3$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2F^{URIQADefaultHost}^%%2F%U%%3E&format=text/rdf%%2Bn3', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_5', 1, 
  '/(dataset/[^.?]*)[.][tT][tT][lL]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2F^{URIQADefaultHost}^%%2F%U%%3E&format=text/rdf%%2Bn3', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_170', 1, 
  '/(dataset/[^.?]*)[.][jJ][sS][oO][nN]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2F^{URIQADefaultHost}^%%2F%U%%3E&format=application/json', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_6', 1, 
  '/(dataset/[^.?]*)[.][rR][jJ][sS][oO][nN]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2F^{URIQADefaultHost}^%%2F%U%%3E&format=application/rdf%%2Bjson', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_7', 1, 
  '/(dataset/[^.?]*)[.][cC][sS][vV]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2F^{URIQADefaultHost}^%%2F%U%%3E&format=text/csv', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_175', 1, 
  '/dataset/([^.?_]*[^0123456789?]*[0-9][0-9][0-9][0-9]_[0-9][0-9]_[0-9][0-9])[.][tT][xX][tT]$', 
vector ('par_1'), 
1, 
'/file/%s.txt', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_8', 1, 
  '/(dataset/[^.?]*)[.][tT][xX][tT]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2F^{URIQADefaultHost}^%%2F%U%%3E&format=text/plain', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_9', 1, 
  '/(dataset/[^.?]*)[.][aA][tT][oO][mM]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2F^{URIQADefaultHost}^%%2F%U%%3E&format=application/atom%%2Bxml', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_10', 1, 
  '/(dataset/[^.?]*)[.][oO][jJ][sS][oO][nN]$', 
vector ('par_1'), 
1, 
'/sparql?query=describe%%20%%3Chttp%%3A%%2F%%2F^{URIQADefaultHost}^%%2F%U%%3E&format=application/odata%%2Bjson', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_202', 1, 
  '(/dataset/[^.?]*)[.]([^?]*)[?].*$', 
vector ('par_1', 'par_2'), 
2, 
'%s.%s', 
vector ('par_1', 'par_2'), 
NULL, 
NULL, 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_141', 1, 
  '(/dataset[^?]*)/$', 
vector ('par_1'), 
1, 
'%s', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_203', 1, 
  '/(dataset/[^.?]*)[?](.*)$', 
vector ('par_1', 'par_2'), 
2, 
'/fct/rdfdesc/description.vsp?g=http://^{URIQADefaultHost}^/%s&%s', 
vector ('par_1', 'par_2'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_15', 1, 
  '/(dataset/[^.?]*)$', 
vector ('par_1'), 
1, 
'/fct/rdfdesc/description.vsp?g=http://^{URIQADefaultHost}^/%s', 
vector ('par_1'), 
NULL, 
'text/html', 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_204', 1, 
  '(/dataset/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.rdf', 
vector ('par_1'), 
NULL, 
'application/rdf+xml', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_11', 1, 
  '(/dataset/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.rdf', 
vector ('par_1'), 
'$s1.rdf', 
'application/rdf+xml', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_205', 1, 
  '(/dataset/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.n3', 
vector ('par_1'), 
NULL, 
'text/rdf+n3', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_12', 1, 
  '(/dataset/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.n3', 
vector ('par_1'), 
NULL, 
'text/rdf+n3', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_206', 1, 
  '(/dataset/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.json', 
vector ('par_1'), 
NULL, 
'application/json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_161', 1, 
  '(/dataset/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.json', 
vector ('par_1'), 
NULL, 
'application/json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_207', 1, 
  '(/dataset/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.rjson', 
vector ('par_1'), 
NULL, 
'application/rdf+json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_13', 1, 
  '(/dataset/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.rjson', 
vector ('par_1'), 
NULL, 
'application/rdf+json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_208', 1, 
  '(/dataset/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.csv', 
vector ('par_1'), 
NULL, 
'text/csv', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_14', 1, 
  '(/dataset/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.csv', 
vector ('par_1'), 
NULL, 
'text/csv', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_209', 1, 
  '(/dataset/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.atom', 
vector ('par_1'), 
NULL, 
'application/atom+xml', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_110', 1, 
  '(/dataset/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.atom', 
vector ('par_1'), 
NULL, 
'application/atom+xml', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_210', 1, 
  '(/dataset/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.ojson', 
vector ('par_1'), 
NULL, 
'application/odata+json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_111', 1, 
  '(/dataset/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.ojson', 
vector ('par_1'), 
NULL, 
'application/odata+json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_211', 1, 
  '/(dataset)[?](.*)$', 
vector ('par_1', 'par_2'), 
2, 
'/fct/rdfdesc/description.vsp?g=http://^{URIQADefaultHost}^/%s&%s', 
vector ('par_1', 'par_2'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_140', 1, 
  '/(dataset)$', 
vector ('par_1'), 
1, 
'/fct/rdfdesc/description.vsp?g=http://^{URIQADefaultHost}^/%s', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_212', 1, 
  '/(dataset/[^?]*)[?](.*)$', 
vector ('par_1', 'par_2'), 
2, 
'/fct/rdfdesc/description.vsp?g=http://^{URIQADefaultHost}^/%s&%s', 
vector ('par_1', 'par_2'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_153', 1, 
  '/(dataset/.*)$', 
vector ('par_1'), 
1, 
'/fct/rdfdesc/description.vsp?g=http://^{URIQADefaultHost}^/%s', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_112', 1, 
  '/dataset/(.*)$', 
vector ('par_1'), 
1, 
'%s', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
406, 
'' 
);


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- /def 
--              Rewrite Rules in the health.data.gov interface
--
-- Anything that ends in .html is sent to the facet browser for rendering.
-- Other filename extensions include:
--    .n3, .ttl, .json, .csv, .rdf, .txt, .atom, and .ajson
-- 
-- if a resource does not have a file name extension, and if the 
-- Accept Header has been specified, then these rules will redirect
-- to the same resource with the proper filename extension.
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
DB.DBA.VHOST_REMOVE (
	 lhost=>'*ini*',
	 vhost=>'health.data.gov',
	 lpath=>'/def'
);

DB.DBA.VHOST_DEFINE (
	 lhost=>'*ini*',
	 vhost=>'health.data.gov',
	 lpath=>'/def',
	 ppath=>'/',
	 is_dav=>0,
	 def_page=>'',
	 vsp_user=>'dba',
	 ses_vars=>0,
	 opts=>vector ('xml_templates', 'yes', 'browse_sheet', '', 'url_rewrite', 'http_rule_list_3'),
	 is_default_host=>0
);


DB.DBA.URLREWRITE_CREATE_RULELIST ( 
'http_rule_list_3', 1, 
  vector ('http_rule_179', 'http_rule_16', 'http_rule_17', 'http_rule_18', 'http_rule_19', 'http_rule_20', 'http_rule_21', 'http_rule_171', 'http_rule_22', 'http_rule_23', 'http_rule_24', 'http_rule_25', 'http_rule_26', 'http_rule_180', 'http_rule_151', 'http_rule_142', 'http_rule_177', 'http_rule_103', 'http_rule_194', 'http_rule_113', 'http_rule_195', 'http_rule_114', 'http_rule_196', 'http_rule_162', 'http_rule_197', 'http_rule_115', 'http_rule_198', 'http_rule_116', 'http_rule_199', 'http_rule_117', 'http_rule_200', 'http_rule_118', 'http_rule_178', 'http_rule_155', 'http_rule_119'));

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_179', 1, 
  '/def/([^.?]*)[.][hH][tT][mM][lL]?[?](.*)$', 
vector ('par_1', 'par_2'), 
2, 
'/fct/rdfdesc/description.vsp?g=http://^{URIQADefaultHost}^/def/%s&%s', 
vector ('par_1', 'par_2'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_16', 1, 
  '/def/([^.?]*)[.][hH][tT][mM][lL]?$', 
vector ('par_1'), 
1, 
'/fct/rdfdesc/description.vsp?g=http://^{URIQADefaultHost}^/def/%s', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_17', 1, 
  '/def/([^.?/]*)[.][rR][dD][fF][sS]$', 
vector ('par_1'), 
1, 
'/file/%s.rdf', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_18', 1, 
  '/(def/[^.?]*)[.][rR][dD][fF]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2F^{URIQADefaultHost}^%%2F%U%%3E&format=application/rdf%%2Bxml', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_19', 1, 
  '/(def/[^.?]*)[.][nN]3$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2F^{URIQADefaultHost}^%%2F%U%%3E&format=text/rdf%%2Bn3', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_20', 1, 
  '/(def/[^.?]*)[.][tT][tT][lL]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2F^{URIQADefaultHost}^%%2F%U%%3E&format=text/rdf%%2Bn3', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_21', 1, 
  '/(def/[^.?]*)[.][jJ][sS][oO][nN]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2F^{URIQADefaultHost}^%%2F%U%%3E&format=application/json', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_171', 1, 
  '/(def/[^.?]*)[.][rR][jJ][sS][oO][nN]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2F^{URIQADefaultHost}^%%2F%U%%3E&format=application/rdf%%2Bjson', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_22', 1, 
  '/(def/[^.?]*)[.][cC][sS][vV]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2F^{URIQADefaultHost}^%%2F%U%%3E&format=text/csv', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_23', 1, 
  '/(def/[^.?]*)[.][tT][xX][tT]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2F^{URIQADefaultHost}^%%2F%U%%3E&format=text/plain', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_24', 1, 
  '/(def/[^.?]*)[.][aA][tT][oO][mM]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2F^{URIQADefaultHost}^%%2F%U%%3E&format=application/atom%%2Bxml', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_25', 1, 
  '/(def/[^.?]*)[.][oO][jJ][sS][oO][nN]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2F^{URIQADefaultHost}^%%2F%U%%3E&format=application/odata%%2Bjson', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_26', 1, 
  '/def/([^.?/]*)/[^?]*[.][rR][dD][fF][sS]$', 
vector ('par_1'), 
1, 
'/def/%s.rdfs', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_180', 1, 
  '/def/([^.?]*)[.]([^?]*)[?].*$', 
vector ('par_1', 'par_2'), 
2, 
'/def/%s.%s', 
vector ('par_1', 'par_2'), 
NULL, 
NULL, 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_151', 1, 
  '/def/([^?/]*)/([^?]*)/$', 
vector ('par_1', 'par_2'), 
2, 
'/def/%s/%s', 
vector ('par_1', 'par_2'), 
NULL, 
NULL, 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_142', 1, 
  '/def/([^?/]+)$', 
vector ('par_1'), 
1, 
'/def/%s/', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_177', 1, 
  '/def/([^.?]*)[?](.*)$', 
vector ('par_1', 'par_2'), 
2, 
'/fct/rdfdesc/description.vsp?g=http://^{URIQADefaultHost}^/def/%s&%s', 
vector ('par_1', 'par_2'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_103', 1, 
  '/def/([^.?]*)$', 
vector ('par_1'), 
1, 
'/fct/rdfdesc/description.vsp?g=http://^{URIQADefaultHost}^/def/%s', 
vector ('par_1'), 
NULL, 
'text/html', 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_194', 1, 
  '(/def/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.rdf', 
vector ('par_1'), 
NULL, 
'application/rdf+xml', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_113', 1, 
  '(/def/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.rdf', 
vector ('par_1'), 
NULL, 
'application/rdf+xml', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_195', 1, 
  '(/def/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.n3', 
vector ('par_1'), 
NULL, 
'text/rdf+n3', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_114', 1, 
  '(/def/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.n3', 
vector ('par_1'), 
NULL, 
'text/rdf+n3', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_196', 1, 
  '(/def/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.json', 
vector ('par_1'), 
NULL, 
'application/json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_162', 1, 
  '(/def/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.json', 
vector ('par_1'), 
NULL, 
'application/json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_197', 1, 
  '(/def/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.rjson', 
vector ('par_1'), 
NULL, 
'application/rdf+json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_115', 1, 
  '(/def/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.rjson', 
vector ('par_1'), 
NULL, 
'application/rdf+json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_198', 1, 
  '(/def/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.csv', 
vector ('par_1'), 
NULL, 
'text/csv', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_116', 1, 
  '(/def/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.csv', 
vector ('par_1'), 
NULL, 
'text/csv', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_199', 1, 
  '(/def/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.atom', 
vector ('par_1'), 
NULL, 
'application/atom+xml', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_117', 1, 
  '(/def/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.atom', 
vector ('par_1'), 
NULL, 
'application/atom+xml', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_200', 1, 
  '(/def/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.ojson', 
vector ('par_1'), 
NULL, 
'application/odata+json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_118', 1, 
  '(/def/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.ojson', 
vector ('par_1'), 
NULL, 
'application/odata+json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_178', 1, 
  '/def/([^?]*)[?](.*)$', 
vector ('par_1', 'par_2'), 
2, 
'/fct/rdfdesc/description.vsp?g=http://^{URIQADefaultHost}^/def/%s&%s', 
vector ('par_1', 'par_2'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_155', 1, 
  '(/def.*)$', 
vector ('par_1'), 
1, 
'/fct/rdfdesc/description.vsp?g=http://^{URIQADefaultHost}^%s', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_119', 1, 
  '/def/(.*)$', 
vector ('par_1'), 
1, 
'%s', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
406, 
'' 
);


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- /describe 
--              Rewrite Rules in the health.data.gov interface
-- 
-- The Facet Browser library fct_dav.vad generates all of its links
-- with /describe/?url=whatever
-- This rule simply goes to the embedded URL.
--
-- Note - This rule uses the DB.DBA.REDIR_DECODE_URL stored procedure.
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
DB.DBA.VHOST_REMOVE (
	 lhost=>'*ini*',
	 vhost=>'health.data.gov',
	 lpath=>'/describe'
);

DB.DBA.VHOST_DEFINE (
	 lhost=>'*ini*',
	 vhost=>'health.data.gov',
	 lpath=>'/describe',
	 ppath=>'/SOAP/Http/EXT_HTTP_PROXY_1',
	 is_dav=>0,
	 soap_user=>'PROXY',
	 ses_vars=>0,
	 opts=>vector ('url_rewrite', 'http_rule_list_4'),
	 is_default_host=>0
);
   

DB.DBA.URLREWRITE_CREATE_RULELIST ( 
'http_rule_list_4', 1, 
  vector ('http_rule_28', 'http_rule_27'));

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_28', 1, 
  '/describe/[?]ur[li]=(.*)$', 
vector ('par_1'), 
1, 
'%s', 
vector ('par_1'), 
'DB.DBA.REDIR_DECODE_URL', 
NULL, 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_27', 1, 
  '/describe/[?]ur[li]=(http%3A%2F%2F.*data.gov%2Fdef%2F.*)$', 
vector ('par_1'), 
1, 
'%s', 
vector ('par_1'), 
'DB.DBA.REDIR_DECODE_URL_ADD_HTML', 
NULL, 
1, 
303, 
'' 
);


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- /doc 
--              Rewrite Rules in the health.data.gov interface
-- 
-- /doc is a parallel tree to /id that contains documents about /id things.
--
-- Anything that ends in .html is sent to the facet browser for rendering.
-- Other filename extensions include:
--    .n3, .ttl, .json, .csv, .rdf, .txt, .atom, and .ajson
-- 
-- if a resource does not have a file name extension, and if the 
-- Accept Header has been specified, then these rules will redirect
-- to the same resource with the proper filename extension.
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
DB.DBA.VHOST_REMOVE (
	 lhost=>'*ini*',
	 vhost=>'health.data.gov',
	 lpath=>'/doc'
);

DB.DBA.VHOST_DEFINE (
	 lhost=>'*ini*',
	 vhost=>'health.data.gov',
	 lpath=>'/doc',
	 ppath=>'/',
	 is_dav=>0,
	 def_page=>'',
	 vsp_user=>'dba',
	 ses_vars=>0,
	 opts=>vector ('xml_templates', 'yes', 'browse_sheet', '', 'url_rewrite', 'http_rule_list_5'),
	 is_default_host=>0
);


DB.DBA.URLREWRITE_CREATE_RULELIST ( 
'http_rule_list_5', 1, 
  vector ('http_rule_213', 'http_rule_29', 'http_rule_30', 'http_rule_31', 'http_rule_32', 'http_rule_169', 'http_rule_33', 'http_rule_34', 'http_rule_35', 'http_rule_36', 'http_rule_37', 'http_rule_214', 'http_rule_143', 'http_rule_215', 'http_rule_42', 'http_rule_216', 'http_rule_38', 'http_rule_217', 'http_rule_39', 'http_rule_218', 'http_rule_163', 'http_rule_219', 'http_rule_40', 'http_rule_220', 'http_rule_41', 'http_rule_221', 'http_rule_157', 'http_rule_107'));

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_213', 1, 
  '/doc/([^.?]*)[.][hH][tT][mM][lL]?[?](.*)$', 
vector ('par_1', 'par_2'), 
2, 
'/fct/rdfdesc/description.vsp?g=http://^{URIQADefaultHost}^/id/%s&%s', 
vector ('par_1', 'par_2'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_29', 1, 
  '/doc/([^.?]*)[.][hH][tT][mM][lL]?$', 
vector ('par_1'), 
1, 
'/fct/rdfdesc/description.vsp?g=http://^{URIQADefaultHost}^/id/%s', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_30', 1, 
  '/doc/([^.?]*)[.][nN]3$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2F^{URIQADefaultHost}^%%2Fid%%2F%s%%3E&format=text/rdf%%2Bn3', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_31', 1, 
  '/doc/([^.?]*)[.][tT][tT][lL]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2F^{URIQADefaultHost}^%%2Fid%%2F%s%%3E&format=text/rdf%%2Bn3', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_32', 1, 
  '/doc/([^.?]*)[.][jJ][sS][oO][nN]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2F^{URIQADefaultHost}^%%2Fid%%2F%s%%3E&format=application/json', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_169', 1, 
  '/doc/([^.?]*)[.][rR][jJ][sS][oO][nN]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2F^{URIQADefaultHost}^%%2Fid%%2F%s%%3E&format=application/rdf%%2Bjson', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_33', 1, 
  '/doc/([^.?]*)[.][cC][sS][vV]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2F^{URIQADefaultHost}^%%2Fid%%2F%s%%3E&format=text/csv', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_34', 1, 
  '/doc/([^.?]*)[.][rR][dD][fF]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2F^{URIQADefaultHost}^%%2Fid%%2F%s%%3E&format=application/rdf%%2Bxml', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_35', 1, 
  '/doc/([^.?]*)[.][tT][xX][tT]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2F^{URIQADefaultHost}^%%2Fid%%2F%s%%3E&format=text/plain', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_36', 1, 
  '/doc/([^.?]*)[.][aA][tT][oO][mM]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2F^{URIQADefaultHost}^%%2Fid%%2F%s%%3E&format=application/atom%%2Bxml', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_37', 1, 
  '/doc/([^.?]*)[.][oO][jJ][sS][oO][nN]$', 
vector ('par_1'), 
1, 
'/sparql?query=define%%20sql%%3Adescribe-mode%%20%%22CBD%%22%%20describe%%20%%3Chttp%%3A%%2F%%2F^{URIQADefaultHost}^%%2Fid%%2F%s%%3E&format=application/odata%%2Bjson', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_214', 1, 
  '(/doc/[^.?]*)[.]([^?]*)[?].*$', 
vector ('par_1', 'par_2'), 
2, 
'%s.%s', 
vector ('par_1', 'par_2'), 
NULL, 
NULL, 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_143', 1, 
  '/doc/([^?]*)/$', 
vector ('par_1'), 
1, 
'/doc/%s', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_215', 1, 
  '/doc/([^.?]*)[?](.*)$', 
vector ('par_1', 'par_2'), 
2, 
'/fct/rdfdesc/description.vsp?g=http://^{URIQADefaultHost}^/id/%s&%s', 
vector ('par_1', 'par_2'), 
NULL, 
'text/html', 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_42', 1, 
  '/doc/([^.?]*)$', 
vector ('par_1'), 
1, 
'/fct/rdfdesc/description.vsp?g=http://^{URIQADefaultHost}^/id/%s', 
vector ('par_1'), 
NULL, 
'text/html', 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_216', 1, 
  '(/doc/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.rdf', 
vector ('par_1'), 
NULL, 
'application/rdf+xml', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_38', 1, 
  '(/doc/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.rdf', 
vector ('par_1'), 
NULL, 
'application/rdf+xml', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_217', 1, 
  '(/doc/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.n3', 
vector ('par_1'), 
NULL, 
'text/rdf+n3', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_39', 1, 
  '(/doc/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.n3', 
vector ('par_1'), 
NULL, 
'text/rdf+n3', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_218', 1, 
  '(/doc/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.json', 
vector ('par_1'), 
NULL, 
'application/json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_163', 1, 
  '(/doc/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.json', 
vector ('par_1'), 
NULL, 
'application/json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_219', 1, 
  '(/doc/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.rjson', 
vector ('par_1'), 
NULL, 
'application/rdf+json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_40', 1, 
  '(/doc/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.rjson', 
vector ('par_1'), 
NULL, 
'application/rdf+json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_220', 1, 
  '(/doc/[^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'%s.csv', 
vector ('par_1'), 
NULL, 
'text/csv', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_41', 1, 
  '(/doc/[^.?]*)$', 
vector ('par_1'), 
1, 
'%s.csv', 
vector ('par_1'), 
NULL, 
'text/csv', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_221', 1, 
  '/doc/([^?]*)[?](.*)$', 
vector ('par_1', 'par_2'), 
2, 
'/fct/rdfdesc/description.vsp?g=http://^{URIQADefaultHost}^/id/%s&%s', 
vector ('par_1', 'par_2'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_157', 1, 
  '/doc/(.*)$', 
vector ('par_1'), 
1, 
'/fct/rdfdesc/description.vsp?g=http://^{URIQADefaultHost}^/id/%s', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_107', 1, 
  '/doc/(.*)$', 
vector ('par_1'), 
1, 
'%s', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
406, 
'' 
);


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- /facet
-- 
-- Access the facet browser in the health.data.gov interface
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
DB.DBA.VHOST_REMOVE (
	 lhost=>'*ini*',
	 vhost=>'health.data.gov',
	 lpath=>'/facet'
);

DB.DBA.VHOST_DEFINE (
	 lhost=>'*ini*',
	 vhost=>'health.data.gov',
	 lpath=>'/facet',
	 ppath=>'/DAV/VAD/fct/',
	 is_dav=>1,
	 def_page=>'facet.vsp',
	 vsp_user=>'dba',
	 ses_vars=>0,
	 is_default_host=>0
);


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- /facet/service
-- 
-- Access the facet web service in the health.data.gov interface
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
DB.DBA.VHOST_REMOVE (
	 lhost=>'*ini*',
	 vhost=>'health.data.gov',
	 lpath=>'/facet/service'
);

DB.DBA.VHOST_DEFINE (
	 lhost=>'*ini*',
	 vhost=>'health.data.gov',
	 lpath=>'/facet/service',
	 ppath=>'/SOAP/Http/fct_svc',
	 is_dav=>0,
	 soap_user=>'dba',
	 ses_vars=>0,
	 is_default_host=>0
);


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- /fct
-- 
-- Access the facet browser in the health.data.gov interface
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
DB.DBA.VHOST_REMOVE (
	 lhost=>'*ini*',
	 vhost=>'health.data.gov',
	 lpath=>'/fct'
);

DB.DBA.VHOST_DEFINE (
	 lhost=>'*ini*',
	 vhost=>'health.data.gov',
	 lpath=>'/fct',
	 ppath=>'/DAV/VAD/fct/',
	 is_dav=>1,
	 def_page=>'facet.vsp',
	 vsp_user=>'dba',
	 ses_vars=>0,
	 is_default_host=>0
);


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- /fct/service
-- 
-- Access the facet web service in the health.data.gov interface
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
DB.DBA.VHOST_REMOVE (
	 lhost=>'*ini*',
	 vhost=>'health.data.gov',
	 lpath=>'/fct'
);

DB.DBA.VHOST_DEFINE (
	 lhost=>'*ini*',
	 vhost=>'health.data.gov',
	 lpath=>'/fct',
	 ppath=>'/DAV/VAD/fct/',
	 is_dav=>1,
	 def_page=>'facet.vsp',
	 vsp_user=>'dba',
	 ses_vars=>0,
	 is_default_host=>0
);


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- /file 
--              Rewrite Rules in the health.data.gov interface
-- 
-- /file is a file system mount point for rdfs and rdf files used in CQLD
-- The files found there should be readable by all.
--
-- If one wanted to retrieve a filename called foo.rdfs, then a rewrite 
-- rule can access it by merely performing a 303 redirect to /file/foo.rdfs
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
DB.DBA.VHOST_REMOVE (
	 lhost=>'*ini*',
	 vhost=>'health.data.gov',
	 lpath=>'/file'
);

DB.DBA.VHOST_DEFINE (
	 lhost=>'*ini*',
	 vhost=>'health.data.gov',
	 lpath=>'/file',
	 ppath=>'/hhsFileSystem/',
	 is_dav=>0,
	 def_page=>'index.html',
	 vsp_user=>'dba',
	 ses_vars=>0,
	 opts=>vector ('browse_sheet', ''),
	 is_default_host=>0
);


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- /id 
--              Rewrite Rules in the health.data.gov interface
-- 
-- /id has a parallel tree, namely /doc for documents about /id things.
-- So most anything requested will be redirected to the proper /doc document.
--
-- Anything that ends in .html is sent to the facet browser for rendering.
-- Other filename extensions include:
--    .n3, .ttl, .json, .csv, .rdf, .txt, .atom, and .ajson
-- 
-- if a resource does not have a file name extension, and if the 
-- Accept Header has been specified, then these rules will redirect
-- to the same resource with the proper filename extension.
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
DB.DBA.VHOST_REMOVE (
	 lhost=>'*ini*',
	 vhost=>'health.data.gov',
	 lpath=>'/id'
);

DB.DBA.VHOST_DEFINE (
	 lhost=>'*ini*',
	 vhost=>'health.data.gov',
	 lpath=>'/id',
	 ppath=>'/',
	 is_dav=>0,
	 def_page=>'',
	 vsp_user=>'dba',
	 ses_vars=>0,
	 opts=>vector ('xml_templates', 'yes', 'browse_sheet', '', 'url_rewrite', 'http_rule_list_6'),
	 is_default_host=>0
);
   

DB.DBA.URLREWRITE_CREATE_RULELIST ( 
'http_rule_list_6', 1, 
  vector ('http_rule_222', 'http_rule_144', 'http_rule_223', 'http_rule_43', 'http_rule_224', 'http_rule_55', 'http_rule_225', 'http_rule_51', 'http_rule_226', 'http_rule_52', 'http_rule_227', 'http_rule_53', 'http_rule_228', 'http_rule_168', 'http_rule_229', 'http_rule_54', 'http_rule_230', 'http_rule_120', 'http_rule_231', 'http_rule_121', 'http_rule_159', 'http_rule_106'));

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_222', 1, 
  '/id/([^?]*)/[?](.*)$', 
vector ('par_1', 'par_2'), 
2, 
'/id/%s?%s', 
vector ('par_1', 'par_2'), 
NULL, 
NULL, 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_144', 1, 
  '/id/([^?]*)/$', 
vector ('par_1'), 
1, 
'/id/%s', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_223', 1, 
  '/id/([^.?]*[.][^.?]*)[?](.*)$', 
vector ('par_1', 'par_2'), 
2, 
'/doc/%s?%s', 
vector ('par_1', 'par_2'), 
NULL, 
NULL, 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_43', 1, 
  '/id/([^.?]*[.][^.?]*)$', 
vector ('par_1'), 
1, 
'/doc/%s', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_224', 1, 
  '/id/([^.?]*)[?](.*)$', 
vector ('par_1', 'par_2'), 
2, 
'/doc/%s?%s', 
vector ('par_1', 'par_2'), 
NULL, 
'text/html', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_55', 1, 
  '/id/([^.?]*)$', 
vector ('par_1'), 
1, 
'/doc/%s', 
vector ('par_1'), 
NULL, 
'text/html', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_225', 1, 
  '/id/([^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'/doc/%s.n3', 
vector ('par_1'), 
NULL, 
'text/rdf+n3', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_51', 1, 
  '/id/([^.?]*)$', 
vector ('par_1'), 
1, 
'/doc/%s.n3', 
vector ('par_1'), 
NULL, 
'text/rdf+n3', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_226', 1, 
  '/id/([^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'/doc/%s.csv', 
vector ('par_1'), 
NULL, 
'text/csv', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_52', 1, 
  '/id/([^.?]*)$', 
vector ('par_1'), 
1, 
'/doc/%s.csv', 
vector ('par_1'), 
NULL, 
'text/csv', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_227', 1, 
  '/id/([^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'/doc/%s.rdf', 
vector ('par_1'), 
NULL, 
'application/rdf+xml', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_53', 1, 
  '/id/([^.?]*)$', 
vector ('par_1'), 
1, 
'/doc/%s.rdf', 
vector ('par_1'), 
NULL, 
'application/rdf+xml', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_228', 1, 
  '/id/([^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'/doc/%s.json', 
vector ('par_1'), 
NULL, 
'application/json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_168', 1, 
  '/id/([^.?]*)$', 
vector ('par_1'), 
1, 
'/doc/%s.json', 
vector ('par_1'), 
NULL, 
'application/json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_229', 1, 
  '/id/([^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'/doc/%s.rjson', 
vector ('par_1'), 
NULL, 
'application/rdf+json', 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_54', 1, 
  '/id/([^.?]*)$', 
vector ('par_1'), 
1, 
'/doc/%s.rjson', 
vector ('par_1'), 
NULL, 
'application/rdf+json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_230', 1, 
  '/id/([^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'/doc/%s.atom', 
vector ('par_1'), 
NULL, 
'application/atom+xml', 
1, 
0, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_120', 1, 
  '/id/([^.?]*)$', 
vector ('par_1'), 
1, 
'/doc/%s.atom', 
vector ('par_1'), 
NULL, 
'application/atom+xml', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_231', 1, 
  '/id/([^.?]*)[?].*$', 
vector ('par_1'), 
1, 
'/doc/%s.ojson', 
vector ('par_1'), 
NULL, 
'application/odata+json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_121', 1, 
  '/id/([^.?]*)$', 
vector ('par_1'), 
1, 
'/doc/%s.ojson', 
vector ('par_1'), 
NULL, 
'application/odata+json', 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_159', 1, 
  '/id/(.*)$', 
vector ('par_1'), 
1, 
'/doc/%s', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
303, 
'' 
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_106', 1, 
  '/id/(.*)$', 
vector ('par_1'), 
1, 
'%s', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
406, 
'' 
);


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- /search
-- 
-- Access the sparql processor in the health.data.gov interface
-- This is equivalent to /fct (search just seems like a better name)
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
DB.DBA.VHOST_REMOVE (
	 lhost=>'*ini*',
	 vhost=>'health.data.gov',
	 lpath=>'/search'
);

DB.DBA.VHOST_DEFINE (
	 lhost=>'*ini*',
	 vhost=>'health.data.gov',
	 lpath=>'/search',
	 ppath=>'/',
	 is_dav=>0,
	 def_page=>'',
	 vsp_user=>'dba',
	 ses_vars=>0,
	 opts=>vector ('xml_templates', 'yes', 'browse_sheet', '', 'url_rewrite', 'http_rule_list_12'),
	 is_default_host=>0
);
  

DB.DBA.URLREWRITE_CREATE_RULELIST ( 
'http_rule_list_12', 1, 
  vector ('http_rule_108'));

DB.DBA.URLREWRITE_CREATE_REGEX_RULE ( 
'http_rule_108', 1, 
  '/search(/.*)$', 
vector ('par_1'), 
1, 
'/fct%s', 
vector ('par_1'), 
NULL, 
NULL, 
1, 
0, 
'' 
);


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- /sparql
-- 
-- Access the sparql processor in the health.data.gov interface
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
DB.DBA.VHOST_REMOVE (
	 lhost=>'*ini*',
	 vhost=>'health.data.gov',
	 lpath=>'/sparql'
);

DB.DBA.VHOST_DEFINE (
	 lhost=>'*ini*',
	 vhost=>'health.data.gov',
	 lpath=>'/sparql',
	 ppath=>'/!sparql/',
	 is_dav=>1,
	 vsp_user=>'dba',
	 ses_vars=>0,
	 opts=>vector ('noinherit', 1),
	 is_default_host=>0
);


