" File:         TagsParser.Vim
" Description:  Dynamic file tagging and mini-window to display tags
" Version:      0.7
" Date:         November 07, 2006
" Author:       A. Aaron Cornelius (ADotAaronDotCorneliusAtgmailDotcom)
"
" Installation:
" ungzip and untar The TagsParser.tar.gz somewhere in your Vim runtimepath
" (typically this should be something like $HOME/.Vim, $HOME/vimfiles or
" $VIM/vimfiles) Once this is done run :helptags <dir>/doc where <dir> is The
" directory that you ungziped and untarred The TagsParser.tar.gz archive in.
"
" Usage:
" For help on The usage of this plugin to :help TagsParser after you have
" finished The installation steps.
"
" Changelog: <<<
"
" 11/08/2006 - Added new autocmd that moves the current directory to the
"              directory that the current file resides in.  The 
"              TagsParserCurrentFileCWD variable enables this new autocmd.
"
" 0.7 - Bugfixes of Vim script functions.
"
" 11/07/2006 - Added global variables so user can manually change the
"              updatetime to be set if HighlightCurrentTag is on, and can 
"              modify the default qualified tag separator regexp.
" 11/06/2006 - Fixed Vim close/Buffer cycling behavior so that the TagsParser
"              no longer causes Vim to exit when changing buffers, and it 
"              exits correctly when the last non-tag window exits.
" 11/06/2006 - As a request added check so that the current shell is verified
"              to be executable on the current system before TagsParser is 
"              loaded to give informative error messages.
" 11/06/2006 - Fixed incorrect initialization of
"              TagsParserCtagsOptionsTypeList variable (assuming vim version 
"              is 7.0 or greater).
" 11/06/2006 - Added missing string concatenations in ctags check.
" 11/03/2006 - Changed qall to confirm qall when quitting vim.
" 11/03/2006 - Fixed problem where selecting (through auto highlight or
"              manually) multiple tags within the same fold would cause that 
"              section of tags not to be refolded when a tag outside of the 
"              fold was eventually selected.
" 11/03/2006 - Corrected multiple tags on the same line highlighting problem.
" 11/02/2006 - Corrected "wincmd w" commands to search for the window holding
"              the correct buffer name instead of just going back to the 
"              previous window.
" 11/02/2006 - Added --extra=+q to the ctags options, and added support so
"              that tag files with qualified tags (using '\.\|:') are not 
"              included in the displayed tag window.  Previously this could 
"              cause TagsParser to enter an infinite loop for some reason.
" 11/02/2006 - Corrected number comparison issue.  When a string contains a
"              number, apparently Vim does not do a number comparison, it does 
"              a string comparison.  So 100 can be less than 50.  To solve 
"              this problem, just add 0 to the numbers being compared.
" 11/02/2006 - Corrected issue where tag type hash entry could be mistaken as
"              a valid member indication.  Renamed 'type' to 'tagtype'.
"
" 0.6 - Major script refactoring
"
" 10/18/2006 - When locating a tag on a line where multiple tags are defined,
"              the script used to just use the last one on the row.  Now it
"              should stop at the first valid tag on the line (unless the
"              cursor is resting on another tag).
" 10/11/2006 - Minor change, if you select above the filename in the tag
"              window, nothing is folded or selected.
" 10/11/2006 - Fixed yet another bug in the vim script version of
"              TagsParserDisplayTags
" 10/09/2006 - Fixed issues with the Vim script functions (vs. the Perl
"              functions) storing data in the "" and "0-9 registers which
"              sometimes clobbered the user data in the copy/delete registers.
" 10/06/2006 - Fixed various functionality issues with the new native Vim
"              script code.
" 10/05/2006 - Moved Perl code into native Vim script for users of Vim 7.0 and
"              greater.
"
" 0.5 - Minor Bugfix release - 09/25/2006
"
" 09/25/2006 - Added the TagsParserCtagsOptionsTypeList variable so that the
"	             TagDir command can use the same ctags flags as used when 
"	             parsing files individually.
" 09/25/2006 - Fixed LastPositionJump feature, was using BufWinEnter when
"              BufReadPost should have been used.
" 09/18/2006 - Added variable that enables the TagDir command to pass the
"              correct options to the ctags command.
" 09/15/2006 - Fixed buffer change error, moved autocommands from BufWinEnter
"              to BufEnter events.
" 09/14/2006 - Cleaned up tags path generated from the g:TagsParserTagsPath
"              variable.  Many errors happened if there were spaces in the 
"              path.
"
" 0.4 - First bugfix release - 06/11/2006
"
" 06/09/2006 - Added some GCOV extensions (*.da, *.bb, *.bbg, *.gcov) to file
"              exclude pattern.
" 06/09/2006 - Added GNAT build artifact extension (*.ali) to file exclude
"              pattern.
" 06/09/2006 - Fixed some spelling errors in messages and comments.
" 06/09/2006 - Added standard library extensions (*.a, *.so) to file exclude
"              pattern.
" 06/09/2006 - Changed include/exclude regular expressions into Vim regexps 
"              instead of Perl regexps.
" 06/08/2006 - Fixed issues with spaces in paths (mostly of... The root of it
"              is when Ctags is using The external sort... at least on Win32).
" 06/08/2006 - Fixed issue where tag files are created for directory names 
"              when using The TagDir command.
" 06/02/2006 - Added Copyright notice. 
" 06/02/2006 - Fixed tag naming issue where if you have 
"              TagsParserCtagsOptions* options defined, it messes up The name
"              of The tag file.
" 05/26/2006 - Added nospell to local TagWindow options for Vim 7.
"
" 0.3 - Initial Public Release - 05/07/2006
" >>>
" Future Changes: <<<
" TODO: Make compatible with Tab pages for Vim 7.
" TODO: Allow The definition of separate tag paths depending on The current 
"       working directory
" TODO: Setup TagWindow portion of plugin to be autoloaded.
"       resides in.
" >>>
" Bug List: <<<
" >>>
"
" Copyright (C) 2006 A. Aaron Cornelius <<<
"
" This program is free software; you can redistribute it and/or
" modify it under The terms of The GNU General Public License
" as published by The Free Software Foundation; either version 2
" of The License, or (at your option) any later version.
"
" This program is distributed in The hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even The implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See The
" GNU General Public License for more details.
"
" You should have received a copy of The GNU General Public License
" along with this program; if not, write to The Free Software
" Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301,
" USA.
" >>>

let s:cpoSave = &cpo
set cpo&vim

" Init Check <<<
if exists('s:TagsParserLoaded')
  finish
endif
let s:TagsParserLoaded = 1
" >>>

" Initialization Functions

" TagsParserInit - Init the default type names <<<
function! <SID>TagsParserInit()
  " define the data needed for displaying the tag data, define it in
  " the order desired for parsing, and each entry has the key into the
  " tags hash, the title for those types, and what fold level to put it at
  " the default fold level is 3 which allows for something along the lines of
  " namespace->class->function()

  " If you define a new set of types, make sure to prefix the name with
  " a "- " string so that it will be picked up by the "Type" syntax...  
  let s:adaTypes = [ [ 'P', '- Package Specs' ], [ 'p', '- Packages' ], [ 'T', '- Type Specs' ], [ 't', '- Types' ], [ 'U', '- Subtype Specs' ], [ 'u', '- Subtypes' ], [ 'c', '- Components' ], [ 'l', '- Literals' ], [ 'V', '- Variable Specs' ], [ 'v', '- Variables' ], [ 'n', '- Constants' ], [ 'x', '- Exceptions' ], [ 'f', '- Formal Params' ], [ 'R', '- Subprogram Specs' ], [ 'r', '- Subprograms' ], [ 'K', '- Task Specs' ], [ 'k', '- Tasks' ], [ 'O', '- Protected Data Specs' ], [ 'o', '- Protected Data' ], [ 'E', '- Entry Specs' ], [ 'e', '- Entries' ], [ 'b', '- Labels' ], [ 'i', '- Identifiers' ], [ 'a', '- Auto Vars' ], [ 'y', '- Blocks' ] ]

  let s:adaTypes = [ [ 'P', '- Package Specs' ], [ 'p', '- Packages' ], [ 'T', '- Type Specs' ], [ 't', '- Types' ], [ 'U', '- Subtype Specs' ], [ 'u', '- Subtypes' ], [ 'c', '- Components' ], [ 'l', '- Literals' ], [ 'V', '- Variable Specs' ], [ 'v', '- Variables' ], [ 'n', '- Constants' ], [ 'x', '- Exceptions' ], [ 'f', '- Formal Params' ], [ 'R', '- Subprogram Specs' ], [ 'r', '- Subprograms' ], [ 'K', '- Task Specs' ], [ 'k', '- Tasks' ], [ 'O', '- Protected Data Specs' ], [ 'o', '- Protected Data' ], [ 'E', '- Entry Specs' ], [ 'e', '- Entries' ], [ 'b', '- Labels' ], [ 'i', '- Identifiers' ], [ 'a', '- Auto Vars' ], [ 'y', '- Blocks' ] ]

  let s:asmTypes = [ [ 'd', '- Defines' ], [ 't', '- Types' ], [ 'm', '- Macros' ], [ 'l', '- Labels' ] ]

  let s:aspTypes = [ [ 'f', '- Functions' ], [ 's', '- Subroutines' ], [ 'v', '- Variables' ] ]

  let s:awkTypes = [ [ 'f', '- Functions' ] ]

  let s:betaTypes = [ [ 'f', '- Fragment Defs' ], [ 'p', '- All Patterns' ], [ 's', '- Slots' ], [ 'v', '- Patterns' ] ]

  let s:cTypes = [ [ 'n', '- Namespaces' ], [ 'c', '- Classes' ], [ 'd', '- Macros' ], [ 't', '- Typedefs' ], [ 's', '- Structures' ], [ 'g', '- Enumerations' ], [ 'u', '- Unions' ], [ 'x', '- External Vars' ], [ 'v', '- Variables' ], [ 'p', '- Prototypes' ], [ 'f', '- Functions' ], [ 'm', '- Struct/Union Members' ], [ 'e', '- Enumerators' ], [ 'l', '- Local Vars' ] ]

  let s:csTypes = [ [ 'c', '- Classes' ], [ 'd', '- Macros' ], [ 'e', '- Enumerators' ], [ 'E', '- Events' ], [ 'f', '- Fields' ], [ 'g', '- Enumerations' ], [ 'i', '- Interfaces' ], [ 'l', '- Local Vars' ], [ 'm', '- Methods' ], [ 'n', '- Namespaces' ], [ 'p', '- Properties' ], [ 's', '- Structs' ], [ 't', '- Typedefs' ] ]

  let s:cobolTypes = [ [ 'd', '- Data Items' ], [ 'f', '- File Descriptions' ], [ 'g', '- Group Items' ], [ 'p', '- Paragraphs' ], [ 'P', '- Program IDs' ], [ 's', '- Sections' ] ]

  let s:eiffelTypes = [ [ 'c', '- Classes' ], [ 'f', '- Features' ], [ 'l', '- Local Entities' ] ]

  let s:erlangTypes = [ [ 'd', '- Macro Defs' ], [ 'f', '- Functions' ], [ 'm', '- Modules' ], [ 'r', '- Record Defs' ] ]

  let s:fortranTypes = [ [ 'b', '- Block Data' ], [ 'c', '- Common Blocks' ], [ 'e', '- Entry Points' ], [ 'f', '- Functions' ], [ 'i', '- Interface Contents/Names/Ops' ], [ 'k', '- Type/Struct Components' ], [ 'l', '- Labels' ], [ 'L', '- Local/Common/Namelist Vars' ], [ 'm', '- Modules' ], [ 'n', '- Namelists' ], [ 'p', '- Programs' ], [ 's', '- Subroutines' ], [ 't', '- Derived Types/Structs' ], [ 'v', '- Program/Module Vars' ] ]

  let s:htmlTypes = [ [ 'a', '- Named Anchors' ], [ 'f', '- Javascript Funcs' ] ]

  let s:javaTypes = [ [ 'c', '- Classes' ], [ 'f', '- Fields' ], [ 'i', '- Interfaces' ], [ 'l', '- Local Vars' ], [ 'm', '- Methods' ], [ 'p', '- Packages' ] ]

  let s:javascriptTypes = [ [ 'f', '- Functions' ] ]

  let s:lispTypes = [ [ 'f', '- Functions' ] ]

  let s:luaTypes = [ [ 'f', '- Functions' ] ]

  let s:makeTypes = [ [ 'm', '- Macros' ] ]

  let s:pascalTypes = [ [ 'f', '- Functions' ], [ 'p', '- Procedures' ] ]

  let s:perlTypes = [ [ 'c', '- Constants' ], [ 'l', '- Labels' ], [ 's', '- Subroutines' ] ]

  let s:phpTypes = [ [ 'c', '- Classes' ], [ 'd', '- Constants' ], [ 'f', '- Functions' ], [ 'v', '- Variables' ] ]

  let s:pythonTypes = [ [ 'c', '- Classes' ], [ 'm', '- Class Members' ], [ 'f', '- Functions' ] ]

  let s:rexxTypes = [ [ 's', '- Subroutines' ] ]

  let s:rubyTypes = [ [ 'c', '- Classes' ], [ 'f', '- Methods' ], [ 'F', '- Singleton Methods' ], [ 'm', '- Modules' ] ]

  let s:schemeTypes = [ [ 'f', '- Functions' ], [ 's', '- Sets' ] ]

  let s:shTypes = [ [ 'f', '- Functions' ] ]

  let s:slangTypes = [ [ 'f', '- Functions' ], [ 'n', '- Namespaces' ] ]

  let s:smlTypes = [ [ 'e', '- Exception Defs' ], [ 'f', '- Function Defs' ], [ 'c', '- Functor Defs' ], [ 's', '- Signatures' ], [ 'r', '- Structures' ], [ 't', '- Type Defs' ], [ 'v', '- Value Bindings' ] ]

  let s:sqlTypes = [ [ 'c', '- Cursors' ], [ 'd', '- Prototypes' ], [ 'f', '- Functions' ], [ 'F', '- Record Fields' ], [ 'l', '- Local Vars' ], [ 'L', '- Block Label' ], [ 'P', '- Packages' ], [ 'p', '- Procedures' ], [ 'r', '- Records' ], [ 's', '- Subtypes' ], [ 't', '- Tables' ], [ 'T', '- Triggers' ], [ 'v', '- Variables' ] ]

  let s:tclTypes = [ [ 'c', '- Classes' ], [ 'm', '- Methods' ], [ 'p', '- Procedures' ] ]

  let s:veraTypes = [ [ 'c', '- Classes' ], [ 'd', '- Macro Defs' ], [ 'e', '- Enumerators' ], [ 'f', '- Functions' ], [ 'g', '- Enumerations' ], [ 'l', '- Local Vars' ], [ 'm', '- Class/Struct/Union Members' ], [ 'p', '- Programs' ], [ 'P', '- Prototypes' ], [ 't', '- Tasks' ], [ 'T', '- Typedefs' ], [ 'v', '- Variables' ], [ 'x', '- External Vars' ] ]

  let s:verilogTypes = [ [ 'c', '- Constants' ], [ 'e', '- Events' ], [ 'f', '- Functions' ], [ 'm', '- Modules' ], [ 'n', '- Net Data Types' ], [ 'p', '- Ports' ], [ 'r', '- Register Data Types' ], [ 't', '- Tasks' ] ]

  let s:vimTypes = [ [ 'a', '- Autocommand Groups' ], [ 'f', '- Functions' ], [ 'v', '- Variables' ] ]

  let s:yaccTypes = [ [ 'l', '- Labels' ] ]

  let s:typeMap = { 'ada': s:adaTypes, 'asm': s:asmTypes, 'asp': s:aspTypes, 'awk': s:awkTypes, 'beta':  s:betaTypes, 'c': s:cTypes, 'cpp': s:cTypes, 'cs': s:csTypes, 'cobol': s:cobolTypes, 'eiffel': s:eiffelTypes, 'erlang': s:erlangTypes, 'fortran': s:fortranTypes, 'html': s:htmlTypes, 'java': s:javaTypes, 'javascript': s:javascriptTypes, 'lisp': s:lispTypes, 'lua': s:luaTypes, 'make': s:makeTypes, 'pascal': s:pascalTypes, 'perl': s:perlTypes, 'php': s:phpTypes, 'python': s:pythonTypes, 'rexx': s:rexxTypes, 'ruby': s:rubyTypes, 'scheme': s:schemeTypes, 'sh': s:shTypes, 'slang': s:slangTypes, 'sml': s:smlTypes, 'sql': s:sqlTypes, 'tcl': s:tclTypes, 'vera': s:veraTypes, 'verilog': s:verilogTypes, 'vim': s:vimTypes, 'yacc': s:yaccTypes }

  " create a subtype hash, much like the typeMap.  This will list what
  " sub-types to display, so for example, C struct types will only have it's
  " "m" member list checked which will list the fields of that struct, while
  " namespaces can have all of the types listed in the @cType array.
  let s:adaSubTypes = { 'i': s:adaTypes, 't': [ [ 'c', '' ], [ 'l', '' ], [ 'a', '- Discriminants' ] ], 'u': [ [ 'c', '' ], [ 'l', '' ], [ 'a', '- Discriminants' ] ], 'P': s:adaTypes, 'p': s:adaTypes, 'R': s:adaTypes, 'r': s:adaTypes, 'K': s:adaTypes, 'k': s:adaTypes, 'O': s:adaTypes, 'o': s:adaTypes, 'E': s:adaTypes, 'e': s:adaTypes, 'y': s:adaTypes }

  let s:cSubTypes  = { 'f': [ [ 'l', '' ] ], 's': [ [ 'm', '' ] ], 'u': [ [ 'm', '' ] ], 'g': [ [ 'e', '' ] ], 'c': s:cTypes, 'n': s:cTypes }

  let s:subTypeMap = { 'ada': s:adaSubTypes, 'c': s:cSubTypes, 'cpp': s:cSubTypes }

  " Disable any languages which the user wants disabled
  for l:key in keys(s:typeMap)
    if exists('g:TagsParserDisableLang_{l:key}')
      unlet s:typeMap[l:key]
    endif
  endfor

  " Lastly, remove any headings that the user wants explicitly disabled
  for l:key in keys(s:typeMap)
    " now remove any unwanted types, start at the end of the list so that we
    " don't mess things up by deleting entries and changing the length of the
    " array
    let l:index = len(s:typeMap[l:key]) - 1
    while l:index > 0
      if exists('g:TagsParserDisableType_{l:key}_' . 's:typeMap[l:key][l:index][0]')
        call remove(s:typeMap[l:key], l:index)
      endif
      let l:index -= 1
    endwhile " while l:index > 0
  endfor " for l:key in keys(s:typeMap)

  let s:typeMapHeadingFold = { }

  " build up a list of any headings that the user wants to be automatically
  " folded
  for l:key in keys(s:typeMap)
    " loop through the headings, and add the actual heading pattern to the
    " heading fold structure
    let l:index = 0
    while l:index < len(s:typeMap[l:key])
      if exists('g:TagsParserFoldHeading_{l:key}_{s:typeMap[l:key][l:index][0]}')
        if !exists('s:typeMapHeadingFold[l:key]')
          let s:typeMapHeadingFold[l:key] = [ ]
        endif

        call add(s:typeMapHeadingFold[l:key], s:typeMap[l:key][l:index][1])
      endif
      let l:index += 1
    endwhile " while l:index < len(s:typeMap[l:key])
  endfor " for l:key in keys(s:typeMap)

  " Init the list of supported filetypes
  let s:supportedFileTypes = join(keys(s:typeMap), '$\|^')
  let s:supportedFileTypes = '^' . s:supportedFileTypes . '$'

  " setup the kind mappings for types that have member-types
  let s:adaKinds = { 'P': 'packspec', 'p': 'package', 'T': 'typespec', 't': 'type', 'U': 'subspec', 'u': 'subtype', 'c': 'component', 'l': 'literal', 'V': 'varspec', 'v': 'variable', 'n': 'constant', 'x': 'exception', 'f': 'formal', 'R': 'subprogspec', 'r': 'subprogram', 'K': 'taskspec', 'k': 'task', 'O': 'protectspec', 'o': 'protected', 'E': 'entryspec', 'e': 'entry', 'b': 'label', 'i': 'identifier', 'a': 'autovar', 'y': 'annon' }

  let s:cKinds = { 'c': 'class', 'g': 'enum', 'n': 'namespace', 's': 'struct', 'u': 'union' }

  " define the kinds which we can map in a hierarchical fashion
  let s:kindMap = { 'ada': s:adaKinds, 'c': s:cKinds, 'h': s:cKinds, 'cpp': s:cKinds }

