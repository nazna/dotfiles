#!/usr/bin/env perl

$biber        = 'biber --bblencoding=utf8 -u -U --output_safechars';
$bibtex       = 'upbibtex';
$clean_ext    = '%R.dvi';
$dvipdf       = 'dvipdfmx %O -o %D %S';
$latex        = 'uplatex -shell-escape -halt-on-error';
$latex_silent = 'uplatex -shell-escape -halt-on-error -interaction=batchmode';
$makeindex    = 'mendex %O -o %D %S';
$max_repeat   = 5;
$pdf_mode     = 3;
$pdf_update_command = 'open -ga Preview %S';
$pvc_view_file_via_temporary = 0;
