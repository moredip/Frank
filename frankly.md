---
layout: default
title: Frankly
---

Frank consists of two parts, a frank *server* which is embedded into
the iPhone application and a Frank *driver* (such as the ruby one used
by cucumber tests). The driver communicates with the embedded server
via a simple HTTP-based wire protocol called **Frankly**. The protocol
consists of sending GET and POST requests to well-known endpoints, and
processing the response. Request and response bodies may contain JSON
(where appropriate) describing the operation to be performed or the
results of that operation respectively.

## UIQuery paths

An essential part of driving a UI is specifying a subset of UI
elements to act upon. Internally the Frank driver uses UISpec to
select a subset of elements, taking advantage of the UIQuery DSL which
is embedded in UISpec. A client driver supplies a UIQuery path in
order to specify a subset of elements.

You can check out the [UISpec
documentation](http://code.google.com/p/uispec/wiki/Documentation) for
more info on UIQuery, and on UISpec in general.

## Response format

Responses may either be _standard_ or _non-standard_. A standard
response always conforms to a format similar to:

    {
      'outcome': 'SUCCESS',
      'results': ['foo','bar']
    }

In addition, a standard response indicating failure will always conform to a format like:

    {
      'outcome': 'ERROR',
      'reason': 'Failed to frob the flib',
      'detail': 'Flange capacitator decoupled'
    }

Non-standard responses will be valid JSON documents, but nothing else is specified.

## Frankly endpoints 

### GET /dump

Request: A plain old GET. Any query parameters are ignored.

Response: a *non-standard* response describing the current state of
the entire application UI.

### POST /map 

Request: a POST containing a JSON document. The JSON document contains
a UIQuery path, and an optional operation to perform on each element
which matches that path.

Response: a *standard* response containing an array for each element
which matched the path. Each array element represents the result of
applying that operation to the path. For example:
		
    {
      'query': 'tableViewCell marked:\'Touch Me!\'',
      'operation': {
        'method_name': 'touch',
        'arguments': []
      }
    }

Notes: You can use the response to either query the state of the UI,
but you can also use it to confirm that the operation you were
attempting to perform was applied to the correct number of
elements. For example you can check that your attempt to touch an
element was successfully applied to exactly 1 element.

If the driver fails to apply the specified operation to an selected
element then it will place a null in the returned array.

If the driver supplies an invalid UIQuery path then a standard error
response will be returned. However if the driver supplies an invalid
*operation* then the server may simply fail to apply the operation to
each selected element, returning an array filled with nulls, equal to
the number of elements in the subset specified by the UIQuery path.