endfunction " function! <SID>TagsParserInit()
" >>>
" TagsParserPerlInit - Init the default type names using Perl <<<
function! <SID>TagsParserPerlInit()
perl << PerlFunc
  use strict;
  use warnings;
  no warnings 'redefine';

  # define the data needed for displaying the tag data, define it in
  # the order desired for parsing, and each entry has the key into the
  # tags hash, the title for those types, and what fold level to put it at
  # the default fold level is 3 which allows for something along the lines of
  # namespace->class->function()

  # if you define a new set of types, make sure to prefix the name with
  # a "- " string so that it will be picked up by the "Type" syntax
  my @adaTypes = ( [ "P", "- Package Specs" ],
                   [ "p", "- Packages" ],
                   [ "T", "- Type Specs" ],
                   [ "t", "- Types" ],
                   [ "U", "- Subtype Specs" ],
                   [ "u", "- Subtypes" ],
                   [ "c", "- Components" ],
                   [ "l", "- Literals" ],
                   [ "V", "- Variable Specs" ],
                   [ "v", "- Variables" ],
                   [ "n", "- Constants" ],
                   [ "x", "- Exceptions" ],
                   [ "f", "- Formal Params" ],
                   [ "R", "- Subprogram Specs" ],
                   [ "r", "- Subprograms" ],
                   [ "K", "- Task Specs" ],
                   [ "k", "- Tasks" ],
                   [ "O", "- Protected Data Specs" ],
                   [ "o", "- Protected Data" ],
                   [ "E", "- Entry Specs" ],
                   [ "e", "- Entries" ],
                   [ "b", "- Labels" ],
                   [ "i", "- Identifiers" ],
                   [ "a", "- Auto Vars" ],
                   [ "y", "- Blocks" ] );

  my @asmTypes = ( [ "d", "- Defines" ],
                   [ "t", "- Types" ],
                   [ "m", "- Macros" ],
                   [ "l", "- Labels" ] );

  my @aspTypes = ( [ "f", "- Functions" ],
                   [ "s", "- Subroutines" ],
                   [ "v", "- Variables" ] );

  my @awkTypes = ( [ "f", "- Functions" ] );

  my @betaTypes = ( [ "f", "- Fragment Defs" ],
                    [ "p", "- All Patterns" ],
                    [ "s", "- Slots" ],
                    [ "v", "- Patterns" ] );

  my @cTypes = ( [ "n", "- Namespaces" ],
                 [ "c", "- Classes" ],
                 [ "d", "- Macros" ],
                 [ "t", "- Typedefs" ],
                 [ "s", "- Structures" ],
                 [ "g", "- Enumerations" ],
                 [ "u", "- Unions" ],
                 [ "x", "- External Vars" ],
                 [ "v", "- Variables" ],
                 [ "p", "- Prototypes" ],
                 [ "f", "- Functions" ],
                 [ "m", "- Struct/Union Members" ],
                 [ "e", "- Enumerators" ],
                 [ "l", "- Local Vars" ] );

  my @csTypes = ( [ "c", "- Classes" ],
                  [ "d", "- Macros" ],
                  [ "e", "- Enumerators" ],
                  [ "E", "- Events" ],
                  [ "f", "- Fields" ],
                  [ "g", "- Enumerations" ],
                  [ "i", "- Interfaces" ],
                  [ "l", "- Local Vars" ],
                  [ "m", "- Methods" ],
                  [ "n", "- Namespaces" ],
                  [ "p", "- Properties" ],
                  [ "s", "- Structs" ],
                  [ "t", "- Typedefs" ] );

  my @cobolTypes = ( [ "d", "- Data Items" ],
                     [ "f", "- File Descriptions" ],
                     [ "g", "- Group Items" ],
                     [ "p", "- Paragraphs" ],
                     [ "P", "- Program IDs" ],
                     [ "s", "- Sections" ] );

  my @eiffelTypes = ( [ "c", "- Classes" ],
                      [ "f", "- Features" ],
                      [ "l", "- Local Entities" ] );

  my @erlangTypes = ( [ "d", "- Macro Defs" ],
                      [ "f", "- Functions" ],
                      [ "m", "- Modules" ],
                      [ "r", "- Record Defs" ] );

  my @fortranTypes = ( [ "b", "- Block Data" ],
                       [ "c", "- Common Blocks" ],
                       [ "e", "- Entry Points" ],
                       [ "f", "- Functions" ],
                       [ "i", "- Interface Contents/Names/Ops" ],
                       [ "k", "- Type/Struct Components" ],
                       [ "l", "- Labels" ],
                       [ "L", "- Local/Common/Namelist Vars" ],
                       [ "m", "- Modules" ],
                       [ "n", "- Namelists" ],
                       [ "p", "- Programs" ],
                       [ "s", "- Subroutines" ],
                       [ "t", "- Derived Types/Structs" ],
                       [ "v", "- Program/Module Vars" ] );

  my @htmlTypes = ( [ "a", "- Named Anchors" ],
                    [ "f", "- Javascript Funcs" ] );

  my @javaTypes = ( [ "c", "- Classes" ],
                    [ "f", "- Fields" ],
                    [ "i", "- Interfaces" ],
                    [ "l", "- Local Vars" ],
                    [ "m", "- Methods" ],
                    [ "p", "- Packages" ] );

  my @javascriptTypes = ( [ "f", "- Functions" ] );

  my @lispTypes = ( [ "f", "- Functions" ] );

  my @luaTypes = ( [ "f", "- Functions" ] );

  my @makeTypes = ( [ "m", "- Macros" ] );

  my @pascalTypes = ( [ "f", "- Functions" ],
                      [ "p", "- Procedures" ] );

  my @perlTypes = ( [ "c", "- Constants" ],
                    [ "l", "- Labels" ],
                    [ "s", "- Subroutines" ] );

  my @phpTypes = ( [ "c", "- Classes" ],
                   [ "d", "- Constants" ],
                   [ "f", "- Functions" ],
                   [ "v", "- Variables" ] );

  my @pythonTypes = ( [ "c", "- Classes" ],
                      [ "m", "- Class Members" ],
                      [ "f", "- Functions" ] );

  my @rexxTypes = ( [ "s", "- Subroutines" ] );

  my @rubyTypes = ( [ "c", "- Classes" ],
                    [ "f", "- Methods" ],
                    [ "F", "- Singleton Methods" ],
                    [ "m", "- Modules" ] );

  my @schemeTypes = ( [ "f", "- Functions" ],
                      [ "s", "- Sets" ] );

  my @shTypes = ( [ "f", "- Functions" ] );

  my @slangTypes = ( [ "f", "- Functions" ],
                     [ "n", "- Namespaces" ] );

  my @smlTypes = ( [ "e", "- Exception Defs" ],
                   [ "f", "- Function Defs" ],
                   [ "c", "- Functor Defs" ],
                   [ "s", "- Signatures" ],
                   [ "r", "- Structures" ],
                   [ "t", "- Type Defs" ],
                   [ "v", "- Value Bindings" ] );

  my @sqlTypes = ( [ "c", "- Cursors" ],
                   [ "d", "- Prototypes" ],
                   [ "f", "- Functions" ],
                   [ "F", "- Record Fields" ],
                   [ "l", "- Local Vars" ],
                   [ "L", "- Block Label" ],
                   [ "P", "- Packages" ],
                   [ "p", "- Procedures" ],
                   [ "r", "- Records" ],
                   [ "s", "- Subtypes" ],
                   [ "t", "- Tables" ],
                   [ "T", "- Triggers" ],
                   [ "v", "- Variables" ] );

  my @tclTypes = ( [ "c", "- Classes" ],
                   [ "m", "- Methods" ],
                   [ "p", "- Procedures" ] );

  my @veraTypes = ( [ "c", "- Classes" ],
                    [ "d", "- Macro Defs" ],
                    [ "e", "- Enumerators" ],
                    [ "f", "- Functions" ],
                    [ "g", "- Enumerations" ],
                    [ "l", "- Local Vars" ],
                    [ "m", "- Class/Struct/Union Members" ],
                    [ "p", "- Programs" ],
                    [ "P", "- Prototypes" ],
                    [ "t", "- Tasks" ],
                    [ "T", "- Typedefs" ],
                    [ "v", "- Variables" ],
                    [ "x", "- External Vars" ] );

  my @verilogTypes = ( [ "c", "- Constants" ],
                       [ "e", "- Events" ],
                       [ "f", "- Functions" ],
                       [ "m", "- Modules" ],
                       [ "n", "- Net Data Types" ],
                       [ "p", "- Ports" ],
                       [ "r", "- Register Data Types" ],
                       [ "t", "- Tasks" ] );

  my @vimTypes = ( [ "a", "- Autocommand Groups" ],
                   [ "f", "- Functions" ],
                   [ "v", "- Variables" ] );

  my @yaccTypes = ( [ "l", "- Labels" ] );

  our %typeMap : unique = ( ada => \@adaTypes,
                            asm => \@asmTypes,
                            asp => \@aspTypes,
                            awk => \@awkTypes,
                            beta =>  \@betaTypes,
                            c => \@cTypes,
                            cpp => \@cTypes,
                            cs => \@csTypes,
                            cobol => \@cobolTypes, 
                            eiffel => \@eiffelTypes, 
                            erlang => \@erlangTypes, 
                            fortran => \@fortranTypes, 
                            html => \@htmlTypes, 
                            java => \@javaTypes, 
                            javascript => \@javascriptTypes, 
                            lisp => \@lispTypes, 
                            lua => \@luaTypes, 
                            make => \@makeTypes,
                            pascal => \@pascalTypes, 
                            perl => \@perlTypes,
                            php => \@phpTypes, 
                            python => \@pythonTypes,
                            rexx => \@rexxTypes, 
                            ruby => \@rubyTypes,
                            scheme => \@schemeTypes, 
                            sh => \@shTypes, 
                            slang => \@slangTypes, 
                            sml => \@smlTypes, 
                            sql => \@sqlTypes, 
                            tcl => \@tclTypes,
                            vera => \@veraTypes, 
                            verilog => \@verilogTypes, 
                            Vim => \@vimTypes,
                            yacc => \@yaccTypes ) unless(%typeMap);

  # create a subtype hash, much like the typeMap.  This will list what
  # sub-types to display, so for example, C struct types will only have it's
  # "m" member list checked which will list the fields of that struct, while
  # namespaces can have all of the types listed in the @cType array.
  my %adaSubTypes  = ( i => \@adaTypes,
                       t => [ [ "c", "" ],
                              [ "l", "" ],
                              [ "a", "- Discriminants" ] ],
                       u => [ [ "c", "" ],
                              [ "l", "" ],
                              [ "a", "- Discriminants" ] ],
                       P => \@adaTypes,
                       p => \@adaTypes,
                       R => \@adaTypes,
                       r => \@adaTypes,
                       K => \@adaTypes,
                       k => \@adaTypes,
                       O => \@adaTypes,
                       o => \@adaTypes,
                       E => \@adaTypes,
                       e => \@adaTypes,
                       y => \@adaTypes );

  my %cSubTypes  = ( f => [ [ "l", "" ] ],
                     s => [ [ "m", "" ] ],
                     u => [ [ "m", "" ] ],
                     g => [ [ "e", "" ] ],
                     c => \@cTypes,
                     n => \@cTypes );

  our %subTypeMap : unique = ( ada => \%adaSubTypes,
                               c => \%cSubTypes,
                               cpp => \%cSubTypes ) unless(%subTypeMap);

  my $success = 0;
  my $value = 0;

  # Disable any languages which the user wants disabled
  foreach my $key (keys %typeMap) {
    ($success, $value) = VIM::Eval("exists('g:TagsParserDisableLang_$key')");
    delete $typeMap{$key} if ($success == 1 and $value == 1);
  }

  # Lastly, remove any headings that the user wants explicitly disabled
  foreach my $key (keys %typeMap) {
    my $typeRef;

    # now remove any unwanted types, start at the end of the list so that we
    # don't mess things up by deleting entries and changing the length of the
    # array
    for (my $i = @{$typeMap{$key}} - 1; $typeRef = $typeMap{$key}[$i]; $i--) {
      ($success, $value) = VIM::Eval("exists('g:TagsParserDisableType_" .
        $key . "_" . $typeRef->[0] . "')");
      splice(@{$typeMap{$key}}, $i, 1) if ($success == 1 and $value == 1);
    }
  }

  our %typeMapHeadingFold : unique = ( ) unless(%typeMapHeadingFold);

  # build up a list of any headings that the user wants to be automatically
  # folded
  foreach my $key (keys %typeMap) {
    my $typeRef;

    # loop through the headings, and add the actual heading pattern to the
    # heading fold structure
    for (my $i = 0; $typeRef = $typeMap{$key}[$i]; $i++) {
      ($success, $value) = VIM::Eval("exists('g:TagsParserFoldHeading_" .
        $key . "_" . $typeRef->[0] . "')");
      push(@{$typeMapHeadingFold{$key}}, $typeRef->[1]) if
        ($success == 1 and $value == 1);
    }
  }

  # Init the list of supported filetypes
  VIM::DoCommand "let s:supportedFileTypes = '" .
    join('$\|^', keys %typeMap) . "'";
  VIM::DoCommand "let s:supportedFileTypes = '^' . s:supportedFileTypes . '\$'";

  # setup the kind mappings for types that have member-types
  my %adaKinds = ( P => "packspec",
                   p => "package",
                   T => "typespec",
                   t => "type",
                   U => "subspec",
                   u => "subtype",
                   c => "component",
                   l => "literal",
                   V => "varspec",
                   v => "variable",
                   n => "constant",
                   x => "exception",
                   f => "formal",
                   R => "subprogspec",
                   r => "subprogram",
                   K => "taskspec",
                   k => "task",
                   O => "protectspec",
                   o => "protected",
                   E => "entryspec",
                   e => "entry",
                   b => "label",
                   i => "identifier",
                   a => "autovar",
                   y => "annon" );
  
  my %cKinds = ( c => "class",
                  g => "enum",
                  n => "namespace",
                  s => "struct",
                  u => "union" );

  # define the kinds which we can map in a hierarchical fashion
  our %kindMap : unique = ( ada => \%adaKinds,
                            c => \%cKinds,
                            h => \%cKinds,
                            cpp => \%cKinds ) unless(%kindMap);
