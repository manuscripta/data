xquery version "3.0";
import module namespace xdb="http://exist-db.org/xquery/xmldb";

declare variable $home external;
declare variable $dir external;
declare variable $target external;

declare variable $data-root := "/db/data";

declare function local:mkcol($collection, $path) {
    let $components := tokenize($path, "/")
    return fold-left($components, $collection, function($parent, $seg) {
        let $new := $parent || "/" || $seg
        return (xdb:create-collection($parent, $seg), $new)[last()]
    })
};

let $_ := if (not(xdb:collection-available($data-root))) then
    xdb:create-collection("/db", "data") else ()

let $store-msdescs :=
    if (xdb:collection-available($data-root || "/msDescs")) then
        util:log("info", "data: msDescs already exists, skipping")
    else (
        local:mkcol("", $data-root || "/msDescs"),
        xdb:store-files-from-pattern(
            $data-root || "/msDescs",
            $dir || "/data/msDescs",
            "**/*.xml", "text/xml", true(), "*.xconf"
        )
    )

let $store-id :=
    if (xdb:collection-available($data-root || "/id")) then
        util:log("info", "data: id already exists, skipping")
    else (
        local:mkcol("", $data-root || "/id"),
        xdb:store-files-from-pattern(
            $data-root || "/id",
            $dir || "/data/id",
            "**/*.xml", "text/xml", true(), "*.xconf"
        )
    )

return ()
