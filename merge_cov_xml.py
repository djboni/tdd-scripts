#!/usr/bin/python3
# Copyright (c) 2022 Djones A. Boni - MIT License

# pylint: disable=consider-using-with

"""
Merge coverage XML files.

Usage: merge_cov_xml.py [INPUTS_FILES]

INPUTS_FILES: Defaults to - (stdin)

This script merges several coverage files into one, writing the result to
stdout.

Use case: C/C++ and Python XML coverage files are generated independently in
different files. With this script you can merge both into one XML coverage
files into one.

Example: python3 merge_cov_xml.py cov_c.xml cov_py.xml > cov.xml
"""

import sys
from typing import List, Optional
from xml.etree import ElementTree


def MergeCoverageXML(
    input_filenames: Optional[List[str]] = None,
    output_filename: Optional[str] = None,
):
    """
    Merge coverage XML files.

    input_filenames: List with input XML filenames. Defaults to ["-"] (stdin).
    output_filename: Output XML filename. Defaults to "-" (stdout).
    """

    if input_filenames is None:
        input_filenames = ["-"]

    if output_filename is None:
        output_filename = "-"

    opened_files: List = []

    try:
        input_files = OpenInputFiles(input_filenames, opened_files)
        xml_element_tree = ReadAndProcessInputFiles(input_files)
        if xml_element_tree is not None:
            output_file = OpenOutputFile(output_filename, opened_files)
            WriteOutputFile(output_file, xml_element_tree)
    finally:
        for fp in opened_files:
            fp.close()


def OpenInputFiles(input_filenames: List[str], opened_files: List):
    input_files = []

    for filename in input_filenames:
        if filename == "-":
            input_files.append(sys.stdin)
        else:
            try:
                fp = open(filename, "r", encoding="utf8")
            except FileNotFoundError:
                pass
            else:
                opened_files.append(fp)
                input_files.append(fp)

    return input_files


def ReadAndProcessInputFiles(input_files: List):
    xml_element_tree = None

    for xml_file in input_files:
        element = ElementTree.parse(xml_file).getroot()

        for result in element.iter("coverage"):
            if xml_element_tree is None:
                xml_element_tree = element
            else:
                xml_element_tree.extend(result)

    return xml_element_tree


def OpenOutputFile(output_filename: str, opened_files: List):
    if output_filename == "-":
        output_file = sys.stdout
    else:
        fp = open(output_filename, "w", encoding="utf8")
        opened_files.append(fp)
        output_file = fp

    return output_file


def WriteOutputFile(output_file, xml_element_tree):
    data = ElementTree.tostring(xml_element_tree)
    output_file.write(
        '<?xml version="1.0" encoding="UTF-8"?>\n' + data.decode("utf8") + "\n"
    )


if __name__ == "__main__":
    if len(sys.argv) == 1:
        Input_Filenames = ["-"]
    else:
        Input_Filenames = sys.argv[1:]
    Output_Filename = "-"

    MergeCoverageXML(Input_Filenames, Output_Filename)