PerlFunc
endfunction " function! <SID>TagsParserPerlInit()
" >>>

" Configuration

" Perl Check - Warn if Perl is not installed, and Vim 7.0 is not running <<<
if !exists("g:TagsParserForceUsePerl")
  let g:TagsParserForceUsePerl = 0
endif

if (v:version < 700 || g:TagsParserForceUsePerl == 1) && !has('Perl')
  if !exists('g:TagsParserNoPerlWarning') || g:TagsParserNoPerlWarning == 0
    if (v:version < 700)
      echoerr "You must have a perl enabled version of Vim to use the TagsParser plugin."
    elseif g:TagsParserForceUsePerl == 1
      echoerr "The TagsParserForceUsePerl variable is set, but the current Vim version does not have perl enabled.  Please disable this variable to use the TagsParser plugin."
    endif
    echoerr "(to disable this warning set The g:TagsParserNoPerlWarning variable to 1 in your .vimrc)"
    echoerr " -- TagsParser Disabled -- "
  endif
  finish
endif " if (v:version < 700 || g:TagsParserForceUsePerl == 1) && !has('Perl')
" >>>
" Global Variables <<<
if !exists("g:TagsParserCtagsQualifiedTagSeparator")
  let g:TagsParserCtagsQualifiedTagSeparator = '\.\|:'
endif

if !exists("g:TagsParserUpdateTime")
  let g:TagsParserUpdateTime = 1000
endif

if !exists("g:TagsParserCtagsOptions")
  let g:TagsParserCtagsOptions = ""
endif

if v:version >= 700 && g:TagsParserForceUsePerl != 1
  if !exists("g:TagsParserCtagsOptionsTypeList")
    let g:TagsParserCtagsOptionsTypeList = []
  endif
endif

if !exists("g:TagsParserOff")
  let g:TagsParserOff = 0
endif

if !exists("g:TagsParserCurrentFileCWD")
  let g:TagsParserCurrentFileCWD = 0
endif

if !exists("g:TagsParserLastPositionJump")
  let g:TagsParserLastPositionJump = 0
endif

if !exists("g:TagsParserNoNestedTags")
  let g:TagsParserNoNestedTags = 0
endif

if !exists("g:TagsParserNoTagWindow")
  let g:TagsParserNoTagWindow = 0
endif

if !exists("g:TagsParserWindowLeft")
  let g:TagsParserWindowLeft = 0
endif

if !exists("g:TagsParserHorizontalSplit")
  let g:TagsParserHorizontalSplit = 0
endif

if !exists("g:TagsParserWindowTop")
  let g:TagsParserWindowTop = 0
endif

"based on The window position configuration variables, setup the tags window 
"split command
if g:TagsParserWindowLeft != 1 && g:TagsParserHorizontalSplit != 1
  let s:TagsWindowPosition = "botright vertical"
elseif g:TagsParserHorizontalSplit != 1
  let s:TagsWindowPosition = "topleft vertical"
elseif g:TagsParserWindowTop != 1
  let s:TagsWindowPosition = "botright"
else
  let s:TagsWindowPosition = "topleft"
endif

if !exists("g:TagsParserFoldColumnDisabled")
  let g:TagsParserFoldColumnDisabled = 0
endif

if !exists("g:TagsParserWindowSize")
  let g:TagsParserWindowSize = 40
endif

if !exists("g:TagsParserWindowName")
  let g:TagsParserWindowName = "__tags__"
endif

if !exists('g:TagsParserSingleClick')
  let g:TagsParserSingleClick = 0
endif

if !exists("g:TagsParserHighlightCurrentTag")
  let g:TagsParserHighlightCurrentTag = 0
endif

if !exists("g:TagsParserAutoOpenClose")
  let g:TagsParserAutoOpenClose = 0
endif

if !exists("g:TagsParserNoResize")
  let g:TagsParserNoResize = 0
endif

if !exists("g:TagsParserSortType") || g:TagsParserSortType != "line"
  let g:TagsParserSortType = "alpha"
endif

if !exists("g:TagsParserDisplaySignature")
  let g:TagsParserDisplaySignature = 0
endif

"Before moving on, validate that the current shell exists.
if executable(&shell) != 1
  echoerr "TagsParser Error - The currently configured shell (" . &shell .
        \ ") is not executable on this system.  This option must be" .
        \ " configured correctly for the TagsParser plugin to work correctly"
  echoerr " -- TagsParser Disabled -- "
  finish
endif

"if we are in the C:/WINDOWS/SYSTEM32 dir, change to C.  Odd things seem to
"happen if we are in the system32 directory
if has('win32') && getcwd() ==? 'C:\WINDOWS\SYSTEM32'
  let s:cwdChanged = 1
  cd C:\
else
  let s:cwdChanged = 0
endif

"if the tags program has not been specified by a user level global define,
"find the right tags program.  This checks exuberant-ctags first to handle the
"case where multiple tags programs are installed it is differentiated by an
"explicit name
if !exists("g:TagsParserTagsProgram")
  if executable("exuberant-ctags")
    let g:TagsParserTagsProgram = "exuberant-ctags"
  elseif executable("ctags")
    let g:TagsParserTagsProgram = "ctags"
  elseif executable("ctags.exe")
    let g:TagsParserTagsProgram = "ctags.exe"
  elseif executable("tags")
    let g:TagsParserTagsProgram = "tags"
  else
    echoerr "TagsParser - tags program not found, go to " .
          \"http://ctags.sourceforge.net/ to download it.  OR" .
          \"specify the path to a the Exuberant Ctags program " .
          \"using the g:TagsParserTagsProgram variable in your .vimrc"
    echoerr " -- TagsParser Disabled -- "
    finish
  endif
endif

if system(g:TagsParserTagsProgram . " --version") !~? "Exuberant Ctags"
  echoerr "TagsParser - ctags = " . g:TagsParserTagsProgram .
        \" go to http://ctags.sourceforge.net/ to download it.  OR" .
        \"specify the path to a the Exuberant Ctags program " .
        \"using the g:TagsParserTagsProgram variable in your .vimrc"
  echoerr " -- TagsParser Disabled -- "
  finish
endif

if s:cwdChanged == 1
  cd C:\WINDOWS\SYSTEM32
endif

"These variables are in Vim-style regular expressions, not per-style like they 
"used to be.  See ":help usr_27.txt" and ":help regexp" for more information.
"If the patterns are empty then they are considered disabled

"Init the directory exclude pattern to remove any . or _ prefixed directories
"because they are generally considered 'hidden'.  This will also have the
"benefit of preventing the tagging of any .tags directories
if !exists("g:TagsParserDirExcludePattern")
  let g:TagsParserDirExcludePattern = '.\+/\..\+\|.\+/_.\+\|\%(\ctmp\)\|' .
        \ '\%(\ctemp\)\|\%(\cbackup\)'
endif

if !exists("g:TagsParserDirIncludePattern")
  let g:TagsParserDirIncludePattern = ""
endif

"Init the file exclude pattern to take care of typical object, library
"backup, swap, dependency and tag file names and extensions, build artifacts, 
"gcov extenstions, etc.
if !exists("g:TagsParserFileExcludePattern")
  let g:TagsParserFileExcludePattern = '^.*\.\%(\co\)$\|^.*\.\%(\cobj\)$\|' .
        \ '^.*\.\%(\ca\)$\|^.*\.\%(\cso\)$\|^.*\.\%(\cd\)$\|' .
        \ '^.*\.\%(\cbak\)$\|^.*\.\%(\cswp\)$\|^.\+\~$\|' .
        \ '^\%(\ccore\)$\|^\%(\ctags\)$\|^.*\.\%(\ctags\)$\|' .
        \ '^.*\.\%(\ctxt\)$\|^.*\.\%(\cali\)$\|^.*\.\%(\cda\)$\|' .
        \ '^.*\.\%(\cbb\)$\|^.*\.\%(\cbbg\)$\|^.*\.\%(\cgcov\)$'
endif

if !exists("g:TagsParserFileIncludePattern")
  let g:TagsParserFileIncludePattern = ""
endif

" >>>
" Script Autocommands <<<
" No matter what, always install The LastPositionJump autocommand, if enabled
if g:TagsParserLastPositionJump == 1
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exec "normal g`\"" | endif
endif

" No matter what, always install The CurrentFileCWD autocommand, if enabled.  
if g:TagsParserCurrentFileCWD == 1
  autocmd BufEnter * if expand('<afile>:h') != getcwd() && &modifiable == 1 && isdirectory(expand('<afile>:h')) != 0 | silent cd <afile>:h | endif
endif

" only install the autocommands if the g:TagsParserOff variable is not set
if g:TagsParserOff == 0
  if g:TagsParserNoTagWindow == 0
    augroup TagsParserAutoCommands
      autocmd!
      "setup an autocommand that will expand the path described by
      "g:TagsParserTagsPath into a valid tag path
      autocmd VimEnter * call <SID>TagsParserExpandTagsPath() |
            \ call <SID>TagsParserPerformOp("open", "")

      "setup an autocommand so that when a file is written to it writes a tag
      "file if it a file that is somewhere within the tags path or the
      "g:TagsParserTagsPath path
      autocmd BufWritePost ?* call <SID>TagsParserPerformOp("tag", "")
    augroup end

    augroup TagsParserBufEnterWindowNotOpen
      autocmd BufEnter ?* call <SID>TagsParserPerformOp("open", "")
    augroup end
  elseif g:TagsParserNoTagWindow == 1
    augroup TagsParserAutoCommands
      autocmd!
      "setup an autocommand that will expand the path described by
      "g:TagsParserTagsPath into a valid tag path
      autocmd VimEnter * call <SID>TagsParserExpandTagsPath()

     "setup an autocommand so that when a file is written to it writes a tag 
     "file if it a file that is somewhere within the tags path or the 
     "g:TagsParserTagsPath path
      autocmd BufWritePost ?* call <SID>TagsParserPerformOp("tag", "")
    augroup end
  endif
endif
" >>>
" Setup Commands <<<

" TagsParser functionality
command! -nargs=0 TagsParserToggle :call <SID>TagsParserToggle()
nmap <leader>t<space> :TagsParserToggle<CR>

command! -nargs=+ -complete=dir TagDir 
      \ :call <SID>TagsParserSetupDirectoryTags(<q-args>)

" A command that can be used to print out all files that are currently in the 
" TagsParserTagsPath path.
command! -nargs=0 TagsParserPrintPath :echo 'g:TagsParserTagsPath = ' . g:TagsParserTagsPath . "\n\n" . globpath(g:TagsParserTagsPath, "*")

" Turning TagsParser functionality completely off (and then back on)
command! -nargs=0 TagsParserOff :call <SID>TagsParserOff()
nmap <leader>tof :TagsParserOff<CR>
command! -nargs=0 TagsParserOn :call <SID>TagsParserOn()
nmap <leader>ton :TagsParserOn<CR>

" do a copen/cwindow so The quickfix window stretches over the whole window
command! -nargs=* TagsParserCBot :botright copen <args>
nmap <leader>tbo :TagsParserCBot<CR>
command! -nargs=* TagsParserCBotWin :botright cwindow <args>
nmap <leader>tbw :TagsParserCBotWin<CR>

" do a 'smart' copen/cwindow so that the quickfix window is only below the
" main window
command! -nargs=* TagsParserCOpen :call <SID>TagsParserCOpen(<f-args>)
nmap <leader>to :TagsParserCOpen<CR>
command! -nargs=* TagsParserCWindow :call <SID>TagsParserCWindow(<f-args>)
nmap <leader>tw :TagsParserCWindow<CR>

" for convenience
nmap <leader>tc :cclose
" >>>
" Initialization <<<

" Check for any depreciated variables and options
if exists("g:MyTagsPath")
  echomsg "The MyTagsPath variable is depreciated, please use TagsParserTagsPath instead."
  echomsg "This path should be set in The same way that all VIM paths are, using commas instead of spaces.  Please see ':help path' for more information."
endif

if exists("g:TagsParserFindProgram")
  echomsg "The TagsParserFindProgram variable is no longer necessary, you can remove it from your .vimrc"
endif

