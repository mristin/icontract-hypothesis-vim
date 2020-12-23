" Automatically test Python code using icontract-hypothesis
"
" Maintainer:   Marko Ristin (marko@ristin.ch)
" License:      MIT
" Copyright:    2020 (c) Marko Ristin

if exists("g:loaded_icontract_hypothesis")
    finish
endif
let g:loaded_icontract_hypothesis = 1

if executable("pyicontract-hypothesis") != 1
    throw ("executable() could not find pyicontract-hypothesis in your PATH. " .
        \ "Did you install it? Is it included on your PATH?")
endif

function s:IcontractHypothesisTest(
    \   path, firstLine, lastLine, inspect, ...)

    if &modified == 1
        echoerr "The current buffer has unsaved changes. "
            \. "Please save the changes before running pyicontract-hypothesis."
        return
    endif

    let cmd = ["pyicontract-hypothesis", "test"]

    call extend(cmd, ["--path", a:path])

    if a:firstLine == a:lastLine
        call extend(cmd, ["--include", a:firstLine])
    else
        call extend(cmd, ["--include", a:firstLine . "-" . a:lastLine])
    endif

    if a:inspect
        call add(cmd, "--inspect")
    endif

    if len(a:000) > 0
        call add(cmd, "--settings")
        call extend(cmd, a:000)
    endif

    call map(cmd, {idx, val -> shellescape(val)})
    let cmdStr = join(cmd, " ")
    echo system(cmdStr)
endfunction

command -range -nargs=* IcontractHypothesisTest
    \   :call s:IcontractHypothesisTest(
    \       expand("%:p"), <line1>, <line2>, 0, <f-args>)


command -range -nargs=* IcontractHypothesisInspect
    \   :call s:IcontractHypothesisTest(
    \       expand("%:p"), <line1>, <line2>, 1, <f-args>)
