#!/usr/bin/env perl

$latex        = 'uplatex -shell-escape -halt-on-error';
$latex_silent = 'uplatex -shell-escape -halt-on-error -interaction=batchmode';
$clean_ext    = '%R.dvi';
$bibtex       = 'upbibtex';
$biber        = 'biber --bblencoding=utf8 -u -U --output_safechars';
$dvipdf       = 'dvipdfmx %O -o %D %S';
$makeindex    = 'mendex %O -o %D %S';
$max_repeat   = 5;
$pdf_mode     = 3;

$pvc_view_file_via_temporary = 0;

$pdf_update_command = 'open -ga Preview %S';