"init the matched tag fold flag
let s:matchedTagFoldStart = 0
let s:matchedTagFoldEnd = 0
let s:matchedTagWasFolded = 0

"init the update values 
let s:tagsDataUpdated = 1
let s:lastFileDisplayed = ""

let s:TagsParserClosedBuffer = ""

"setup the mappings to handle single click
if g:TagsParserSingleClick == 1
  let s:clickmap = ':if bufname("%") == g:TagsParserWindowName <bar> call <SID>TagsParserSelectTag() <bar> endif <CR>'
  if maparg('<LeftMouse>', 'n') == '' 
    " no mapping for leftmouse
    exec ':nnoremap <silent> <LeftMouse> <LeftMouse>' . s:clickmap
  else
    " we have a mapping
    let  s:m = ':nnoremap <silent> <LeftMouse> <LeftMouse>'
    let  s:m = s:m . substitute(substitute(maparg('<LeftMouse>', 'n'), '|', '<bar>', 'g'), '\c^<LeftMouse>', '', '')
    let  s:m = s:m . s:clickmap
    exec s:m
  endif
endif

" Call the proper init function.  Either the Perl or the Vim script version 
" depending on if the user is running Vim 7.0 or later.
if v:version >= 700 && g:TagsParserForceUsePerl != 1
  call <SID>TagsParserInit()
else
  call <SID>TagsParserPerlInit()
endif
" >>>

" Functions

" TagsParserFindTagWindow - returns the window # the tag buffer is in <<<
function! <SID>TagsParserFindTagWindow()
  return index(tabpagebuflist(tabpagenr()), bufnr(g:TagsParserWindowName))
endfunction
" >>>
" TagsParserPerformOp - Checks that The current file is in the tag path <<<
" Based on the input, it will either open the tag window or tag the file.
" For either op, it will make sure that the current file is within the
" g:TagsParserTagsPath path, and then perform some additional checks based on
" the operation it is supposed to perform
function! <SID>TagsParserPerformOp(op, file)
  if a:file == ""
    let l:pathName = expand("%:p:h")
    let l:fileName = expand("%:t")
    let l:curFile = expand("%:p")
  else
    let l:pathName = fnamemodify(a:file, ":p:h")
    let l:fileName = fnamemodify(a:file, ":t")
    let l:curFile = fnamemodify(a:file, ":p")
  endif

  "Make sure that the file we are working on is _not_ a directory
  if isdirectory(l:curFile)
    return
  endif

  "before we check to see if this file is in within TagsParserTagsPath, do the 
  "simple checks to see if this file name and/or path meet the include or
  "exclude criteria
  "The general logic here is, if the pattern is not empty (therefore not
  "disabled), and an exclude pattern matches, or an include pattern fails to 
  "match, return early.
  if (g:TagsParserDirExcludePattern != "" && l:pathName =~ g:TagsParserDirExcludePattern) || (g:TagsParserFileExcludePattern != "" && l:fileName =~ g:TagsParserFileExcludePattern) || (g:TagsParserDirIncludePattern != "" && l:pathName !~ g:TagsParserDirIncludePattern) || (g:TagsParserFileIncludePattern != "" && l:fileName !~ g:TagsParserFileIncludePattern)
    return
  endif

  if exists("g:TagsParserTagsPath")
    let l:tagPathFileMatch = globpath(g:TagsParserTagsPath, l:fileName)
  
    " Put the path, and file into lowercase if this is windows... Since 
    " windows filenames are case-insensitive.
    if has('win32')
      let l:curFile = tolower(l:curFile)
      let l:tagPathFileMatch = tolower(l:tagPathFileMatch)
    endif

    " See if the file is within the current path
    if stridx(l:tagPathFileMatch, l:curFile) != -1
      if a:op == "tag"
        call <SID>TagsParserTagFile(a:file)
      elseif a:op == "open" && g:TagsParserAutoOpenClose == 1 && filereadable(l:pathName . "/.tags/" .  substitute(l:fileName, " ", "_", "g") . ".tags") && &filetype =~ s:supportedFileTypes
        call <SID>TagsParserOpenTagWindow()
      endif
    endif " if stridx(l:tagPathFileMatch, l:curFile) != -1
  endif " if exists("g:TagsParserTagsPath")
