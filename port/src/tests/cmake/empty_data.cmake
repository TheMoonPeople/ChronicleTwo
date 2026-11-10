# Coherent empty publisher output for headless screenshot regressions.
function(ct_empty_data_fixture root version_source)
    file(READ "${version_source}" version_json)
    string(JSON data_version GET "${version_json}" data_version)
    file(MAKE_DIRECTORY "${root}/data")
    file(REMOVE "${root}/data/manifest.json")
    file(WRITE "${root}/data.json" "{\n  \"schema_version\": 1,\n  \"data_version\": ${data_version}\n}\n")
endfunction()
