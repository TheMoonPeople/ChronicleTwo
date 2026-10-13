# Coherent empty publisher output for headless screenshot regressions.
function(ct_empty_data_fixture root version_source)
    file(READ "${version_source}" version_json)
    string(JSON data_version GET "${version_json}" data_version)
    file(MAKE_DIRECTORY "${root}/data" "${root}/port_data")
    file(WRITE "${root}/data/manifest.json" "{\"schema_version\":1,\"files\":{}}")
    file(WRITE "${root}/port_data/manifest.json" "{\"schema_version\":1,\"files\":{}}")
    file(WRITE "${root}/data.json" "{\"schema_version\":1,\"data_version\":${data_version}}")
endfunction()
