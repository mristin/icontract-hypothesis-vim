"""Provide a valid module for testing pyicontract-hypothesis."""

import math
import re

import icontract

@icontract.require(lambda x: x > 0)
def some_func(x: float) -> float:
    return math.sqrt(x)

@icontract.require(lambda s: re.match('^prefix.*suffix$', s))
@icontract.ensure(lambda result: result.startswith('preFIX'))
@icontract.ensure(lambda result: result.endswith('sufFIX'))
def another_func(s: str) -> str:
    s = 'PreFIX' + s[len('prefix'):]
    # We forgot to replace 'suffix' with 'sufFIX'
    return s
