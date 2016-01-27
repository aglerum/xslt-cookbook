# xslt-cookbook
A collection of XSLT programs for analyzing and transforming library data
### Directory/File Relationships

| Directory | File type | Function |
|-----------| -----------| -----------|
| ```functions``` | .xsl | Called by XSLT programs in ```modules``` and ```transformations``` |
| ```modules``` ```[coming soon]``` | .xsl | Called by XSLT programs in ```transformations``` directory |
| ```tables``` | .xml | Called by XSLT programs in ```modules``` and ```transformations``` |
| ```transformations``` | .xsl | Run on XML documents in ```xml```  |
| ```xml``` | .xml | Transformed by XSLT programs in ```transformations``` |
### Recipes
 
 *characters2utf8*
 * ```functions/characters2utf8.xsl```
 * ```tables/unicode_map.xml```
 * ```transformations/bepress2mods-characters2utf8.xsl```
 * ```xml/bepress_characters2utf8.xml```