endfunction " function! <SID>TagsParserPerformOp(op, file)
" >>>
" TagsParserTagFile - Runs tags on a file and names The tag file <<<
" this function will run Ctags for a file and write it to
" ./.tags/<file>.tags it will also create the ./.tags directory if it doesn't
" exist
function! <SID>TagsParserTagFile(file)
  "if the file argument is empty, make it the current file with fully
  "qualified path
  if a:file == ""
    let l:fileName = expand("%:p")

    "gather any user options that may be defined
    if exists("g:TagsParserCtagsOptions_{&filetype}")
      let l:userOptions = g:TagsParserCtagsOptions_{&filetype}
    else
      let l:userOptions = ""
    endif
  else
    let l:fileName = a:file
    let l:userOptions = ""

    "check the list of types that options are defined for, if a filetype is in 
    "the list, and the g:TagsParserCtagsOptions_{type} variable exists, append 
    "it to the userOptions string.  But only do this if the vim version is 7.0 
    "or greater.
    if v:version >= 700 && g:TagsParserForceUsePerl != 1
      for l:type in g:TagsParserCtagsOptionsTypeList
        if exists("g:TagsParserCtagsOptions_{l:type}")
          let l:userOptions = l:userOptions . g:TagsParserCtagsOptions_{l:type} . " "
        endif
      endfor
    endif " if v:version >= 700 && g:TagsParserForceUsePerl != 1
  endif " if a:file == ""

  "cleanup the tagfile, regular file and directory names, we have to replace
  "spaces in the actual file name with underscores for the tag file, or else
  "the sort option throws an error for some reason
  let l:baseDir = substitute(fnamemodify(l:fileName, ":h"), '\', '/', 'g')
  let l:tagDir = substitute(fnamemodify(l:fileName, ":h") . "/.tags", '\', '/', 'g')
  let l:tagFileName = substitute(fnamemodify(l:fileName, ":h") . "/.tags/" . fnamemodify(l:fileName, ":t") . ".tags", '\', '/', 'g')
  let l:fileName = substitute(l:fileName, '\', '/', 'g')

  "make the .tags directory if it doesn't exist yet
  if !isdirectory(l:tagDir)
    exe system("mkdir \"" . l:tagDir . "\"")
    let l:noTagFile = "true"
  elseif !filereadable(l:tagFileName)
    let l:noTagFile = "true"
  else 
    let l:noTagFile = "false"
  endif
  
  "if we are in the C:/WINDOWS/SYSTEM32 dir, change to C.  Odd things seem to
  "happen if we are in the system32 directory
  if has('win32') && getcwd() ==? 'C:\WINDOWS\SYSTEM32'
    let s:cwdChanged = 1
    cd C:\
  else
    let s:cwdChanged = 0
  endif

  "now run the tags program
  exec system(g:TagsParserTagsProgram . " -f \"" . l:tagFileName . "\" " . g:TagsParserCtagsOptions . " " . l:userOptions . " --format=2 --extra=+q --excmd=p --fields=+nS-t --sort=yes --tag-relative=yes \"" . l:fileName . "\"")

  if s:cwdChanged == 1
    cd C:\WINDOWS\SYSTEM32
  endif

  if filereadable(l:tagFileName)
    let l:tagFileExists = "true"
  else
    let l:tagFileExists = "false"
  endif

  "if this file did not have a .tags/*.tags file up until this point and
  "now it does call <SID>TagsParserExpandTagsPath to get the new file included
  if l:noTagFile == "true" && l:tagFileExists == "true"
    call <SID>TagsParserExpandTagsPath()
  endif
endfunction " function! <SID>TagsParserTagFile(file)
" >>>
" TagsParserExpandTagsPath - Expands a directory into a list of tags <<< 
" This will expand The g:TagsParserTagsPath directory list into valid tag
" files
function! <SID>TagsParserExpandTagsPath()
  if !exists("s:OldTagsPath")
    let s:OldTagsPath = &tags
  endif

  if exists("g:TagsParserTagsPath")
    if s:OldTagsPath !~ ""
      " for the tags path we must make sure that all \'s are turned into /'s.  
      " Additionally, if there are any spaces they must be escaped by a \.
      let &tags = substitute(substitute(join(split(globpath(g:TagsParserTagsPath, '.tags/*.tags'), '\n'), ","), '\', '/', 'g'), ' ', '\\ ', 'g') . "," . s:OldTagsPath
    else
      let &tags = substitute(substitute(join(split(globpath(g:TagsParserTagsPath, '.tags/*.tags'), '\n'), ","), '\', '/', 'g'), ' ', '\\ ', 'g')
    endif " if s:OldTagsPath !~ ""
  endif " if exists("g:TagsParserTagsPath")
endfunction " function! <SID>TagsParserExpandTagsPath()
" >>>
" TagsParserSetupDirectoryTags - creates tags for all files in this dir <<<
" This takes a directory as a parameter and creates tag files for all files
" under this directory based on The same include/exclude rules that are used
" when a file is written out.  Except that this function does not need to
" follow the TagsParserPath rules.
function! <SID>TagsParserSetupDirectoryTags(dir)
  "if the TagsParserOff flag is set, print out an error and do nothing
  if g:TagsParserOff != 0
    echomsg "TagsParser cannot tag files in this directory because plugin is turned off"
    return
  endif

  "make sure that a:dir does not contain \\ but contains /
  let l:dir = substitute(expand(a:dir), '\', '/', "g")

  if !isdirectory(l:dir)
    echomsg "Directory provided : " . l:dir . " is not a valid directory"
    return
  endif

  "find all files in this directory and all subdirectories
  let l:fileList = globpath(l:dir . '/**,' . l:dir, '*')

  "now parse those into separate files using Perl and then call the
  "TagFile for each file to give it a tag list
  if v:version >= 700 && g:TagsParserForceUsePerl != 1
    for l:file in split(l:fileList, '\n')
      call <SID>TagsParserPerformOp('tag', l:file)
    endfor
  else
    call <SID>TagsParserPerlFinishPerformOp(l:fileList)
  endif
endfunction " function! <SID>TagsParserSetupDirectoryTags(dir)
" >>>
" TagsParserDisplayEntry - Used to recursively display tag information <<<
function <SID>TagsParserDisplayEntry(entry)
  " set the display string, tag or signature
  if g:TagsParserDisplaySignature == 1
    let l:dispString = a:entry.pattern
    " remove all whitespace from the beginning and end of the display 
    " string
    call substitute(l:dispString, '^\s*\(.*\)\s\*$', '\1', 'g')
  else
    let l:dispString = a:entry.tag
  endif

  " each tag must have a {{{ at the end of it or else it could mess with 
  " the folding... Since there are no end folds each tag must have a fold 
  " marker
  call add(s:printData, [ repeat("\t", s:printLevel) . l:dispString . ' {{{' . (s:printLevel + 1), a:entry ])

  " now print any members there might be
  if exists('a:entry.members') && exists('s:subTypeMap[s:origFileType][a:entry.tagtype]')
    let s:printLevel += 1

    " now print any members that this entry may have, only show types 
    " which make sense, so for a "s" entry only display "m", this is based 
    " on the subTypeMap data.
    for l:subTypeRef in s:subTypeMap[s:origFileType][a:entry.tagtype]
      " for each entry in the subTypeMap for this particular entry, check 
      " if there are any entries, if there are print them
      if exists('a:entry.members[l:subTypeRef[0]]')
        " display a header (if one exists)
        if l:subTypeRef[1] != ""
          call add(s:printData, [ repeat("\t", s:printLevel) . l:subTypeRef[1] . ' {{{' . (s:printLevel + 1) ])
          let s:printLevel += 1
        endif

        " display the data for this sub type, sort them properly based
        " on the global flag
        if g:TagsParserSortType == "alpha"
          for l:member in sort(a:entry.members[l:subTypeRef[0]], "TagsParserTagSort")
            call <SID>TagsParserDisplayEntry(l:member)
          endfor
        else
          for l:member in sort(a:entry.members[l:subTypeRef[0]], "TagsParserLineSort")
            call <SID>TagsParserDisplayEntry(l:member)
          endfor
        endif " if g:TagsParserSortType == "alpha"

        " reduce the print level if we increased it earlier and print 
        " a fold end marker
        if l:subTypeRef[1] != ""
          let s:printLevel -= 1
        endif
      endif " if exists('a:entry.members[l:subTypeRef[0]]')
    endfor " for l:subTypeRef in s:subTypeMap[s:origFileType][a:entry.tagtype]

    let s:printLevel -= 1
  endif " if exists('a:entry.members') && exists('s:subTypeMap[...
endfunction " function <SID>TagsParserDisplayEntry(entry)
" >>>
" TagsParserDisplayTags - This will display The tags for the current file <<<
function! <SID>TagsParserDisplayTags()
  "For some reason the ->Append(), ->Set() and ->Delete() functions don't
  "work unless the Perl buffer object is the current buffer... So, change
  "to the tags buffer.
  let l:tagBufNum = bufnr(g:TagsParserWindowName)
  if l:tagBufNum == -1
    return
  endif

  let l:curBufNum = bufnr("%")

  "now change to the tags window if the two buffers are not the same
  if l:curBufNum != l:tagBufNum
    "if we were not originally in the tags window, we need to save the
    "filetype before we move, otherwise the calling function will have saved
    "it for us
    let s:origFileType = &filetype
    let s:origFileName = expand("%:t")
    let s:origFileTagFileName = expand("%:p:h") . "/.tags/" . expand("%:t") . ".tags"
    exec bufwinnr(l:tagBufNum) . "wincmd w"
  endif

  "before we start drawing the tags window, check for the update flag, and
  "make sure that the filetype we are attempting to display is supported
  if s:tagsDataUpdated == 0 && s:lastFileDisplayed == s:origFileName ||
        \ s:origFileType !~ s:supportedFileTypes
    "we must return to the previous window before we can just exit
    if l:curBufNum != l:tagBufNum
      exec bufwinnr(s:origFileName) . "wincmd w"
    endif

    return
  endif

  "before we start editing the contents of the tags window we need to make
  "sure that the tags window is modifiable
  setlocal modifiable

  if v:version >= 700 && g:TagsParserForceUsePerl == 0
    " make sure that s:tags is created
    if !exists('s:tags')
      let s:tags = { }
    endif

    " temp array to store our tag info... At the end of the file we will check
    " to see if this is different than the globalPrintData, if it is we update
    " the screen, if not then we do nothing so as to maintain any folded 
    " sections the user has created.
    let s:printData = [ ]
    let s:printLevel = 0

    " at the very top, print out the filename and a blank line
    call add(s:printData, [ s:origFileName . ' {{{' . (s:printLevel + 1) ] )
    call add(s:printData, [ "" ])
    let s:printLevel += 1

    for l:ref in s:typeMap[s:origFileType]
      " verify that there are any entries defined for this particular tag type 
      " before we start trying to print them and that they don't have a parent 
      " tag.
      let l:printTopLevelType = 0
      if exists('s:tags[s:origFileTagFileName][l:ref[0]]')
        for l:typeCheckRef in s:tags[s:origFileTagFileName][l:ref[0]]
          if !exists('l:typeCheckRef.parent')
            let l:printTopLevelType = 1
          endif
        endfor
      endif

      if l:printTopLevelType == 1
        call add(s:printData, [ repeat("\t", s:printLevel) . l:ref[1] . ' {{{' . (s:printLevel + 1) ])
    
        let s:printLevel += 1
        " now display all the tags for this particular type, and sort them 
        " according to the sortType
        if g:TagsParserSortType == "alpha"
          for l:tagRef in sort(s:tags[s:origFileTagFileName][l:ref[0]], "TagsParserTagSort")
            if !exists('l:tagRef.parent')
              call <SID>TagsParserDisplayEntry(l:tagRef)
            endif
          endfor
        else
          for l:tagRef in sort(s:tags[s:origFileTagFileName][l:ref[0]], "TagsParserLineSort")
            if !exists('l:tagRef.parent')
              call <SID>TagsParserDisplayEntry(l:tagRef)
            endif
          endfor
        endif " if g:TagsParserSortType == "alpha"

        let s:printLevel -= 1
        " between each listing put a line
        call add(s:printData, [ "" ])
      endif " if l:printTopLevelType == 1
    endfor " for l:ref in s:typeMap[s:origFileType]

    " this hash will be used to keep all of the data referenceable... So that 
    " we will be able to print the correct information, reach that info when 
    " the tag is to be selected, and find the current tag that the cursor is 
    " on in the main window
    if !exists('s:globalPrintData')
      let s:globalPrintData = [ ]
    endif

    " check to see if the data has changed
    let l:update = 1
    if s:lastFileDisplayed != "" && len(s:printData) == len(s:globalPrintData)
      let l:update = 0

      let l:index = 0
      while l:index < len(s:globalPrintData)
        if s:printData[l:index][0] != s:globalPrintData[l:index][0]
          let l:update = 1
        endif

        " no matter if the display data changed or not, make sure to assign
        " the tag reference to the global data... Otherwise things like line 
        " numbers may have changed and the tag window would not have the 
        " proper data.
        if exists('s:printData[l:index][1]')
          let s:globalPrintData[l:index][1] = s:printData[l:index][1]
        endif

        let l:index += 1
      endwhile " while l:index < len(s:globalPrintData)
    endif " if s:lastFileDisplayed != "" && len(s:printData) == len(...

    " if the data did not change, do nothing and quit
    if l:update == 1
      let s:globalPrintData = copy(s:printData)

      " first clean the window, using the "_ register to prevent the text from 
      " being collected into the "" register.
      exec "normal 1G\"_dG"

      " then set the first line
      call setline(0, "")

      " lastly append the rest of the data into the window
      for l:line in reverse(s:printData)
        call append(1, l:line[0])
      endfor
    endif " if l:update == 1

    " if the fold level is not set, go through the window now and fold any 
    " tags that have members
    if !exists('g:TagsParserFoldLevel') || g:TagsParserFoldLevel == 0
      let l:foldLevel = -1
    else
      let l:foldLevel = g:TagsParserFoldLevel
    endif

    if !exists('s:typeMapHeadingFold')
      let s:typeMapHeadingFold = { }
    endif

    " in the perl version there is a "FOLD_LOOP:" label here, and to terminate 
    " the following loop early it simply does a "next FOLD_LOOP;".  Vim does 
    " not have such devices so I enclose the loop in a try block and will just 
    " throw an error if the loop can be abandoned early.
    let l:index = 0
    while l:index < len(s:globalPrintData)
      try " FOLD_LOOP
        let l:line = s:globalPrintData[l:index]
        " if this is a tag that has a parent and members, and is not already 
        " folded, fold it.
        if l:foldLevel == -1 && exists('l:line[1].members')
          if exists('l:line[1].parent') && foldclosed(l:index + 2) == -1
            exec l:index + 2 . "foldclose"
          else
            for l:memberKey in keys(l:line[1].members)
              for l:possibleType in s:subTypeMap[s:origFileType][l:line[1].tagtype]
                " immediately skip to the next loop iteration if we find that 
                " a member exists for this tag which contains a non-empty 
                " heading
                if l:memberKey == l:possibleType[0] && l:possibleType[1] != ""
                  throw "FOLD_LOOP"
                endif
              endfor " for l:possibleType in s:subTypeMap[s:origFileType]...
            endfor " for l:memberKey in keys(l:line[1].members)

            " if we made it this far then this tag should be folded
            if foldclosed(l:index + 2) == -1
              exec l:index + 2 . "foldclose"
            endif
          endif " if exists('l:line[1].parent') && foldclosed(l:index ...
        elseif exists('s:typeMapHeadingFold[s:origFileType]') && !exists('l:line[1]') && l:line[0] =~ '^\s\+- .* {{{\d\+$'
          " lastly, if this is a heading which has been marked for folding, 
          " fold it
          for l:heading in s:typeMapHeadingFold[s:origFileType]
            if l:line[0] =~ '^\s\+' . l:heading . ' {{{\d\+$' && foldclosed(l:index + 2) == -1
              exec l:index + 2 . "foldclose"
            endif
          endfor
        endif " elseif exists('s:typeMapHeadingFold[s:origFileType]') && ...
      catch FOLD_LOOP
      endtry " end FOLD_LOOP try
      let l:index += 1
    endwhile " while l:index < len(s:globalPrintData)

    " before continuing, we must delete the printLevel and printData temp 
    " variables
    unlet s:printData
    unlet s:printLevel
  else
    call <SID>TagsParserPerlDisplayTags()
  endif " if v:version >= 700 && g:TagsParserForceUsePerl != 1

  "before we go back to the previous window, mark this one as not
  "modifiable, but only if this is currently the tags window
  setlocal nomodifiable

  "mark the update flag as false, and the last file we displayed as what we
  "just worked through
  let s:tagsDataUpdated = 0
  let s:lastFileDisplayed = s:origFileName

  "mark the last tag selected as not folded so accidental folding does not
  "occur
  let s:matchedTagWasFolded = 0

  "go back to the window we were in before moving here, if we were not
  "originally in the tags buffer
  if l:curBufNum != l:tagBufNum
    exec bufwinnr(s:origFileName) . "wincmd w"

    if g:TagsParserHighlightCurrentTag == 1
      call <SID>TagsParserHighlightTag(1)
    endif
  endif
endfunction " function! <SID>TagsParserDisplayTags()
" >>>
" TagsParserParseCurrentFile - parses The tags file for the current file <<<
" This takes the current file, parses the tag file (if it has not been
" parsed yet, or the tag file has been updated), and saves it into a global
" Perl hash struct for use by the function which prints out the data
function! <SID>TagsParserParseCurrentFile()
  "get the name of the tag file to parse, for the tag file name itself,
  "replace any spaces in the original filename with underscores
  let l:tagFileName = expand("%:p:h") . "/.tags/" . expand("%:t") . ".tags"

  "make sure that the tag file exists before we start this
  if !filereadable(l:tagFileName)
    return
  endif

  if v:version >= 700 && g:TagsParserForceUsePerl != 1
    " Initialize the variables used to hold the tag data
    if !exists('s:tags')
      let s:tags = { }
    endif
    if !exists('s:tagMTime')
      let s:tagMTime = { }
    endif
    if !exists('s:tagsByLine')
      let s:tagsByLine = { }
    endif

    " initialize the last modify time if it has not been accessed yet
    if !exists('s:tagMTime[l:tagFileName]')
      let s:tagMTime[l:tagFileName] = 0
    endif

    " if this file has been tagged before and the tag file has not been 
    " updated, just exit
    if getftime(l:tagFileName) <= s:tagMTime[l:tagFileName]
      let s:tagsDataUpdated = 0
      return
    endif

    " otherwise, record the current write time of the tag file, and mark the 
    " update flag.
    let s:tagMTime[l:tagFileName] = getftime(l:tagFileName)
    let s:tagsDataUpdated = 1

    " clear out the current tag data for this tag file
    if exists('s:tags[l:tagFileName]')
      unlet s:tags[l:tagFileName]
    endif

    " initialize this entry to empty
    let s:tags[l:tagFileName] = { }

    " open up the tag file and read the data
    for l:line in readfile(l:tagFileName)
      if l:line =~ '^!_TAG.*'
        continue
      endif

      " split the stuff around the pattern with tabs
      let [ l:tag, l:file; l:rest ] = split(l:line, "\t")

      " now join l:rest by tabs and split on the ;\"\t string
      let [ l:pattern, l:restString ] = split(join(l:rest, "\t"), ";\"\t")

      " split the remaining items into the type and field list
      let [ l:type; l:fields ] = split(l:restString, "\t")

      " cleanup pattern to remove the / / from around the tag search pattern, 
      " the hard part is that sometimes the $ may not be at the end of the 
      " pattern
      if l:pattern =~ '/^.*$/'
        let l:pattern = substitute(l:pattern, '/^\(.*\)$/', '\1', 'g')
      else
        let l:pattern = substitute(l:pattern, '/^\(.*\)/', '\1', 'g')
      endif " if l:pattern =~ '/^.*$/'

      " there may be some escaped /'s in the pattern, un-escape them
      let l:pattern = substitute(l:pattern, '\\\/', '/', 'g')

      " if the " file:" tag is here, remove it, we want it to be in the file 
      " since Vim can use the file: field to know if something is file static, 
      " but we don't care about it much for this script, and it messes up my 
      " hash creation
      let l:fileIdx = index(l:fields, 'file:')
      if l:fileIdx != -1
        call remove(l:fields, l:fileIdx)
      endif

      " now add all these items to the tag hash/dictionary
      let l:tmpEntry = { }
      let l:tmpEntry = { 'tag': l:tag, 'tagtype': l:type, 'pattern': l:pattern }
      for l:pair in l:fields
        " when splitting up the pairs make sure only to split on a single :, 
        " otherwise some of the C/C++ __anon#::__anon# parent structure names 
        " can mess up the hash construction
        let [ l:key, l:value ] = split(l:pair, '\%(:\)\@<!:\%(:\)\@!')
        let l:tmpEntry[l:key] = l:value
      endfor

      if !exists('s:tags[l:tagFileName][l:type]')
        let s:tags[l:tagFileName][l:type] = [ ]
      endif

      " Only create the tag if the l:tmpEntry.tag does not contain 
      " a separation character such as . or :
      if l:tmpEntry.tag !~ g:TagsParserCtagsQualifiedTagSeparator
        call add(s:tags[l:tagFileName][l:type], deepcopy(l:tmpEntry))
      endif 
    endfor " for l:line in readfile(l:tagFileName)

    " before worrying about anything else, make up a line number-oriented hash 
    " of the tags, this will make finding a match, or what the current tag is 
    " easier
    if exists('s:tagsByLine[l:tagFileName]')
      call remove(s:tagsByLine, l:tagFileName)
    endif
    let s:tagsByLine[l:tagFileName] = { }

    for [ l:key, l:typeArray ] in items(s:tags[l:tagFileName])
      for l:tagEntry in l:typeArray
        if !exists('s:tagsByLine[l:tagFileName][l:tagEntry.line]')
          let s:tagsByLine[l:tagFileName][l:tagEntry.line] = [ ]
        endif

        call add(s:tagsByLine[l:tagFileName][l:tagEntry.line], l:tagEntry)
      endfor
    endfor

    " parse the data we just read into hierarchies... If we don't have a kind 
    " hash entry for the current file type or nested tag display is disabled, 
    " just skip the rest of this function
    if !exists('s:kindMap[&filetype]') || g:TagsParserNoNestedTags == 1
      return
    endif

    " for each key, sort it's entries.  These are the tags for each tag, check 
    " for any types which have a scope, and if they do, reference that type to 
    " the correct parent type
    "
    " yeah, this loop sucks, but I haven't found a more efficient way to do it 
    " yet
    for l:key in keys(s:tags[l:tagFileName])
      for l:tagEntry in s:tags[l:tagFileName][l:key]
        for [ l:tagType, l:tagTypeName ] in items(s:kindMap[&filetype])
          " search for any member types of the current tagEntry, but only if 
          " such a member is defined for the current tag
          if exists('l:tagEntry[l:tagTypeName]') && exists('s:tags[l:tagFileName][l:tagType]')
            " sort the possible member entries into reverse order by line 
            " number so that when looking for the parent entry we are sure to 
            " only get the one who's line is just barely less than the current 
            " tag's line
            for l:tmpEntry in sort(s:tags[l:tagFileName][l:tagType], "TagsParserReverseLineSort")
              " for the easiest way to do this, only consider tags a match if 
              " the line number of the possible parent tag is less than or 
              " equal to the line number of the current tagEntry.  Instead of 
              " just doing line <= line add 0 to the line numbers to prevent 
              " them from being compared like strings.
              if l:tmpEntry.tag == l:tagEntry[l:tagTypeName] && (0 + l:tmpEntry.line) <= (0 + l:tagEntry.line)
                if !exists('l:tmpEntry.members')
                  let l:tmpEntry.members = { }
                endif

                if !exists('l:tmpEntry.members[l:key]')
                  let l:tmpEntry.members[l:key] = [ ]
                endif

                call add(l:tmpEntry.members[l:key], l:tagEntry)
                let l:tagEntry.parent = l:tmpEntry

                " since we found the correct parent entry for the current tag, 
                " break out of the innermost for loop
                break
              endif " if l:tmpEntry.tag == l:tagEntry[l:tagTypeName] && ...
            endfor " for l:tmpEntry in sort(s:tags[l:tagFileName]...
          endif " if exists('l:tagEntry[l:tagTypeName]') && exists...
        endfor " for [ l:tagType, l:tagTypeName ] in values(s:kindMap...
      endfor " for l:tagEntry in s:tags[l:tagFileName][l:key]
    endfor " for l:key in keys(s:tags[tagFile])

    " processing those local vars for C/C++
    if &filetype =~ 'c\|h\|cpp' && exists('s:tags[l:tagFileName].l') && exists('s:tags[l:tagFileName].f')
      " setup a reverse list of local variable references sorted by line
      let l:vars = sort(s:tags[l:tagFileName].l, "TagsParserReverseLineSort")

      " sort the functions by reversed line entry... Then we will go through 
      " the list of local variables until we find one who's line number 
      " exceeds that of the functions.  Then we remove that variable from the 
      " var list and move to the next function
      for l:funcRef in sort(s:tags[l:tagFileName].f, "TagsParserReverseLineSort")
        while len(l:vars) > 0
          let l:varRef = l:vars[0]

          if (0 + l:varRef.line) >= (0 + l:funcRef.line)
            if !exists('l:funcRef.members')
              let l:funcRef.members = { }
            endif

            if !exists('l:funcRef.members.l')
              let l:funcRef.members.l = [ ]
            endif

            call add(l:funcRef.members.l, l:varRef)
            let l:varRef.parent = l:funcRef

            " sine we used this varRef, we must remove it from the l:vars list
            call remove(l:vars, 0)
          else
            " break out of the var loop and head to the next function, because 
            " we hit a function whose line number is larger than the 
            " variable's line number
            break
          endif " if l:varRef.line >= l:funcRef.line
        endwhile " while len(l:vars) != 0
      endfor " for l:funcRef in sort(s:tags[l:tagFileName].f, ...
    endif " if &filetype =~ 'c\|h\|cpp' && exists('s:tags...
  else
    call <SID>TagsParserPerlParseFile(l:tagFileName)
  endif " if v:version >= 700 && g:TagsParserForceUsePerl != 1
endfunction
" >>>
" TagsParserOpenTagWindow - Opens up The tag window <<<
function! <SID>TagsParserOpenTagWindow()
  "ignore events while opening the tag window
  let l:oldEvents = &eventignore
  set eventignore=all

  "save the window number and potential tag file name for the current file
  let s:origFileName = expand("%:t")
  let s:origFileTagFileName = expand("%:p:h") . "/.tags/" . expand("%:t") . ".tags"
  "before we move to the new tags window, we must save the type of file
  "that we are currently in
  let s:origFileType = &filetype

  "parse the current file
  call <SID>TagsParserParseCurrentFile()

  "open the tag window
  if !bufloaded(g:TagsParserWindowName)
    if g:TagsParserNoResize == 0
      "track the current window size, so that when we close the tags tab, 
      "if we were not able to resize the current window, that we don't 
      "decrease it any more than we increased it when we opened the tab
      let s:origColumns = &columns
      "open the tag window, + 1 for the split divider
      let &columns = &columns + g:TagsParserWindowSize + 1
      let s:columnsAdded = &columns - s:origColumns
      let s:newColumns = &columns
    endif

    exec s:TagsWindowPosition . " " . g:TagsParserWindowSize  . " split " .
          \ g:TagsParserWindowName

    "settings to keep the buffer from interfering with anything else
    setlocal nonumber
    setlocal nobuflisted
    setlocal noswapfile
    setlocal buftype=nofile
    setlocal bufhidden=delete

    if v:version >= 700
      setlocal nospell
    endif

    "formatting related settings
    setlocal nowrap
    setlocal tabstop=2

    "fold related settings
    if exists('g:TagsParserFoldLevel')
      let l:foldLevelString = 'setlocal foldlevel=' . g:TagsParserFoldLevel
      exec l:foldLevelString
    else
      "if the foldlevel is not defined, default it to something large so that
      "the default folding method takes over
      setlocal foldlevel=100
    endif

    "only turn the fold column on if the disabled flag is not set
    if g:TagsParserFoldColumnDisabled == 0
      setlocal foldcolumn=3
    endif

    setlocal foldenable
    setlocal foldmethod=marker
    setlocal foldtext=TagsParserFoldFunction()
    setlocal fillchars=fold:\ 

    "if the highlight tag option is on, reduce the updatetime... But not too
    "much because it is global and it could impact overall VIM performance
    if g:TagsParserHighlightCurrentTag == 1
      let &l:updatetime = g:TagsParserUpdateTime
    endif
    
    "command to go to tag in previous window:
    nmap <buffer> <silent> <CR> :call <SID>TagsParserSelectTag()<CR>
    nmap <buffer> <silent> <2-LeftMouse>
          \ :call <SID>TagsParserSelectTag()<CR>

    "the augroup we are going to setup will override this initial
    "autocommand so stop it from running
    autocmd! TagsParserBufEnterWindowNotOpen

    "setup and autocommand so that when you enter a new buffer, the new file is
    "parsed and then displayed
    augroup TagsParserBufEnterEvents
      autocmd!
      autocmd BufEnter ?* call <SID>TagsParserHandleBufEnter()
      
      "when a file is written, add an event so that the new tag file is parsed
      "and displayed (if there are updates)
      autocmd BufWritePost ?* call <SID>TagsParserParseCurrentFile() |
            \ call <SID>TagsParserDisplayTags()

      "properly handle the BufWinLeave event
      autocmd BufWinLeave ?* call <SID>TagsParserHandleBufWinLeave()

      "make sure that we don't accidentally close the Vim session when loading
      "up a new buffer
      autocmd BufAdd * let s:newBufBeingCreated = 1
    augroup end

    "add the event to do the auto tag highlighting if the event is set
    if g:TagsParserHighlightCurrentTag == 1
      augroup TagsParserCursorHoldEvent
        autocmd!
        autocmd CursorHold ?* call <SID>TagsParserHighlightTag(0)
      augroup end
    endif

    if !hlexists('TagsParserFileName')
      hi link TagsParserFileName Underlined
    endif

    if !hlexists('TagsParserTypeName')
      hi link TagsParserTypeName Special 
    endif

    if !hlexists('TagsParserTag')
      hi link TagsParserTag Normal
    endif

    if !hlexists('TagsParserFoldMarker')
      hi link TagsParserFoldMarker Ignore
    endif

    if !hlexists('TagsParserHighlight')
      hi link TagsParserHighlight ToDo
    endif

    "setup the syntax for the tags window
    syntax match TagsParserTag '\(- \)\@<!\S\(.*\( {{{\)\@=\|.*\)'
          \ contains=TagsParserFoldMarker
    syntax match TagsParserFileName '^\w\S*'
    syntax match TagsParserTypeName '^\t*- .*' contains=TagsParserFoldMarker
    syntax match TagsParserFoldMarker '{{{.*\|\s*}}}'
  " elseif <SID>TagsParserFindTagWindow() == -1
  "   exec s:TagsWindowPosition . " " . g:TagsParserWindowSize  . " split " .
  "         g:TagsParserWindowName
  endif " if !bufloaded(g:TagsParserWindowName)

  "display the tags
  call <SID>TagsParserDisplayTags()

  "go back to the previous window, find the winnr for the buffer, and
  "do a :<N>wincmd w
  exec bufwinnr(s:origFileName) . "wincmd w"

  "un ignore events 
  let &eventignore=l:oldEvents
  unlet l:oldEvents
  
  "highlight the current tag (if flag is set)
  if g:TagsParserHighlightCurrentTag == 1
    call <SID>TagsParserHighlightTag(1)
  endif
endfunction
" >>>
" TagsParserCloseTagWindow - Closes The tags window <<<
function! <SID>TagsParserCloseTagWindow(closeCommand)
  "ignore events while opening the tag window
  let l:oldEvents = &eventignore
  set eventignore=all

  "if the window exists, find it and close it
  if bufloaded(g:TagsParserWindowName)
    "save current file bufnr
    let l:curBufNum = bufnr("%")

    "save the current tags window size
    let l:tagsWindowSize = winwidth(bufwinnr(g:TagsParserWindowName))
 
    "go to and close the tags window
    exec bufwinnr(g:TagsParserWindowName) . "wincmd w"
    exec a:closeCommand

    if g:TagsParserNoResize == 0
      "resize the Vim window
      if g:TagsParserWindowSize == l:tagsWindowSize && s:newColumns == &columns
        let &columns = &columns - s:columnsAdded
      else
        "if the window sizes have been changed since the window was opened,
        "attempt to save the new sizes to use later
        let g:TagsParserWindowSize = l:tagsWindowSize
        let &columns = &columns - g:TagsParserWindowSize - 1
      endif
    endif
    
    "now go back to the file we were just in assuming it wasn't the
    "tags window in which case this will simply fail silently
    exec bufwinnr(l:curBufNum) . "wincmd w"

    "zero out the last file displayed variable so that if the tags window is
    "reopened then the tags should be redrawn
    let s:lastFileDisplayed = ""

    "remove all buffer related autocommands
    autocmd! TagsParserBufEnterEvents
    autocmd! TagsParserCursorHoldEvent

    augroup TagsParserBufEnterWindowNotOpen
      autocmd BufEnter ?* call <SID>TagsParserPerformOp("open", "")
    augroup end
  endif
  
  "un ignore events 
  let &eventignore=l:oldEvents
  unlet l:oldEvents
endfunction
" >>>
" TagsParserToggle - Will toggle The tags window open or closed <<<
function! <SID>TagsParserToggle()
  "if the TagsParserOff flag is set, print out an error and do nothing
  if g:TagsParserOff != 0
    echomsg "TagsParser window cannot be opened because plugin is turned off"
    return
  elseif g:TagsParserNoTagWindow == 1
    echomsg "TagsParser window cannot be opened because the Tag window has been disabled by the g:TagsParserNoTagWindow variable"
    return
  endif

  "check to see if the tags window is loaded, if it is not, open it, if it
  "is, close it
  if bufloaded(g:TagsParserWindowName)
    "if the tags parser is forced closed, turn off the auto open/close flag
    if g:TagsParserAutoOpenClose == 1
      let g:TagsParserAutoOpenClose = 0
      let s:autoOpenCloseTurnedOff = 1
    endif

    call <SID>TagsParserCloseTagWindow("close")
  else
    if exists("s:autoOpenCloseTurnedOff") && s:autoOpenCloseTurnedOff == 1
      let g:TagsParserAutoOpenClose = 1
      let s:autoOpenCloseTurnedOff = 0
    endif
    call <SID>TagsParserOpenTagWindow()
  endif
endfunction
" >>>
" TagsParserHandleBufEnter - handles The BufEnter event <<<
function! <SID>TagsParserHandleBufEnter()
  "Before we do anything else, first check if this is the tags window, and if 
  "all other windows are closed.  If this is true then just quit everything 
  "now.
  if s:TagsParserClosedBuffer != "" && bufname("%") == g:TagsParserWindowName && winbufnr(2) == -1
    call <SID>TagsParserCloseTagWindow("confirm qall")

    "If Vim is still open at this point move to the first modifiable buffer 
    "because the user decided not to exit Vim.
    let l:bufnr = 1
    while bufexists(l:bufnr) != -1
      if getbufvar(l:bufnr, "&modified")
        exec l:bufnr . "buffer!"
        echomsg "TagsParser - qall canceled by user, moved to first modified buffer"
        return
      endif
    endwhile
  endif

  "Don't forget to zero out the closed buffer name before we continue
  let s:TagsParserClosedBuffer = ""

  "if the buffer we just entered is unmodifiable do nothing and return
  if &modifiable == 0
    return
  endif

  "if the auto open/close flag is set, see if there is a tag file for the
  "new buffer, if there is, call open, otherwise, call close
  if g:TagsParserAutoOpenClose == 1
    let l:tagFileName = expand("%:p:h") . "/.tags/" .
          \ substitute(expand("%:t"), " ", "_", "g") . ".tags"

    if !filereadable(l:tagFileName)
      call <SID>TagsParserCloseTagWindow("close")
    else
      call <SID>TagsParserOpenTagWindow()
    endif
  else
    "else parse the current file and call display tags
    call <SID>TagsParserParseCurrentFile()
    call <SID>TagsParserDisplayTags()
  endif
endfunction
">>>
" TagsParserHandleBufWinLeave - handles The BufWinLeave event <<<
function! <SID>TagsParserHandleBufWinLeave()
  "if we are unloading the tags window, and the auto open/close flag is on,
  "turn it off
  if bufname("%") == g:TagsParserWindowName
    " If the tags window is being manually closed, turn the auto open/close 
    " feature off.
    if g:TagsParserAutoOpenClose == 1
      let g:TagsParserAutoOpenClose = 0
      let s:autoOpenCloseTurnedOff = 1
    endif
    call <SID>TagsParserCloseTagWindow("close")
  else
    "if this is not the tag window, just store the name of the closed 
    "buffer.
    let s:TagsParserClosedBuffer = bufname("%")
  endif
endfunction
">>>
" TagsParserSelectTag - activates a tag (if it is a tag) <<<
function! <SID>TagsParserSelectTag()
  "before we start finding a tag, make sure we are not on the first line of 
  "the tag window
  if line(".") == 1
    return
  endif

  "ignore events while selecting a tag
  let l:oldEvents = &eventignore
  set eventignore=all

  "clear out any previous match
  if s:matchedTagWasFolded == 1
    exec s:matchedTagFoldStart . "," . s:matchedTagFoldEnd . "foldclose"
    let s:matchedTagWasFolded = 0
  endif

  match none

  if v:version >= 700 && g:TagsParserForceUsePerl != 1
    if !exists('s:globalPrintData')
      let s:globalPrintData = [ ]
    endif

    " subtract 2 (1 for the append offset, and 1 because it starts at 0) from 
    " the line number to get the proper globalPrintData index
    let l:indexNum = line(".") - 2

    " if this is a tag, there will be a reference to the correct tag entry in 
    " the referenced globalPrintData array
    if exists('s:globalPrintData[l:indexNum][1]')
      if foldclosed(line(".")) != -1
        let s:matchedTagFoldStart = foldclosed(line("."))
        let s:matchedTagFoldEnd = foldclosedend(line("."))
        let s:matchedTagWasFolded = 1
        exec s:matchedTagFoldStart . "," . s:matchedTagFoldEnd . "foldopen"
      else
        if line(".") >= s:matchedTagFoldStart && line(".") <= s:matchedTagFoldEnd
          let s:matchedTagWasFolded = 0
        endif
      endif " if foldclosed(line(".")) != -1

      " now match this tag
      exec 'match TagsParserHighlight /\%' . line(".") . 'l\S.*\%( {{{\)\@=/'

      " go to the proper window, go the correct line, unfold it (if 
      " necessary), move to the correct word (the tag) and finally, set a mark
      exec bufwinnr(s:origFileName) . "wincmd w"
      exec s:globalPrintData[l:indexNum][1].line

      " now find out where the tag is on the current line
      let l:position = match(getline("."), '\s\zs' . s:globalPrintData[l:indexNum][1].tag)
      " move to that column if we got a valid value
      if l:position != -1
        exec 'normal 0' . l:position . 'l'
      endif

      if foldclosed(".") != -1
        .foldopen
      endif

      normal m'
    else
      " otherwise we should just toggle this fold open/closed if the line is 
      " actually folded
      if foldclosed(".") != -1
        .foldopen
      else
        .foldclose
      endif
    endif " if exists('s:globalPrintData[l:indexNum][1]')
  else
    call <SID>TagsParserPerlSelectTag()
  endif " if v:version >= 700 && g:TagsParserForceUsePerl != 1

  "un ignore events 
  let &eventignore=l:oldEvents
  unlet l:oldEvents
endfunction
" >>>
" TagsParserHighlightTag - highlights The tag that the cursor is on <<<
function! <SID>TagsParserHighlightTag(resetCursor)
  "if this buffer is unmodifiable, do nothing
  if &modifiable == 0
    return
  endif

  "get the current and tags buffer numbers
  let l:curBufNum = bufnr("%")
  let l:tagBufNum = bufnr(g:TagsParserWindowName)

  "return if the tags buffer is not open or this is the tags window we are
  "currently in
  if l:tagBufNum == -1 || l:curBufNum == l:tagBufNum
    return
  endif

  "before we save the current word, save the value in the "" register so we 
  "can restore it later.
  let l:regStore = @"

  "yank the word under the cursor into register a, and make sure to place the
  "cursor back in the right position
  exec 'normal ma"ayiw`a'
  
  let l:curPattern = getline(".")
  let l:curLine = line(".")
  let l:curWord = getreg("a")

  "ignore events before changing windows
  let l:oldEvents = &eventignore
  set eventignore=all

  "goto the tags window
  exec bufwinnr(l:tagBufNum) . "wincmd w"
  
  "clear out any previous match
  if s:matchedTagWasFolded == 1
    exec s:matchedTagFoldStart . "," . s:matchedTagFoldEnd . "foldclose"
    let s:matchedTagWasFolded = 0
  endif
  let s:matchedTagLine = 0

  match none

  if v:version >= 700 && g:TagsParserForceUsePerl != 1
    if !exists('s:globalPrintData')
      let s:globalPrintData = [ ]
    endif

    if !exists('s:tagsByLine')
      let s:tagsByLine = { }
    endif

    " now look up this tag, try to find an exact match (useful for lists of 
    " variables, enumerations and so on).
    if exists('s:tagsByLine[s:origFileTagFileName][l:curLine]')
      for l:ref in s:tagsByLine[s:origFileTagFileName][l:curLine]
        if l:curPattern[0:len(l:ref.pattern) - 1] == l:ref.pattern
          if l:curWord == l:ref.tag
            let l:trueRef = l:ref
          elseif !exists('l:easyRef')
            let l:easyRef = l:ref
          endif
        endif " if l:curPattern[0:len(l:ref.pattern)] == l:ref.pattern
      endfor " for l:ref in s:tagsByLine[s:origFileTagFileName][l:curLine]
    endif " if exists('s:tagsByLine[s:origFileTagFileName][l:curLine]')

    " if we didn't find an exact match go with the default match
    if !exists('l:trueRef') && exists('l:easyRef')
      let l:trueRef = l:easyRef
    endif

    " now we have to find the correct line for this tag in the globalPrintData
    let l:index = 0
    for l:line in s:globalPrintData
      if exists('l:line[1]') && exists('l:trueRef') && l:line[1] is l:trueRef
        let l:tagLine = l:index + 2

        " if this line is folded, unfold it
        if foldclosed(l:tagLine) != -1
          let s:matchedTagFoldStart = foldclosed(l:tagLine)
          let s:matchedTagFoldEnd = foldclosedend(l:tagLine)
          let s:matchedTagWasFolded = 1
          exec s:matchedTagFoldStart . "," . s:matchedTagFoldEnd . "foldopen"
        else
          " otherwise, if this line is not within the range of the previously 
          " folded area, set the previous fold variable to 0.
          if l:tagLine >= s:matchedTagFoldStart && l:tagLine <= s:matchedTagFoldEnd
            let s:matchedTagWasFolded = 0
          endif
        endif " if foldclosed(l:tagLine) != -1

        " now match this tag
        exec 'match TagsParserHighlight /\%' . l:tagLine . 'l\S.*\%( {{{\)\@=/'

        " now that the tag has been highlighted, go to the tag and make the 
        " line visible, and then go back to the tag line so that the cursor is 
        " in the correct place
        exec l:tagLine
        exec winline()
        exec l:tagLine

        " if the correct line was found, break out of this loop
        break
      endif " if exists('l:line[1]') && l:line[1] is l:trueRef

      let l:index += 1
    endfor " for l:line in s:globalPrintData
  else
    call <SID>TagsParserPerlFindTag(l:curPattern, l:curLine, l:curWord)
  endif " if v:version >= 700 && g:TagsParserForceUsePerl != 1
  
  "before we go back to the previous window... Check if we found a match.  If
  "we did not, and the resetCursor parameter is 1 then move the cursor to the
  "top of the window
  if a:resetCursor == 1 && s:matchedTagLine == 0
    exec 1
    exec winline()
    exec 1
  endif

  "restore the value of the "" regsiter
  let @" = l:regStore

  "go back to the old window
  exec bufwinnr(l:curBufNum) . "wincmd w"

  "un ignore events 
  let &eventignore=l:oldEvents
  unlet l:oldEvents

  return
endfunction
">>>
" TagsParserFoldFunction - function to make proper tags for folded tags <<<
function! TagsParserFoldFunction()
  let l:line = getline(v:foldstart)
  let l:tabbedLine = substitute(l:line, "\t", "  ", "g")
  let l:finishedLine = substitute(l:tabbedLine, " {{{.*", "", "")
  let l:numLines = v:foldend - v:foldstart
  return l:finishedLine . " : " . l:numLines . " lines"
endfunction
" >>>
" TagsParserOff - function to turn off all TagsParser functionality <<<
function! <SID>TagsParserOff()
  "only do something if The TagsParser is not off already
  if g:TagsParserOff == 0
    "to turn off the TagsParser, call the TagsParserCloseTagWindow() function,
    "which will uninstall all autocommands except for the default
    "TagsParserAutoCommands group (which is always on) and the
    "TagsParserBufEnterWindowNotOpen group (which is on when the window is
    "closed)
    call <SID>TagsParserCloseTagWindow("close")
    
    autocmd! TagsParserAutoCommands
    autocmd! TagsParserBufEnterWindowNotOpen

    "finally, set the TagsParserOff flag to 1
    let g:TagsParserOff = 1
  endif
endfunction
" >>>
" TagsParserOn - function to turn all TagsParser functionality back on <<<
function! <SID>TagsParserOn()
  "only do something if The TagsParser is off
  if g:TagsParserOff != 0 && g:TagsParserNoTagWindow == 0
    augroup TagsParserAutoCommands
      autocmd!
      "setup an autocommand that will expand the path described by
      "g:TagsParserTagsPath into a valid tag path
      autocmd VimEnter * call <SID>TagsParserExpandTagsPath() |
            \ call <SID>TagsParserPerformOp("open", "")

      "setup an autocommand so that when a file is written to it writes a tag
      "file if it a file that is somewhere within the tags path or the
      "g:TagsParserTagsPath path
      autocmd BufWritePost ?* call <SID>TagsParserPerformOp("tag", "")
    augroup end

    augroup TagsParserBufEnterWindowNotOpen
      autocmd BufEnter ?* call <SID>TagsParserPerformOp("open", "")
    augroup end
  elseif g:TagsParserOff != 0 && g:TagsParserNoTagWindow == 1
    augroup TagsParserAutoCommands
      autocmd!
      "setup an autocommand that will expand the path described by 
      "g:TagsParserTagsPath into a valid tag path
      autocmd VimEnter * call <SID>TagsParserExpandTagsPath()

      "setup an autocommand so that when a file is written to it writes a tag
      "file if it a file that is somewhere within the tags path or the
      "g:TagsParserTagsPath path
      autocmd BufWritePost ?* call <SID>TagsParserPerformOp("tag", "")
    augroup end
  endif
  let g:TagsParserOff = 0
endfunction
" >>>
" TagsParserCOpen - opens The quickfix window nicely <<<
function! <SID>TagsParserCOpen(...)
  let l:windowClosed = 0

  "if the tag window is open, close it
  if bufloaded(g:TagsParserWindowName) && s:TagsWindowPosition =~ "vertical"
    call <SID>TagsParserCloseTagWindow("close")
    let l:windowClosed = 1
  endif

  "get the current window number
  let l:curBuf = bufnr("%")

  "now open the quickfix window
  if(a:0 == 1)
    exec "copen " . a:1
  else
    exec "copen"
  endif

  "go back to the original window
  exec bufwinnr(l:curBuf) . "wincmd w"

  "go to the first error
  exec "cfirst"

  "reopen the tag window if necessary
  if l:windowClosed == 1
    call <SID>TagsParserOpenTagWindow()
  endif
endfunction
" >>>
" TagsParserCWindow - opens The quickfix window nicely <<<
function! <SID>TagsParserCWindow(...)
  let l:windowClosed = 0

  "if the tag window is open, close it
  if bufloaded(g:TagsParserWindowName) && s:TagsWindowPosition =~ "vertical"
    call <SID>TagsParserCloseTagWindow("close")
    let l:windowClosed = 1
  endif

  "get the current window number
  let l:curBuf = bufnr("%")

  "now open the quickfix window
  if(a:0 == 1)
    exec "cwindow " . a:1
  else
    exec "cwindow"
  endif
  
  "go back to the original window, if we actually changed windows
  if l:curBuf != bufnr("%")
    exec bufwinnr(l:curBuf) . "wincmd w"

    "go to the first error
    exec "cfirst"
  endif

  "reopen the tag window if necessary
  if l:windowClosed == 1
    call <SID>TagsParserOpenTagWindow()
  endif
endfunction
" >>>
" TagsParserTagSort - Sort function for tag entries based on tag name <<<
function! TagsParserTagSort(one, two)
  return a:one.tag == a:two.tag ? 0 : a:one.tag > a:two.tag ? 1 : -1
endfunction
" >>>
" TagsParserLineSort - Sort function for tag entries based on line # <<<
function! TagsParserLineSort(one, two)
  return (0 + a:one.line) == (0 + a:two.line) ? 0 : (0 + a:one.line) > (0 + a:two.line) ? 1 : -1
endfunction
" >>>
" TagsParserReverseLineSort - Like TagsParserLineSort but reversed <<<
function! TagsParserReverseLineSort(one, two)
  return (0 + a:two.line) == (0 + a:one.line) ? 0 : (0 + a:two.line) > (0 + a:one.line) ? 1 : -1
endfunction
" >>>

" Perl Functions

" TagsParserPerlFinishPerformOp - Call the correct op on files in the list <<<
function! <SID>TagsParerPerlFinishPerformOp(fileList)
perl << PerlFunc
  use strict;
  use warnings;
  no warnings 'redefine';

  my ($success, $files) = VIM::Eval('a:fileList');
  die "Failed to access list of files to tag" if !$success; 

  foreach my $file (split(/\n/, $files)) {
    VIM::DoCommand "call <SID>TagsParserPerformOp('tag', '" . $file . "')";
  }
PerlFunc
endfunction
" >>>
" TagsParserPerlDisplayTags - Display perl tags data <<<
function! <SID>TagsParserPerlDisplayTags()
perl << PerlFunc
  use strict;
  use warnings;
  no warnings 'redefine';

  our %typeMap : unique unless (%typeMap);
  our %subTypeMap : unique unless (%subTypeMap);

  # verify that we are able to display the correct file type
  my ($success, $kind) = VIM::Eval('s:origFileType');
  die "Failed to access filetype" if !$success;

  # get the name of the tag file for this file
  ($success, my $tagFileName) = VIM::Eval('s:origFileTagFileName');
  die "Failed to access tag file name ($tagFileName)" if !$success;

  # make sure that %tags is created (or referenced)
  our %tags : unique unless (%tags);

  # temp array to store our tag info... At the end of the file we will check
  # to see if this is different than the globalPrintData, if it is we update
  # the screen, if not then we do nothing so as to maintain any folded sections
  # the user has created.
  my @printData = ( );

  my $printLevel = 0;

  # get the name of the tag file for this file
  ($success, my $fileName) = VIM::Eval('s:origFileName');
  die "Failed to access file name ($fileName)" if !$success;

  # get the sort type flag
  ($success, my $sortType) = VIM::Eval('g:TagsParserSortType');
  die "Failed to access sort type ($sortType)" if !$success;

  # check on how we should display the tags
  ($success, my $dispSig) = VIM::Eval('g:TagsParserDisplaySignature');
  die "Failed to access display signature flag" if !$success;

  sub DisplayEntry {
    my $entryRef = shift(@_);
    my $localPrintLevel = shift(@_);

    # set the display string, tag or signature
    my $dispString;
    if ($dispSig == 1) {
      $dispString = $entryRef->{"pattern"};

      # remove all whitespace from the beginning and end of the display string
      $dispString =~ s/^\s*(.*)\s*$/$1/;
    }
    else {
      $dispString = $entryRef->{"tag"};
    }

    # each tag must have a {{{ at the end of it or else it could mess with the
    # folding... Since there are no end folds each tag must have a fold marker
    push @printData, [ ("\t" x $localPrintLevel) . $dispString .
      " {{{" . ($localPrintLevel + 1), $entryRef ];

    # now print any members there might be
    if (defined($entryRef->{"members"}) and
        defined($subTypeMap{$kind}{$entryRef->{"tagtype"}})) {
      $localPrintLevel++;
      # now print any members that this entry may have, only
      # show types which make sense, so for a "s" entry only
      # display "m", this is based on the subTypeMap data
      foreach my $subTypeRef (@{$subTypeMap{$kind}{$entryRef->{"tagtype"}}}) {
        # for each entry in the subTypeMap for this particular
        # entry, check if there are any entries, if there are print them
        if (defined $entryRef->{"members"}{$subTypeRef->[0]}) {
          # display a header (if one exists)
          if ($subTypeRef->[1] ne "") {
            push @printData, [ ("\t" x $localPrintLevel) . $subTypeRef->[1] .
              " {{{" . ($localPrintLevel + 1) ];
            $localPrintLevel++;
          }
       
          # display the data for this sub type, sort them properly based
          # on the global flag
          if ($sortType eq "alpha") {
            foreach my $member (sort { $a->{"tag"} cmp $b->{"tag"} }
              @{$entryRef->{"members"}{$subTypeRef->[0]}}) {
              DisplayEntry($member, $localPrintLevel);
            }
          }
          else {
            foreach my $member (sort { $a->{"line"} <=> $b->{"line"} }
              @{$entryRef->{"members"}{$subTypeRef->[0]}}) {
              DisplayEntry($member, $localPrintLevel);
            }
          }
       
          # reduce the print level if we increased it earlier
          # and print a fold end marker
          if ($subTypeRef->[1] ne "") {
            $localPrintLevel--;
          }
        }
      }
      $localPrintLevel--;
    }
  }

  # at the very top, print out the filename and a blank line
  push @printData, [ "$fileName {{{" . ($printLevel + 1) ];
  push @printData, [ "" ];
  $printLevel++;

  foreach my $ref (@{$typeMap{$kind}}) {
    # verify that there are any entries defined for this particular tag
    # type before we start trying to print them and that they don't have a
    # parent tag.

    my $printTopLevelType = 0;
    foreach my $typeCheckRef (@{$tags{$tagFileName}{$ref->[0]}}) {
      $printTopLevelType = 1 if !defined($typeCheckRef->{"parent"});
    }
     
    if ($printTopLevelType == 1) {
      push @printData, [ ("\t" x $printLevel) . $ref->[1] . " {{{" .
        ($printLevel + 1) ] ;
    
      $printLevel++;
      # now display all the tags for this particular type, and sort them
      # according to the sortType
      if ($sortType eq "alpha") {
        foreach my $tagRef (sort { $a->{"tag"} cmp $b->{"tag"} }
          @{$tags{$tagFileName}{$ref->[0]}}) {
          unless (defined $tagRef->{"parent"}) {
            DisplayEntry($tagRef, $printLevel);
          }
        }
      }
      else {
        foreach my $tagRef (sort { $a->{"line"} <=> $b->{"line"} }
          @{$tags{$tagFileName}{$ref->[0]}}) {
          unless (defined $tagRef->{"parent"}) {
            DisplayEntry($tagRef, $printLevel);
          }
        }
      }
      $printLevel--;

      # between each listing put a line
      push @printData, [ "" ];
    }
  }

  # this hash will be used to keep all of the data referenceable... So that we
  # will be able to print the correct information, reach that info when the tag
  # is to be selected, and find the current tag that the cursor is on in the
  # main window
  our @globalPrintData : unique = ( ) unless(@globalPrintData);

  # check the last file displayed... If it is blank then this is a forced
  # update
  ($success, my $lastFileDisplayed) = VIM::Eval('s:lastFileDisplayed');
  die "Failed to access last file displayed" if !$success;

  # check to see if the data has changed
  my $update = 1;
  if (($lastFileDisplayed ne "") and ($#printData == $#globalPrintData)) {
    $update = 0;
    for ( my $index = 0; $index <= $#globalPrintData; $index++ ) {
      if ($printData[$index][0] ne $globalPrintData[$index][0]) {
        $update = 1;
      }
      # no matter if the display data changed or not, make sure to assign the
      # tag reference to the global data... Otherwise things like line numbers
      # may have changed and the tag window would not have the proper data
      $globalPrintData[$index][1] = $printData[$index][1];
    }
  }

  # if the data did not change, do nothing and quit
  if ($update == 1) {
    # set the globalPrintData array to the new print data contents
    @globalPrintData = @printData;

    # first clean the window
    $main::curbuf->Delete(1, $main::curbuf->Count());

    # set the first line
    $main::curbuf->Set(1, "");

    # append the rest of the data into the window, if this line looks
    # frightening, do a "perldoc perllol" and look at the Slices section
    $main::curbuf->Append(1, map { $printData[$_][0] } 0 .. $#printData);
  }

  # if the fold level is not set, go through the window now and fold any
  # tags that have members
  ($success, my $foldLevel) = VIM::Eval('exists("g:TagsParserFoldLevel")');
  $foldLevel = -1 if($success == 0 || $foldLevel == 0);

  our %typeMapHeadingFold : unique = ( ) unless(%typeMapHeadingFold);

  FOLD_LOOP:
  for (my $index = 0; my $line = $globalPrintData[$index]; $index++) {
    # if this is a heading which has been marked for folding, fold it
    if ((defined $typeMapHeadingFold{$kind}) and
           (not defined $line->[1]) and ($line->[0] =~ /^\s+- .* {{{\d+$/)) {
      foreach my $heading (@{$typeMapHeadingFold{$kind}}) {
        VIM::DoCommand("if foldclosed(" . ($index + 2) . ") == -1 | " .
                       ($index + 2) . "foldclose | endif")
          if ($line->[0] =~ /^\s+$heading {{{\d+$/);
      }
    }
    # if this is a tag that has a parent and members, fold it
    elsif (($foldLevel == -1) and (defined $line->[1]) and
           (defined $line->[1]{"members"}) and
           (defined $line->[1]{"parent"})) {
      VIM::DoCommand("if foldclosed(" . ($index + 2) . ") == -1 | " .
                     ($index + 2) . "foldclose | endif");
    }
    # we should fold all tags which only have members with empty headings
    elsif (($foldLevel == -1) and (defined $line->[1]{"members"})) {
      foreach my $memberKey (keys %{$line->[1]{"members"}}) {
        foreach my $possibleType
          (@{$subTypeMap{$kind}{$line->[1]{"tagtype"}}}) {
          # immediately skip to the next loop iteration if we find that a
          # member exists for this tag which contains a non-empty heading
          next FOLD_LOOP if (($memberKey eq $possibleType->[0]) and
                             ($possibleType->[1] ne ""));
        }
      }

      # if we made it this far then this tag should be folded
      VIM::DoCommand("if foldclosed(" . ($index + 2) . ") == -1 | " .
                     ($index + 2) . "foldclose | endif");
    }
  }
PerlFunc
endfunction
" >>>
" TagsParserPerlParseFile - Gather perl tags data <<<
function! <SID>TagsParserPerlParseFile(tagFileName)
perl << PerlFunc
  use strict;
  use warnings;
  no warnings 'redefine';

  use File::stat;

  # use local to keep %tags available for other functions
  our %tags : unique unless (%tags);
  our %tagMTime : unique unless (%tagMTime);
  our %tagsByLine : unique unless(%tagsByLine);
  our %kindMap : unique unless(%kindMap);
  
  # get access to the tag file and check it's last modify time
  my ($success, $tagFile) = VIM::Eval('a:tagFileName');
  die "Failed to access tag file variable ($tagFile)" if !$success;

  my $tagInfo = stat($tagFile);
  die "Failed to stat $tagFile" if !$tagInfo;

  # initialize the last modify time if it has not been accessed yet
  $tagMTime{$tagFile} = 0 if !defined($tagMTime{$tagFile});

  # if this file has been tagged before and the tag file has not been
  # updated, just exit
  if ($tagInfo->mtime <= $tagMTime{$tagFile}) {
    VIM::DoCommand "let s:tagsDataUpdated = 0";
    return;
  }
  $tagMTime{$tagFile} = $tagInfo->mtime;
  VIM::DoCommand "let s:tagsDataUpdated = 1";

  # if the tag entries are defined already for this file, delete them now
  delete $tags{$tagFile} if defined($tags{$tagFile});

  # open up the tag file and read the data
  open(TAGFILE, "<", $tagFile) or die "Failed to open tagfile $tagFile";
  while(<TAGFILE>) {
    next if /^!_TAG.*/;
    # process the data
    chomp;

    # split the stuff around the pattern with tabs, and remove the pattern
    # using the special separator ;" character sequence to guard against the
    # possibility of embedded tabs in the pattern
    my ($tag, $file, $rest) = split(/\t/, $_, 3);
    (my $pattern, $rest) = split(/;"\t/, $rest, 2);
    my ($type, $fields) = split(/\t/, $rest, 2);

    # cleanup pattern to remove the / /;" from the beginning and end of the
    # tag search pattern, the hard part is that sometimes the $ may not be at
    # the end of the pattern
    if ($pattern =~ m|/\^(.*)\$/|) {
      $pattern = $1;
    }
    else {
      $pattern =~ s|/\^(.*)/|$1|;
    }

    # there may be some escaped /'s in the pattern, un-escape them
    $pattern =~ s|\\/|/|g;

    # if the " file:" tag is here, remove it, we want it to be in the file
    # since Vim can use the file: field to know if something is file static,
    # but we don't care about it much for this script, and it messes up my
    # hash creation
    $fields =~ s/\tfile://;

    ($success, my $noSeparator) = VIM::Eval(
      "$tag !~ g:TagsParserCtagsQualifiedTagSeparator");
    die "Failed to check if $tag contains a qualified tag separator"
      if !$success;
    
    if ($noSeparator) {
      push @{$tags{$tagFile}{$type}}, { "tag", $tag, "tagtype", $type,
        "pattern", $pattern, split(/\t|:/, $fields) };
    }
  }
  close(TAGFILE);

  # before worrying about anything else, make up a line number-oriented hash of
  # the tags, this will make finding a match, or what the current tag is easier
  delete $tagsByLine{$tagFile} if defined($tagsByLine{$tagFile});

  while (my ($key, $typeArray) = each %{$tags{$tagFile}}) {
    foreach my $tagEntry (@{$typeArray}) {
      push @{$tagsByLine{$tagFile}{$tagEntry->{"line"}}}, $tagEntry;
    }
  }

  ($success, my $kind) = VIM::Eval('&filetype');
  die "Failed to access current file type" if !$success;

  ($success, my $noNestedTags) = VIM::Eval('g:TagsParserNoNestedTags');
  die "Failed to access the nested tag display flag" if !$success;

  # parse the data we just read into hierarchies... If we don't have a
  # kind hash entry for the current file type, just skip the rest of this
  # function
  return if (not defined($kindMap{$kind}) or $noNestedTags == 1);

  # for each key, sort it's entries.  These are the tags for each tag,
  # check for any types which have a scope, and if they do, reference that type
  # to the correct parent type
  #
  # yeah, this loop sucks, but I haven't found a more efficient way to do
  # it yet
  foreach my $key (keys %{$tags{$tagFile}}) {
    foreach my $tagEntry (@{$tags{$tagFile}{$key}}) {
      while (my ($tagType, $tagTypeName) = each %{$kindMap{$kind}}) {
        # search for any member types of the current tagEntry, but only if
        # such a member is defined for the current tag
        if (defined($tagEntry->{$tagTypeName}) and
            defined($tags{$tagFile}{$tagType})) {
          # sort the possible member entries into reverse order by line number 
          # so that when looking for the parent entry we are sure to only get
          # the one who's line is just barely less than the current tag's line
          FIND_PARENT:
          foreach my $tmpEntry (sort { $b->{"line"} <=> $a->{"line"} }
            @{$tags{$tagFile}{$tagType}}) {
            # for the easiest way to do this, only consider tags a match if
            # the line number of the possible parent tag is less than or equal
            # to the line number of the current tagEntry
            if (($tmpEntry->{"tag"} eq $tagEntry->{$tagTypeName}) and
              ($tmpEntry->{"line"} <= $tagEntry->{"line"})) {
              # push a reference to the current tag onto the parent tag's
              # member stack
              push @{$tmpEntry->{"members"}{$key}}, $tagEntry;
              $tagEntry->{"parent"} = $tmpEntry;
              last FIND_PARENT;
            }
          }
        }
      }
    }
  }

  # processing those local vars for C
  if (($kind =~ /c|h|cpp/) and (defined $tags{$tagFile}{"l"}) and
    (defined $tags{$tagFile}{"f"})) {
    # setup a reverse list of local variable references sorted by line
    my @vars = sort { $b->{"line"} <=> $a->{"line"} } @{$tags{$tagFile}{"l"}};

    # sort the functions by reversed line entry... Then we will go through the
    # list of local variables until we find one who's line number exceeds that
    # of the functions.  Then we unshift the array and go to the next function
    FUNC: foreach my $funcRef (sort { $b->{"line"} <=> $a->{"line"} }
      @{$tags{$tagFile}{"f"}}) {
      VAR: while (my $varRef = shift @vars) {
        if ($varRef->{"line"} >= $funcRef->{"line"}) {
          push @{$funcRef->{"members"}{"l"}}, $varRef;
          $varRef->{"parent"} = $funcRef;
          next VAR;
        }
        else {
          unshift(@vars, $varRef);
          next FUNC;
        }
      }
    }
  }
PerlFunc
endfunction
" >>>
" TagsParserPerlSelectTag - Use perl data move to current tag <<<
function! <SID>TagsParserPerlSelectTag()
perl << PerlFunc
  use strict;
  use warnings;
  no warnings 'redefine';

  my ($success, $lineNum) = VIM::Eval('line(".")');
  die "Failed to access The current line" if !$success;

  our @globalPrintData : unique unless(@globalPrintData);

  # subtract 2 (1 for the append offset, and 1 because it starts at 0) from
  # the line number to get the proper globalPrintData index
  my $indexNum = $lineNum - 2;

  # if this is a tag, there will be a reference to the correct tag entry in
  # the referenced globalPrintData array
  if (defined $globalPrintData[$indexNum][1]) {
    # if this line is folded, unfold it
    ($success, my $folded) = VIM::Eval("foldclosed($lineNum)");
    die "Failed to verify if $lineNum is folded" if !$success;

    if ($folded != -1) {
      ($success, my $foldEnd) = VIM::Eval("foldclosedend($lineNum)");
      die "Failed to retrieve end of fold for line $lineNum" if !$success;

      VIM::DoCommand "let s:matchedTagFoldStart = $folded";
      VIM::DoCommand "let s:matchedTagFoldEnd = $foldEnd";

      VIM::DoCommand "let s:matchedTagWasFolded = 1";
      VIM::DoCommand $folded . "," . $foldEnd . "foldopen";
    } # if ($folded != -1) {
    else {
      ($success, my $matchedWasFolded) = VIM::Eval("s:matchedTagWasFolded");
      die "Failed to retrieve matchedTagWasFolded value" if !$success;

      if ($matchedWasFolded == 1) {
        ($success, my $matchedFoldStart) = VIM::Eval("s:matchedTagFoldStart");
        die "Failed to retrieve start of old folded area" if !$success;
        ($success, my $matchedFoldEnd) = VIM::Eval("s:matchedTagFoldEnd");
        die "Failed to retrieve end of old folded area" if !$success;

        # otherwise, if this line is not within the range of the previously 
        # folded area, set the previous fold variable to 0.
        if (($folded >= $matchedFoldStart) && ($folded <= $matchedFoldEnd)) {
          VIM::DoCommand "let s:matchedTagWasFolded = 0";
        }
      } # if ($matchedWasFolded == 1) {
    } # ! if ($folded != -1) {

    # now match this tag
    VIM::DoCommand 'match TagsParserHighlight /\%' . $lineNum .
      'l\S.*\( {{{\)\@=/';

    # go to the proper window, go the correct line, unfold it (if necessary),
    # move to the correct word (the tag) and finally, set a mark
    VIM::DoCommand 'exec bufwinnr(s:origFileName) . "wincmd w"';
    VIM::DoCommand $globalPrintData[$indexNum][1]{"line"};

    # now find out where the tag is on the current line, and move to it if a
    # valid match is found
    VIM::DoCommand "let l:position = match(getline('.'), '\\s\\zs" .
      $globalPrintData[$indexNum][1]{"tag"} . "') | if l:position != -1 | " .
      "exec 'normal 0' . l:position . 'l' | endif";

    VIM::DoCommand "if foldclosed('.') != -1 | .foldopen | endif";
    VIM::DoCommand "normal m\'";
  } # if (defined $globalPrintData[$indexNum][1]) {
  else {
    # otherwise we should just toggle this fold open/closed if the line is
    # actually folded
    VIM::DoCommand "if foldclosed('.') != -1 | .foldopen | else | .foldclose | endif";
  }
PerlFunc
endfunction
" >>>
" TagsParserPerlFindTag - Find currently highlighted tag in perl tag data <<<
function! <SID>TagsParserPerlFindTag(curPattern, curLine, curWord)
perl << PerlFunc
  use strict;
  use warnings;
  no warnings 'redefine';

  # find the current word and line
  my ($success, $curPattern) = VIM::Eval('a:curPattern');
  die "Failed to access current pattern" if !$success;

  ($success, my $curLine) = VIM::Eval('a:curLine');
  die "Failed to access current line" if !$success;

  # the "normal mayiw`a" command above yanked the word under the cursor into
  # register a
  ($success, my $curWord) = VIM::Eval('a:curWord');
  die "Failed to access current word" if !$success;

  # get the name of the tag file for this file
  ($success, my $tagFileName) = VIM::Eval('s:origFileTagFileName ');
  die "Failed to access file name ($tagFileName)" if !$success;

  our @globalPrintData : unique unless (@globalPrintData);
  our %tagsByLine : unique unless(%tagsByLine);

  my $easyRef = undef;
  my $trueRef = undef;

  # now look up this tag, try to find an exact match (useful for lists of
  # variables, enumerations and so on).
  if (defined $tagsByLine{$tagFileName}{$curLine}) {
    TRUE_REF_SEARCH:
    foreach my $ref (@{$tagsByLine{$tagFileName}{$curLine}}) {
      if (substr($curPattern, 0, length($ref->{"pattern"})) eq
          $ref->{"pattern"}) {
        if ($curWord eq $ref->{"tag"}) {
          $trueRef = $ref;
          last TRUE_REF_SEARCH;
        }
        elsif (!defined $easyRef) {
          $easyRef = $ref;
        }
      } # if (substr($curPattern, 0, length($ref->{"pattern"})) eq ...
    } # TRUE_REF_SEARCH: ...

    # if we didn't find an exact match go with the default match
    $trueRef = $easyRef if (not defined($trueRef));

    # now we have to find the correct line for this tag in the globalPrintData
    my $index = 0;
    while (my $line = $globalPrintData[$index++]) {
      if (defined $line->[1] and $line->[1] == $trueRef) {
        my $tagLine = $index + 1;
      
        # if this line is folded, unfold it
        ($success, my $folded) = VIM::Eval("foldclosed($tagLine)");
        die "Failed to verify if $tagLine is folded" if !$success;

        if ($folded != -1) {
          ($success, my $foldEnd) = VIM::Eval("foldclosedend($tagLine)");
          die "Failed to retreive end of fold for line $tagLine" if !$success;

          VIM::DoCommand "let s:matchedTagFoldStart = $folded";
          VIM::DoCommand "let s:matchedTagFoldEnd = $foldEnd";

          VIM::DoCommand "let s:matchedTagWasFolded = 1";
          VIM::DoCommand $folded . "," . $foldEnd . "foldopen";
        }
        else {
          ($success, my $matchedWasFolded) =
            VIM::Eval("s:matchedTagWasFolded");
          die "Failed to retrieve matchedTagWasFolded value" if !$success;

          if ($matchedWasFolded == 1) {
            ($success, my $matchedFoldStart) =
              VIM::Eval("s:matchedTagFoldStart");
            die "Failed to retrieve start of old folded area" if !$success;
            ($success, my $matchedFoldEnd) = VIM::Eval("s:matchedTagFoldEnd");
            die "Failed to retrieve end of old folded area" if !$success;
    
            # otherwise, if this line is not within the range of the
            # previously folded area, set the previous fold variable to 0.
            if (($folded >= $matchedFoldStart) &&
                ($folded <= $matchedFoldEnd)) {
              VIM::DoCommand "let s:matchedTagWasFolded = 0";
            }
          } # if ($matchedWasFolded == 1) {
        }

        # now match this tag
        VIM::DoCommand 'match TagsParserHighlight /\%' . $tagLine .
          'l\S.*\( {{{\)\@=/';
     
        # now that the tag has been highlighted, go to the tag and make the
        # line visible, and then go back to the tag line so that the cursor
        # is in the correct place
        VIM::DoCommand $tagLine;
        VIM::DoCommand "exec winline()";
        VIM::DoCommand $tagLine;

        last;
      } # if ($line->[1] == $trueRef) {
    } # while (my $line = $globalPrintData[$index++]) {
  } # if (defined $tagsByLine{$tagFileName}{$curLine}) {
PerlFunc
endfunction
" >>>

let &cpo = s:cpoSave
unlet s:cpoSave

" vim:ft=Vim:fdm=marker:ff=unix:wrap:ts=2:sw=2:sts=2:sr:et:fmr=<<<,>>>:fdl=0
