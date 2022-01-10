#!/bin/bash
# Copyright (c) 2022 Djones A. Boni - MIT License

source bashtest.sh

f_bashtest_start

f_test_merge_cov_xml_py_GivenAnInexistentXMLFile_ThenOutputsNoContent() {
    # Set-up

    # Execution
    python3 ../merge_cov_xml.py cov_1.xml > cov.xml

    # Assertions
    f_assert_file_exists cov.xml
    f_assert_equal "" "$(cat cov.xml)"

    # Tear-down
    f_delete_files cov.xml
}
f_test_merge_cov_xml_py_GivenAnInexistentXMLFile_ThenOutputsNoContent

f_test_merge_cov_xml_py_GivenOneXMLFile_ThenOutputsEquivalentContent() {
    # Set-up
    Data="\
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<coverage>
<tag1><subtag1a /></tag1>
</coverage>"
    f_create_file cov_1.xml "$Data"

    # Execution
    python3 ../merge_cov_xml.py cov_1.xml > cov.xml

    # Assertions
    f_assert_file_exists cov.xml
    f_assert_equal "$Data" "$(cat cov.xml)"

    # Tear-down
    f_delete_files cov_1.xml cov.xml
}
f_test_merge_cov_xml_py_GivenOneXMLFile_ThenOutputsEquivalentContent

f_test_merge_cov_xml_py_GivenTwoXMLFiles_ThenOutputsMergedContests() {
    # Set-up
    Data1="\
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<coverage>
<tag1><subtag1a /></tag1>
</coverage>"
    Data2="\
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<coverage>
<tag2><subtag2a /></tag2>
</coverage>"
    f_create_file cov_1.xml "$Data1"
    f_create_file cov_2.xml "$Data2"

    # Execution
    DataExpected="\
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<coverage>
<tag1><subtag1a /></tag1>
<tag2><subtag2a /></tag2>
</coverage>"
    python3 ../merge_cov_xml.py cov_1.xml cov_2.xml > cov.xml

    # Assertions
    f_assert_file_exists cov.xml
    f_assert_equal "$DataExpected" "$(cat cov.xml)"

    # Tear-down
    f_delete_files cov_1.xml cov_2.xml cov.xml
}
f_test_merge_cov_xml_py_GivenTwoXMLFiles_ThenOutputsMergedContests

f_test_merge_cov_xml_py_GivenXMLOnStdin_ThenOutputsEquivalentContent() {
    # Set-up
    Data="\
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<coverage>
<tag1><subtag1a /></tag1>
</coverage>"

    # Execution
    echo "$Data" | 
        python3 ../merge_cov_xml.py > cov.xml

    # Assertions
    f_assert_file_exists cov.xml
    f_assert_equal "$Data" "$(cat cov.xml)"

    # Tear-down
    f_delete_files cov.xml
}
f_test_merge_cov_xml_py_GivenXMLOnStdin_ThenOutputsEquivalentContent

f_bashtest_end
